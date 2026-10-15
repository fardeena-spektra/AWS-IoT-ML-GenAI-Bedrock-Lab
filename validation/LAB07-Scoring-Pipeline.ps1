<#
 CloudLabs validation | LAB07
 Lab 07: Scoring pipeline (Tasks 1-3)
 Lab: AWS Demo || Bedrock with Claude

 Script Type : PowerShellV2      Run As : System
 Parameters  : DeploymentId = GET-DEPLOYMENT-ID, Region = ap-southeast-1 (AccessKey / SecretKey optional; blank = Function App lab credentials)

 Passes when:
   - Lambda psb-score-telemetry is configured (py3.13, 512 MB, 60 s, Influx + SAGEMAKER_ENDPOINT, S3_BUCKET, ANOMALY_CUTOFF, WINDOW_MINUTES)
   - inline psb-lab-score-telemetry-policy grants InvokeEndpoint on psb-anomaly-endpoint and PutObject on curated/*
   - EventBridge rule psb-lab-score-every-5-min (rate(5 minutes), ENABLED) targets the Lambda
   - "[ok] scored=" logged in the last 30 minutes and scored CSV files exist under curated/scored/
#>
param(
    [string]$DeploymentId,
    [string]$AccessKey,
    [string]$SecretKey,
    [string]$Region = "ap-southeast-1"
)

$LabTitle        = "Lab 07"
$RequiredModules = @("AWS.Tools.Lambda", "AWS.Tools.IdentityManagement", "AWS.Tools.EventBridge", "AWS.Tools.CloudWatchLogs", "AWS.Tools.S3")
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
    $script:TotalChecks = 6
    $fn   = "psb-score-telemetry"
    $rule = "psb-lab-score-every-5-min"

    Test-Step "Lambda $fn configuration" {
        Test-LambdaBasics $fn 512 60 @("SAGEMAKER_ENDPOINT", "S3_BUCKET", "ANOMALY_CUTOFF", "WINDOW_MINUTES") -Influx
        $v = $ctx["env:$fn"]
        if ($v) {
            if ($v["SAGEMAKER_ENDPOINT"] -and $v["SAGEMAKER_ENDPOINT"] -ne "psb-anomaly-endpoint") { "Lambda $fn has SAGEMAKER_ENDPOINT='$($v["SAGEMAKER_ENDPOINT"])'. Set it to psb-anomaly-endpoint." }
            if ($v["S3_BUCKET"] -and $v["S3_BUCKET"] -ne $Bucket) { "Lambda $fn has S3_BUCKET='$($v["S3_BUCKET"])'. Set it to $Bucket." }
            $d = 0.0
            if ($v["ANOMALY_CUTOFF"] -and -not [double]::TryParse($v["ANOMALY_CUTOFF"], [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$d)) { "Lambda $fn has ANOMALY_CUTOFF='$($v["ANOMALY_CUTOFF"])'. Paste the number printed by the notebook (for example 1.234)." }
            $w = 0
            if ($v["WINDOW_MINUTES"] -and (-not [int]::TryParse($v["WINDOW_MINUTES"], [ref]$w) -or $w -le 0)) { "Lambda $fn has WINDOW_MINUTES='$($v["WINDOW_MINUTES"])'. Set it to 6." }
        }
    }

    Test-Step "Inline policy psb-lab-score-telemetry-policy" {
        $cfg = $ctx["lambda:$fn"]
        if (-not $cfg) { return "Cannot check the role of $fn because the function was not found." }
        $roleName = Get-RoleNameFromArn $cfg.Role
        $msg = Test-RoleInlinePolicy $roleName "psb-lab-score-telemetry-policy" $fn
        if ($msg) { return $msg }
        $pol = $ctx["policy:psb-lab-score-telemetry-policy"]
        $out = @()
        if (-not (Test-PolicyAllows $pol "sagemaker:InvokeEndpoint" "arn:aws:sagemaker:${Region}:*:endpoint/psb-anomaly-endpoint")) { $out += "psb-lab-score-telemetry-policy must allow sagemaker:InvokeEndpoint on arn:aws:sagemaker:${Region}:<account>:endpoint/psb-anomaly-endpoint." }
        if (-not (Test-PolicyAllows $pol "s3:PutObject" "arn:aws:s3:::$Bucket/curated/*")) { $out += "psb-lab-score-telemetry-policy must allow s3:PutObject on arn:aws:s3:::$Bucket/curated/*." }
        $wide = @(Get-PolicyResources $pol "s3:PutObject" | Where-Object { $_ -notlike "arn:aws:s3:::$Bucket/curated/*" })
        if ($wide.Count -gt 0) { $out += "psb-lab-score-telemetry-policy also allows PutObject on $($wide -join ', '). Restrict it to arn:aws:s3:::$Bucket/curated/*." }
        if (-not (Test-PolicyAllows $pol "secretsmanager:GetSecretValue" "arn:aws:secretsmanager:${Region}:*:secret:psb/influxdb/admin-token*")) { $out += "psb-lab-score-telemetry-policy must allow secretsmanager:GetSecretValue on the psb/influxdb/admin-token secret ARN." }
        return $out
    }

    Test-Step "EventBridge rule $rule" {
        $r = Get-OrNull { Get-EVBRuleDetail -Name $rule }
        if (-not $r) { return "EventBridge rule $rule was not found. In $fn choose Add trigger > EventBridge (CloudWatch Events) > Create a new rule named $rule with schedule expression rate(5 minutes)." }
        $out = @()
        if ("$($r.ScheduleExpression)" -ne "rate(5 minutes)") { $out += "Rule $rule has schedule '$($r.ScheduleExpression)'. Set it to rate(5 minutes)." }
        if ("$($r.State)" -ne "ENABLED") { $out += "Rule $rule is $($r.State). Enable it in EventBridge > Rules." }
        $ctx["rule"] = $true
        return $out
    }

    Test-Step "Rule targets $fn" {
        if (-not $ctx["rule"]) { return "Cannot check targets because rule $rule does not exist." }
        $t = @(Get-EVBTargetsByRule -Rule $rule) | Where-Object { $_ -and $_.Arn -like "*:function:$fn*" }
        if (-not $t) { return "Rule $rule does not target Lambda $fn. Add the function as the rule target (or add the EventBridge trigger from the Lambda console)." }
        if (-not (Test-LambdaInvokePermission $fn "events.amazonaws.com")) { return "Lambda $fn does not allow EventBridge to invoke it. Add the trigger from the Lambda console (it adds the permission) or run aws lambda add-permission with principal events.amazonaws.com." }
    }

    Test-Step "Scheduled scoring ran in the last 30 minutes" {
        $hit = Find-LogEvent "/aws/lambda/$fn" '"[ok] scored="' 30
        if (-not $hit) { return "No '[ok] scored=' line was found in /aws/lambda/$fn in the last 30 minutes. Run the manual-run test event, check the log for errors (endpoint name, cutoff, permissions) and wait for the 5-minute schedule." }
    }

    Test-Step "Scored CSV files under curated/scored/" {
        $k = @(Get-S3Keys "curated/scored/" 50 | Where-Object { $_.Key -ne "curated/scored/backfill-scored.csv" -and $_.Key -notlike "*/" })
        if ($k.Count -eq 0) { return "No scored CSV files from $fn were found under s3://$Bucket/curated/scored/. Check S3_BUCKET and the s3:PutObject permission on curated/*." }
    }

    $script:SuccessText = "Lab 07 complete: psb-score-telemetry is configured with least privilege, runs every 5 minutes from psb-lab-score-every-5-min, logs '[ok] scored=' and writes scored CSV files to s3://$Bucket/curated/scored/."
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
