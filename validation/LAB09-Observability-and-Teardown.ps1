<#
 CloudLabs validation | LAB09
 Lab 09: Observability and teardown (Tasks 1-3)
 Lab: AWS Demo || Bedrock with Claude

 Script Type : PowerShellV2      Run As : System
 Parameters  : DeploymentId = GET-DEPLOYMENT-ID, Region = ap-southeast-1 (AccessKey / SecretKey optional; blank = Function App lab credentials)

 Passes when:
   - the 4 /aws/lambda/psb-* log groups keep logs for 7 days
   - metric filter psb-lab-anomaly-batches and alarm psb-lab-scoring-pipeline-stalled match the lab settings
   - teardown done: endpoint psb-anomaly-endpoint deleted, rule psb_telemetry_rule disabled,
     InfluxDB psb-lab-influx deleted (or deleting), no running app in space psb-lab-space
#>
param(
    [string]$DeploymentId,
    [string]$AccessKey,
    [string]$SecretKey,
    [string]$Region = "ap-southeast-1"
)

$LabTitle        = "Lab 09"
$RequiredModules = @("AWS.Tools.CloudWatchLogs", "AWS.Tools.CloudWatch", "AWS.Tools.SageMaker", "AWS.Tools.IoT", "AWS.Tools.TimestreamInfluxDB")
$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"
$message  = $null
$Bucket   = "psb-lab-$DeploymentId"
$failures = [System.Collections.Generic.List[string]]::new()
$verified = [System.Collections.Generic.List[string]]::new()
$ctx      = @{}
$script:checkNo     = 0
$script:TotalChecks = 0
$script:SuccessText = ""

function New-Result([string]$Status, [string]$Message) {
    @{ Status = $Status; Message = $Message } | ConvertTo-Json
}

# Load AWS.Tools modules and sign in with the lab access keys
function Initialize-Aws([string[]]$Modules) {
    # Use AWS.Tools modules when present; otherwise fall back to AWSPowerShell.NetCore / command auto-loading
    $missing = @()
    foreach ($mod in @("AWS.Tools.Common") + $Modules) {
        try { Import-Module $mod -ErrorAction Stop } catch { $missing += $mod }
    }
    if ($missing.Count -gt 0) {
        try { Import-Module AWSPowerShell.NetCore -ErrorAction Stop } catch { Write-Host "Modules not imported explicitly ($($missing -join ', ')); relying on auto-loading." }
    }
    if ($AccessKey -and $SecretKey) {
        Remove-Item Env:AWS_SESSION_TOKEN -ErrorAction SilentlyContinue
        $env:AWS_ACCESS_KEY_ID     = $AccessKey
        $env:AWS_SECRET_ACCESS_KEY = $SecretKey
        Set-AWSCredential -AccessKey $AccessKey -SecretKey $SecretKey -Scope Global
    }
    $env:AWS_REGION         = $Region
    $env:AWS_DEFAULT_REGION = $Region
    Set-DefaultAWSRegion -Region $Region -Scope Global
}

# Runs one check. The body returns nothing on success, or one or more fix messages (strings).
function Test-Step([string]$Name, [scriptblock]$Body) {
    $script:checkNo++
    $label = "[$($script:checkNo)/$($script:TotalChecks)] $Name"
    $problems = @()
    try { $problems = @(& $Body | Where-Object { $_ -is [string] -and $_.Trim() }) }
    catch { $problems = @("Could not check '$Name' ($($_.Exception.Message)). Wait a minute and validate again.") }
    if ($problems.Count -eq 0) {
        Write-Host "$label ... PASS"
        $verified.Add($Name)
    }
    else {
        Write-Host "$label ... FAIL"
        foreach ($p in $problems) { Write-Host "      - $p"; $failures.Add($p) }
    }
}

# Calls AWS and returns $null when the resource does not exist (other errors are re-thrown)
function Get-OrNull([scriptblock]$__call) {
    try { & $__call }
    catch {
        $__msg = "$($_.Exception.Message) $($_.Exception.GetType().Name) $($_.Exception.InnerException.Message)"
        if ($__msg -match 'NotFound|not found|does not exist|NoSuch|cannot be found|Could not find|ResourceNotFound|UserNotFound|No .* found') { return $null }
        throw
    }
}

