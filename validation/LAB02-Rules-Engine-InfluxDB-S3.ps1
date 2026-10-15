<#
 CloudLabs validation | LAB02
 Lab 02: Rules Engine to InfluxDB + S3 (Tasks 1-5)
 Lab: AWS Demo || Bedrock with Claude

 Script Type : PowerShellV2      Run As : System
 Parameters  : DeploymentId = GET-DEPLOYMENT-ID, AccessKey / SecretKey = lab AWS access keys, Region = ap-southeast-1

 Passes when:
   - InfluxDB psb-lab-influx is AVAILABLE, publicly accessible, db.influx.medium
   - bucket psb-lab-<DeploymentId> has raw/, curated/, model/
   - role psb-lab-iot-rule-role trusts IoT, has only inline psb-lab-iot-rule-s3-write (PutObject on raw/*)
   - secret psb/influxdb/admin-token exists
   - Lambda psb-ingest-telemetry is configured (py3.13, 256 MB, 15 s, 4 env vars) with inline psb-lab-read-influx-token
   - rule psb_telemetry_rule is enabled with the Lambda + S3 actions
   - telemetry objects exist under raw/ and the ingest log shows "[ok] wrote" in the last 24 hours
#>
param(
    [string]$DeploymentId,
    [string]$AccessKey,
    [string]$SecretKey,
    [string]$Region = "ap-southeast-1"
)

$LabTitle        = "Lab 02"
$RequiredModules = @("AWS.Tools.TimestreamInfluxDB", "AWS.Tools.S3", "AWS.Tools.IdentityManagement", "AWS.Tools.SecretsManager",
                     "AWS.Tools.Lambda", "AWS.Tools.IoT", "AWS.Tools.CloudWatchLogs")
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
    foreach ($mod in @("AWS.Tools.Common") + $Modules) {
        try { Import-Module $mod -ErrorAction Stop }
        catch { throw "PowerShell module $mod is not available on the validation Function App. Add it to requirements.psd1 (see validation/README.md)." }
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
    $script:TotalChecks = 9
    $fn = "psb-ingest-telemetry"

    Test-Step "InfluxDB psb-lab-influx is available" {
        $db = Get-InfluxInstance
        if (-not $db) { return "Timestream for InfluxDB instance psb-lab-influx was not found in $Region. Create it with the settings in Lab 02 Task 1." }
        $ctx["influx"] = $db
        $out = @()
        $st = "$($db.Status)"
        if ($st -ne "AVAILABLE") { $out += "InfluxDB psb-lab-influx is $st. Wait until the status is Available (creation takes 15-20 minutes) and validate again." }
        if (-not $db.PubliclyAccessible) { $out += "InfluxDB psb-lab-influx is not publicly accessible. Recreate it with Public access enabled (the Lambdas reach it over the internet on port 8086)." }
        if ("$($db.DbInstanceType)" -ne "db.influx.medium") { $out += "InfluxDB psb-lab-influx uses $($db.DbInstanceType). Recreate it as db.influx.medium." }
        return $out
    }

    Test-Step "Bucket $Bucket has raw/, curated/, model/" {
        $exists = Get-OrNull { Get-S3ObjectV2 -BucketName $Bucket -Prefix "raw/" -MaxKey 1; "ok" }
        if (-not $exists) { return "Bucket $Bucket was not found. It is pre-created by the lab; make sure you are in region $Region." }
        $missing = @()
        foreach ($f in @("raw/", "curated/", "model/")) {
            if (@(Get-S3Keys $f 1).Count -eq 0) { $missing += $f }
        }
        if ($missing.Count -gt 0) { return "Bucket $Bucket is missing folder(s) $($missing -join ', '). Open the bucket and choose Create folder for each one." }
    }

    Test-Step "IAM role psb-lab-iot-rule-role" {
        $role = Get-OrNull { Get-IAMRole -RoleName "psb-lab-iot-rule-role" }
        if (-not $role) { return "IAM role psb-lab-iot-rule-role was not found. Create it with a custom trust policy for iot.amazonaws.com (Lab 02 Task 2)." }
        $out = @()
        $trust = ConvertFrom-PolicyDocument ([string]$role.AssumeRolePolicyDocument)
        $svc = @(Get-PolicyStatements $trust | ForEach-Object { Get-List $_.Principal.Service })
        if (-not ($svc -contains "iot.amazonaws.com")) { $out += "Role psb-lab-iot-rule-role does not trust iot.amazonaws.com. Edit Trust relationships and use the custom trust policy from the lab guide." }
        $managed = @(Get-IAMAttachedRolePolicyList -RoleName "psb-lab-iot-rule-role")
        if ($managed.Count -gt 0) { $out += "Role psb-lab-iot-rule-role has managed policies attached ($(($managed.PolicyName) -join ', ')). Remove them; it needs only the inline policy psb-lab-iot-rule-s3-write." }
        $msg = Test-RoleInlinePolicy "psb-lab-iot-rule-role" "psb-lab-iot-rule-s3-write" "the IoT rule"
        if ($msg) { $out += $msg }
        else {
            $pol = $ctx["policy:psb-lab-iot-rule-s3-write"]
            $res = @(Get-PolicyResources $pol "s3:PutObject")
            if ($res.Count -eq 0 -or -not (Test-PolicyAllows $pol "s3:PutObject" "arn:aws:s3:::$Bucket/raw/*")) { $out += "Inline policy psb-lab-iot-rule-s3-write must allow s3:PutObject on arn:aws:s3:::$Bucket/raw/*." }
            $wide = @($res | Where-Object { $_ -notlike "arn:aws:s3:::$Bucket/raw/*" })
            if ($wide.Count -gt 0) { $out += "Inline policy psb-lab-iot-rule-s3-write also allows PutObject on $($wide -join ', '). Restrict it to arn:aws:s3:::$Bucket/raw/* only." }
        }
        return $out
    }

    Test-Step "Secret psb/influxdb/admin-token exists" {
        $sec = Get-OrNull { Get-SECSecret -SecretId "psb/influxdb/admin-token" }
        if (-not $sec -or $sec.DeletedDate) { return "Secret psb/influxdb/admin-token was not found. In Secrets Manager store a new secret (Other type of secret) with key token = your InfluxDB admin token, named psb/influxdb/admin-token." }
        $ctx["secretArn"] = [string]$sec.ARN
    }

    Test-Step "Lambda $fn configuration" {
        Test-LambdaBasics $fn 256 15 @() -Influx
        $vars = $ctx["env:$fn"]
        $db = $ctx["influx"]
        if ($vars -and $db -and $db.Endpoint -and $vars["INFLUX_URL"] -and ($vars["INFLUX_URL"] -notlike "*$($db.Endpoint)*")) {
            "Lambda $fn INFLUX_URL does not point to psb-lab-influx. Set it to https://$($db.Endpoint):8086."
        }
    }

    Test-Step "Lambda $fn role has psb-lab-read-influx-token" {
        $cfg = $ctx["lambda:$fn"]
        if (-not $cfg) { return "Cannot check the role of $fn because the function was not found. Create the function first." }
        $roleName = Get-RoleNameFromArn $cfg.Role
        $msg = Test-RoleInlinePolicy $roleName "psb-lab-read-influx-token" $fn
        if ($msg) { return $msg }
        $pol = $ctx["policy:psb-lab-read-influx-token"]
        $want = if ($ctx["secretArn"]) { $ctx["secretArn"] } else { "arn:aws:secretsmanager:${Region}:*:secret:psb/influxdb/admin-token*" }
        $ok = (Test-PolicyAllows $pol "secretsmanager:GetSecretValue" $want) -or (Test-PolicyAllows $pol "secretsmanager:GetSecretValue" "arn:aws:secretsmanager:${Region}:*:secret:psb/influxdb/admin-token*")
        if (-not $ok) { return "Inline policy psb-lab-read-influx-token on role $roleName must allow secretsmanager:GetSecretValue on the secret ARN of psb/influxdb/admin-token (copy the ARN from Secrets Manager)." }
    }

    Test-Step "IoT rule psb_telemetry_rule" {
        $r = Get-OrNull { Get-IOTTopicRule -RuleName "psb_telemetry_rule" }
        if (-not $r -or -not $r.Rule) { return "IoT rule psb_telemetry_rule was not found. Create it in IoT Core > Message routing > Rules (Lab 02 Task 5)." }
        $rule = $r.Rule
        $out = @()
        if ($rule.RuleDisabled) { $out += "IoT rule psb_telemetry_rule is disabled. Open the rule and choose Activate." }
        if ($rule.Sql -notmatch "FROM\s+'psb/lab/\+/telemetry'") { $out += "IoT rule psb_telemetry_rule SQL must read FROM 'psb/lab/+/telemetry'. Edit the SQL statement to match the lab guide." }
        $acts = @($rule.Actions)
        $lam = $acts | Where-Object { $_.Lambda -and $_.Lambda.FunctionArn -like "*:function:$fn*" }
        if (-not $lam) { $out += "IoT rule psb_telemetry_rule has no Lambda action for $fn. Edit the rule and add action Lambda > $fn." }
        $s3 = $acts | Where-Object { $_.S3 } | Select-Object -First 1
        if (-not $s3) { $out += "IoT rule psb_telemetry_rule has no S3 action. Add action S3 bucket $Bucket with key raw/`${parse_time(`"yyyy/MM/dd/HH`", timestamp())}/`${newuuid()}.json and role psb-lab-iot-rule-role." }
        else {
            if ($s3.S3.BucketName -ne $Bucket) { $out += "The S3 action of psb_telemetry_rule writes to bucket $($s3.S3.BucketName). Change it to $Bucket." }
            if ($s3.S3.Key -notlike "raw/*") { $out += "The S3 action key of psb_telemetry_rule is '$($s3.S3.Key)'. It must start with raw/ (see the key in the lab guide)." }
            if ($s3.S3.RoleArn -notlike "*:role/psb-lab-iot-rule-role") { $out += "The S3 action of psb_telemetry_rule must use IAM role psb-lab-iot-rule-role." }
        }
        if ($lam -and -not (Test-LambdaInvokePermission $fn "iot.amazonaws.com")) { $out += "Lambda $fn does not allow AWS IoT to invoke it. Re-save the Lambda action in the rule (the console adds the permission) or run aws lambda add-permission with principal iot.amazonaws.com." }
        return $out
    }

    Test-Step "Telemetry objects under raw/" {
        $keys = @(Get-S3Keys "raw/" 5 | Where-Object { $_.Key -ne "raw/" })
        if ($keys.Count -eq 0) { return "No telemetry files were found under s3://$Bucket/raw/. Keep the simulator running and check the S3 action and role psb-lab-iot-rule-role of psb_telemetry_rule." }
    }

    Test-Step "Ingest Lambda wrote points to InfluxDB" {
        $hit = Find-LogEvent "/aws/lambda/$fn" '"[ok] wrote"' 1440
        if (-not $hit) { return "No '[ok] wrote' line was found in /aws/lambda/$fn in the last 24 hours. Run the sample-reading test event and check the troubleshooting table (403 = wrong token, timeout = port 8086 / public access, 404 = org or bucket)." }
    }

    $script:SuccessText = "Lab 02 complete: InfluxDB psb-lab-influx is available, the bucket folders, IoT rule role, secret and ingest Lambda are configured with least privilege, and psb_telemetry_rule is writing telemetry to InfluxDB and s3://$Bucket/raw/."
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