function Get-AccountId {
    if ($ctx.ContainsKey("account")) { return $ctx["account"] }
    $acct = "*"
    try {
        Import-Module AWS.Tools.SecurityToken -ErrorAction Stop
        $acct = (Get-STSCallerIdentity).Account
    } catch { $acct = "*" }
    $ctx["account"] = $acct
    return $acct
}

# ---------- IAM / resource policy helpers ----------
function ConvertFrom-PolicyDocument([string]$Doc) {
    if (-not $Doc) { return $null }
    $text = $Doc.Trim()
    if ($text -notmatch '^\{') { $text = [System.Uri]::UnescapeDataString($text) }
    return ($text | ConvertFrom-Json)
}
function Get-List($Value) { @($Value) | Where-Object { $null -ne $_ } | ForEach-Object { [string]$_ } }
function Get-PolicyStatements($Policy) { @($Policy.Statement) | Where-Object { $null -ne $_ } }

# True when an Allow statement grants $Action on a resource matching the -like pattern
function Test-PolicyAllows($Policy, [string]$Action, [string]$ResourceLike) {
    foreach ($s in Get-PolicyStatements $Policy) {
        if ("$($s.Effect)" -ne "Allow") { continue }
        if (-not (Get-List $s.Action | Where-Object { $_ -ieq $Action })) { continue }
        if (Get-List $s.Resource | Where-Object { $_ -like $ResourceLike }) { return $true }
    }
    return $false
}
# All resources an Allow statement grants for $Action
function Get-PolicyResources($Policy, [string]$Action) {
    foreach ($s in Get-PolicyStatements $Policy) {
        if ("$($s.Effect)" -ne "Allow") { continue }
        if (Get-List $s.Action | Where-Object { $_ -ieq $Action }) { Get-List $s.Resource }
    }
}
# Lists "*" actions / resources in Allow statements
function Get-PolicyWildcards($Policy) {
    $bad = @()
    foreach ($s in Get-PolicyStatements $Policy) {
        if ("$($s.Effect)" -ne "Allow") { continue }
        foreach ($a in Get-List $s.Action)   { if ($a -eq '*' -or $a -like '*:`*') { $bad += "action '$a'" } }
        foreach ($r in Get-List $s.Resource) { if ($r -eq '*') { $bad += "resource '*'" } }
    }
    return $bad
}

function Get-RoleNameFromArn([string]$Arn) { ($Arn -split '/')[-1] }

# Checks that a role has the named inline policy; stores the parsed document in $ctx["policy:<name>"]
function Test-RoleInlinePolicy([string]$RoleName, [string]$PolicyName, [string]$Owner) {
    $names = @(Get-OrNull { Get-IAMRolePolicyList -RoleName $RoleName })
    if (-not ($names -contains $PolicyName)) {
        return "The execution role $RoleName of $Owner has no inline policy named $PolicyName. Open IAM > Roles > $RoleName > Add permissions > Create inline policy, paste the JSON from the lab guide and name it $PolicyName."
    }
    $doc = (Get-IAMRolePolicy -RoleName $RoleName -PolicyName $PolicyName).PolicyDocument
    $policy = ConvertFrom-PolicyDocument $doc
    $ctx["policy:$PolicyName"] = $policy
    if ($doc -match '%3CAWS-|<AWS-|%3CSECRET-|<SECRET-|%3CDEPLOYMENT-|<DEPLOYMENT-') {
        return "Inline policy $PolicyName on role $RoleName still contains placeholders like <AWS-ACCOUNT-ID>. Replace every <...> value with your real region, account ID, deployment ID or secret ARN."
    }
    $wild = @(Get-PolicyWildcards $policy)
    if ($wild.Count -gt 0) {
        return "Inline policy $PolicyName on role $RoleName allows $($wild -join ', '). Use the least-privilege JSON from the lab guide (specific actions on specific ARNs)."
    }
}

# Checks a Lambda function's basic configuration; stores the configuration in $ctx["lambda:<name>"]
function Test-LambdaBasics([string]$Name, [int]$MemoryMb, [int]$TimeoutSec, [string[]]$EnvNames, [switch]$Influx) {
    $cfg = Get-OrNull { Get-LMFunctionConfiguration -FunctionName $Name }
    if (-not $cfg) { return "Lambda function $Name was not found in $Region. Create it (Author from scratch, Python 3.13, x86_64) as described in the lab guide." }
    $ctx["lambda:$Name"] = $cfg
    $p = @()
    if ("$($cfg.Runtime)" -ne "python3.13") { $p += "Lambda $Name uses runtime $($cfg.Runtime). Recreate it with runtime Python 3.13." }
    if ("$($cfg.Handler)" -ne "lambda_function.lambda_handler") { $p += "Lambda $Name has handler '$($cfg.Handler)'. Set Runtime settings > Handler to lambda_function.lambda_handler." }
    if ([int]$cfg.MemorySize -ne $MemoryMb) { $p += "Lambda $Name has $($cfg.MemorySize) MB memory. Set Configuration > General configuration > Memory to $MemoryMb MB." }
    if ([int]$cfg.Timeout -ne $TimeoutSec) { $p += "Lambda $Name has a $($cfg.Timeout) s timeout. Set Configuration > General configuration > Timeout to $TimeoutSec seconds." }
    $vars = @{}
    if ($cfg.Environment -and $cfg.Environment.Variables) { foreach ($k in $cfg.Environment.Variables.Keys) { $vars[$k] = [string]$cfg.Environment.Variables[$k] } }
    $ctx["env:$Name"] = $vars
    $all = @($EnvNames)
    if ($Influx) { $all = @("INFLUX_URL", "INFLUX_ORG", "INFLUX_BUCKET", "INFLUX_SECRET_ID") + $all }
    $missing = @($all | Where-Object { -not $vars.ContainsKey($_) -or -not $vars[$_] })
    if ($missing.Count -gt 0) { $p += "Lambda $Name is missing environment variable(s) $($missing -join ', '). Add them under Configuration > Environment variables." }
    if ($Influx) {
        if ($vars["INFLUX_URL"] -and $vars["INFLUX_URL"] -notmatch '^https://[^/]+:8086/?$') { $p += "Lambda $Name has INFLUX_URL='$($vars["INFLUX_URL"])'. It must look like https://<INFLUX-ENDPOINT>:8086 (https, port 8086, no path)." }
        if ($vars["INFLUX_ORG"] -and $vars["INFLUX_ORG"] -ne "psb") { $p += "Lambda $Name has INFLUX_ORG='$($vars["INFLUX_ORG"])'. Set it to psb." }
        if ($vars["INFLUX_BUCKET"] -and $vars["INFLUX_BUCKET"] -ne "telemetry") { $p += "Lambda $Name has INFLUX_BUCKET='$($vars["INFLUX_BUCKET"])'. Set it to telemetry." }
        if ($vars["INFLUX_SECRET_ID"] -and $vars["INFLUX_SECRET_ID"] -ne "psb/influxdb/admin-token") { $p += "Lambda $Name has INFLUX_SECRET_ID='$($vars["INFLUX_SECRET_ID"])'. Set it to psb/influxdb/admin-token." }
    }
    return $p
}

# True when the Lambda resource policy lets the given service principal invoke the function
function Test-LambdaInvokePermission([string]$Name, [string]$Service) {
    $resp = Get-OrNull { Get-LMPolicy -FunctionName $Name }
    if (-not $resp) { return $false }
    $json = if ($resp -is [string]) { $resp } else { $resp.Policy }
    if (-not $json) { return $false }
    $pol = $json | ConvertFrom-Json
    foreach ($s in Get-PolicyStatements $pol) {
        if ("$($s.Effect)" -ne "Allow") { continue }
        $svc = @()
        if ($s.Principal -is [string]) { $svc = @($s.Principal) } elseif ($s.Principal.Service) { $svc = Get-List $s.Principal.Service }
        if ($svc -contains $Service) { return $true }
    }
    return $false
}

# Returns the first matching log event in the last N minutes, or $null. Missing group -> $null.
function Find-LogEvent([string]$Group, [string]$Pattern, [int]$Minutes) {
    $start = [DateTimeOffset]::UtcNow.AddMinutes(-$Minutes).ToUnixTimeMilliseconds()
    $token = $null
    $deadline = (Get-Date).AddSeconds(15)
    for ($i = 0; $i -lt 10 -and (Get-Date) -lt $deadline; $i++) {
        $q = @{ LogGroupName = $Group; StartTime = $start; Limit = 5 }
        if ($Pattern) { $q.FilterPattern = $Pattern }
        if ($token) { $q.NextToken = $token }
        $r = Get-OrNull { Get-CWLFilteredLogEvent @q }
        if ($null -eq $r) { return $null }
        if ($r.PSObject.Properties.Name -contains "Events") { $events = @($r.Events); $token = $r.NextToken }
        else { $events = @($r); $token = $null }
        $hit = $events | Where-Object { $_ -and $_.Message } | Select-Object -First 1
        if ($hit) { return $hit }
        if (-not $token) { break }
    }
    return $null
}

# Sum of a CloudWatch metric over the last N hours (works with -UtcStartTime or -StartTime cmdlet versions)
function Get-MetricSum([string]$Namespace, [string]$MetricName, $Dimensions, [int]$Hours) {
    $now = [DateTime]::UtcNow
    $q = @{ Namespace = $Namespace; MetricName = $MetricName; Period = 3600; Statistic = "Sum" }
    $cmd = Get-Command Get-CWMetricStatistic
    if ($cmd.Parameters.ContainsKey("UtcStartTime")) { $q.UtcStartTime = $now.AddHours(-$Hours); $q.UtcEndTime = $now }
    else { $q.StartTime = $now.AddHours(-$Hours); $q.EndTime = $now }
    if ($Dimensions) { $q.Dimension = $Dimensions }
    $r = Get-CWMetricStatistic @q
    $dps = if ($r.PSObject.Properties.Name -contains "Datapoints") { @($r.Datapoints) } else { @($r) }
    $sum = 0.0
    foreach ($d in $dps) { if ($d -and $null -ne $d.Sum) { $sum += [double]$d.Sum } }
    return $sum
}

# S3 objects under a prefix (at most $Max). Missing bucket -> $null
function Get-S3Keys([string]$Prefix, [int]$Max) {
    $objs = Get-OrNull { Get-S3ObjectV2 -BucketName $Bucket -Prefix $Prefix -MaxKey $Max }
    if ($null -eq $objs) { return @() }
    return @($objs | Where-Object { $_ })
}

function Get-InfluxInstance {
    $item = @(Get-TIDBDbInstanceList) | Where-Object { $_.Name -eq "psb-lab-influx" } | Select-Object -First 1
    if (-not $item) { return $null }
    return (Get-TIDBDbInstance -Identifier $item.Id)
}

# The HTTP API psb-lab-api (prefers the copy that has GET /telemetry when more than one exists)
function Get-LabApi {
    if ($ctx.ContainsKey("api")) { return $ctx["api"] }
    $apis = @(Get-AG2ApiList | Where-Object { $_.Name -eq "psb-lab-api" })
    $pick = $null
    foreach ($a in $apis) {
        $routes = @(Get-AG2RouteList -ApiId $a.ApiId)
        if ($routes.RouteKey -contains "GET /telemetry") { $pick = $a; break }
    }
    if (-not $pick -and $apis.Count -gt 0) { $pick = $apis[0] }
    $ctx["api"] = $pick
    return $pick
}

function Get-LabUserPool {
    if ($ctx.ContainsKey("pool")) { return $ctx["pool"] }
    $pool = @(Get-CGIPUserPoolList -MaxResult 60) | Where-Object { $_.Name -eq "psb-lab-users" } | Select-Object -First 1
    $ctx["pool"] = $pool
    return $pool
}

function Get-LabUserPoolClient {
    if ($ctx.ContainsKey("client")) { return $ctx["client"] }
    $pool = Get-LabUserPool
    if (-not $pool) { return $null }
    $c = @(Get-CGIPUserPoolClientList -UserPoolId $pool.Id) | Where-Object { $_.ClientName -eq "psb-lab-dashboard" } | Select-Object -First 1
    $full = $null
    if ($c) { $full = Get-CGIPUserPoolClient -UserPoolId $pool.Id -ClientId $c.ClientId }
    $ctx["client"] = $full
    return $full
}

function Get-LabDomain {
    if ($ctx.ContainsKey("smdomain")) { return $ctx["smdomain"] }
    $d = @(Get-SMDomainList) | Where-Object { $_.DomainName -eq "psb-lab-domain" } | Select-Object -First 1
    $ctx["smdomain"] = $d
    return $d
}


function Invoke-LabChecks {
    $script:TotalChecks = 7

    Test-Step "Log retention 1 week on the 4 Lambda log groups" {
        $groups = @(Get-CWLLogGroup -LogGroupNamePrefix "/aws/lambda/psb-")
        $out = @()
        foreach ($n in @("psb-ingest-telemetry", "psb-query-telemetry", "psb-score-telemetry", "psb-assistant")) {
            $g = $groups | Where-Object { $_.LogGroupName -eq "/aws/lambda/$n" } | Select-Object -First 1
            if (-not $g) { $out += "Log group /aws/lambda/$n was not found. Invoke $n once so the log group is created." ; continue }
            if ([int]$g.RetentionInDays -ne 7) {
                $now = if ($g.RetentionInDays) { "$($g.RetentionInDays) days" } else { "Never expire" }
                $out += "Log group /aws/lambda/$n keeps logs for $now. Set Actions > Edit retention setting to 1 week (7 days)."
            }
        }
        return $out
    }

    Test-Step "Metric filter psb-lab-anomaly-batches" {
        $f = @(Get-OrNull { Get-CWLMetricFilter -LogGroupName "/aws/lambda/psb-score-telemetry" }) | Where-Object { $_ -and $_.FilterName -eq "psb-lab-anomaly-batches" } | Select-Object -First 1
        if (-not $f) { return "Metric filter psb-lab-anomaly-batches was not found on /aws/lambda/psb-score-telemetry. Create it under Metric filters > Create metric filter." }
        $out = @()
        if ("$($f.FilterPattern)" -notlike '*`[ok`] scored=*') { $out += "Metric filter psb-lab-anomaly-batches pattern is '$($f.FilterPattern)'. Set it to `"[ok] scored=`" (with the double quotes)." }
        $t = @($f.MetricTransformations)[0]
        if (-not $t) { $out += "Metric filter psb-lab-anomaly-batches has no metric. Set namespace PSBLab, metric AnomalyBatches, value 1, default 0." }
        else {
            if ($t.MetricNamespace -ne "PSBLab" -or $t.MetricName -ne "AnomalyBatches") { $out += "Metric filter psb-lab-anomaly-batches publishes $($t.MetricNamespace)/$($t.MetricName). Use namespace PSBLab and metric name AnomalyBatches." }
            if ("$($t.MetricValue)" -ne "1") { $out += "Metric filter psb-lab-anomaly-batches metric value is '$($t.MetricValue)'. Set it to 1." }
            if ($null -eq $t.DefaultValue -or [double]$t.DefaultValue -ne 0) { $out += "Metric filter psb-lab-anomaly-batches default value is '$($t.DefaultValue)'. Set it to 0." }
        }
        return $out
    }

    Test-Step "Alarm psb-lab-scoring-pipeline-stalled" {
        $r = Get-CWAlarm -AlarmName "psb-lab-scoring-pipeline-stalled"
        $alarms = if ($r -and $r.PSObject.Properties.Name -contains "MetricAlarms") { @($r.MetricAlarms) } else { @($r) }
        $a = $alarms | Where-Object { $_ -and $_.AlarmName -eq "psb-lab-scoring-pipeline-stalled" } | Select-Object -First 1
        if (-not $a) { return "CloudWatch alarm psb-lab-scoring-pipeline-stalled was not found. Create it on metric PSBLab > AnomalyBatches (Sum, 5 minutes, <= 0, 3 out of 3, missing data = breaching, no notification)." }
        $out = @()
        if ($a.Namespace -ne "PSBLab" -or $a.MetricName -ne "AnomalyBatches") { $out += "Alarm psb-lab-scoring-pipeline-stalled watches $($a.Namespace)/$($a.MetricName). It must use PSBLab/AnomalyBatches." }
        if ("$($a.Statistic)" -ne "Sum") { $out += "Alarm statistic is $($a.Statistic). Set it to Sum." }
        if ([int]$a.Period -ne 300) { $out += "Alarm period is $($a.Period) seconds. Set it to 5 minutes." }
        if ("$($a.ComparisonOperator)" -ne "LessThanOrEqualToThreshold" -or [double]$a.Threshold -ne 0) { $out += "Alarm condition is $($a.ComparisonOperator) $($a.Threshold). Set it to Lower/Equal (<=) 0." }
        if ([int]$a.EvaluationPeriods -ne 3 -or [int]$a.DatapointsToAlarm -ne 3) { $out += "Alarm uses $($a.DatapointsToAlarm) out of $($a.EvaluationPeriods) datapoints. Set Datapoints to alarm to 3 out of 3." }
        if ("$($a.TreatMissingData)" -ne "breaching") { $out += "Alarm treats missing data as '$($a.TreatMissingData)'. Set it to Treat missing data as bad (breaching threshold)." }
        if (@($a.AlarmActions).Where({ $_ }).Count -gt 0) { $out += "Alarm psb-lab-scoring-pipeline-stalled has notification actions. Remove them (no SNS action in this lab)." }
        return $out
    }

    Test-Step "Teardown: endpoint psb-anomaly-endpoint deleted" {
        $e = Get-OrNull { Get-SMEndpoint -EndpointName "psb-anomaly-endpoint" }
        if ($e -and "$($e.EndpointStatus)" -ne "Deleting") { return "Endpoint psb-anomaly-endpoint still exists ($($e.EndpointStatus)). Delete it in SageMaker AI > Inference > Endpoints (and its endpoint configuration)." }
    }

    Test-Step "Teardown: rule psb_telemetry_rule disabled" {
        $r = Get-OrNull { Get-IOTTopicRule -RuleName "psb_telemetry_rule" }
        if ($r -and $r.Rule -and -not $r.Rule.RuleDisabled) { return "IoT rule psb_telemetry_rule is still active. Open IoT Core > Message routing > Rules, select it and choose Deactivate." }
    }

    Test-Step "Teardown: InfluxDB psb-lab-influx deleted" {
        $item = @(Get-TIDBDbInstanceList) | Where-Object { $_ -and $_.Name -eq "psb-lab-influx" } | Select-Object -First 1
        if ($item -and "$($item.Status)" -notin @("DELETING", "DELETED")) { return "InfluxDB psb-lab-influx is still $($item.Status). Delete it (no final snapshot, type delete me to confirm)." }
    }

    Test-Step "Teardown: space psb-lab-space stopped" {
        $running = @(Get-SMAppList) | Where-Object { $_ -and $_.SpaceName -eq "psb-lab-space" -and "$($_.Status)" -in @("InService", "Pending") }
        if ($running) { return "Space psb-lab-space is still running. In SageMaker Studio open JupyterLab and choose Stop on psb-lab-space." }
    }

    $script:SuccessText = "Lab 09 complete: Lambda logs keep 7 days, the psb-lab-anomaly-batches metric filter and psb-lab-scoring-pipeline-stalled alarm are configured, and the endpoint, IoT rule, InfluxDB instance and JupyterLab space are torn down."
}

# ---------------- main ----------------
try {
    if (-not $DeploymentId) { throw "The DeploymentId parameter is empty. Map it to GET-DEPLOYMENT-ID." }
    Write-Host "Region: $Region | DeploymentId: $DeploymentId | Bucket: $Bucket"
    Initialize-Aws -Modules $RequiredModules
    Invoke-LabChecks

    if ($failures.Count -eq 0) {
        $message = New-Result "Succeeded" $script:SuccessText
    }
    else {
        $i = 0
        $list = ($failures | ForEach-Object { $i++; "$i) $_" }) -join " "
        $message = New-Result "Failed" "$LabTitle is not complete yet. Fix the following and validate again: $list"
    }
}
catch {
    Write-Host "`nERROR:"
    Write-Host $_
    $message = New-Result "Failed" "The check could not complete. Please wait a minute and validate again. Details: $($_.Exception.Message)"
}

Write-Host "`n=== FINAL RESPONSE ==="
Write-Host $message

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [System.Net.HttpStatusCode]::OK
    Body       = $message
})
