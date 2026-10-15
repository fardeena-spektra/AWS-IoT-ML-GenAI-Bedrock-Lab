<#
 CloudLabs validation | LAB08
 Lab 08: Bedrock assistant (Tasks 1-3)
 Lab: AWS Demo || Bedrock with Claude

 Script Type : PowerShellV2      Run As : System
 Parameters  : DeploymentId = GET-DEPLOYMENT-ID, Region = ap-southeast-1 (AccessKey / SecretKey optional; blank = Function App lab credentials)

 Passes when:
   - Lambda psb-assistant is configured (py3.13, 512 MB, 90 s, MODEL_ID, QUERY_FUNCTION_NAME, MAX_TOOL_TURNS)
   - inline psb-lab-assistant-policy grants bedrock:InvokeModel on the model and lambda:InvokeFunction on psb-query-telemetry
   - route POST /assistant on psb-lab-api uses psb-lab-cognito-authorizer and integrates psb-assistant (payload 2.0)
   - psb-assistant was invoked in the last 24 hours
   - Amplify branch main has at least 2 successful deployments (redeployed with assistantEnabled true)
#>
# CloudLabs injects the step parameters as variables before this script runs,
# so there is no param() block here (it would fail with "The term 'param' is not recognized").
$DeploymentId = "$(Get-Variable -Name DeploymentId -ValueOnly -ErrorAction SilentlyContinue)".Trim()
$AccessKey    = "$(Get-Variable -Name AccessKey    -ValueOnly -ErrorAction SilentlyContinue)".Trim()
$SecretKey    = "$(Get-Variable -Name SecretKey    -ValueOnly -ErrorAction SilentlyContinue)".Trim()
$Region       = "$(Get-Variable -Name Region       -ValueOnly -ErrorAction SilentlyContinue)".Trim()
if (-not $Region) { $Region = "$env:AWS_REGION".Trim() }
if (-not $Region) { $Region = "ap-southeast-1" }
Write-Host "DeploymentId: $DeploymentId | Region: $Region"

$LabTitle        = "Lab 08"
$RequiredModules = @("AWS.Tools.Lambda", "AWS.Tools.IdentityManagement", "AWS.Tools.ApiGatewayV2", "AWS.Tools.CloudWatchLogs", "AWS.Tools.Amplify")
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
    $script:TotalChecks = 5
    $fn = "psb-assistant"

    Test-Step "Lambda $fn configuration" {
        Test-LambdaBasics $fn 512 90 @("MODEL_ID", "QUERY_FUNCTION_NAME", "MAX_TOOL_TURNS")
        $v = $ctx["env:$fn"]
        if ($v) {
            if ($v["QUERY_FUNCTION_NAME"] -and $v["QUERY_FUNCTION_NAME"] -ne "psb-query-telemetry") { "Lambda $fn has QUERY_FUNCTION_NAME='$($v["QUERY_FUNCTION_NAME"])'. Set it to psb-query-telemetry." }
            $t = 0
            if ($v["MAX_TOOL_TURNS"] -and (-not [int]::TryParse($v["MAX_TOOL_TURNS"], [ref]$t) -or $t -le 0)) { "Lambda $fn has MAX_TOOL_TURNS='$($v["MAX_TOOL_TURNS"])'. Set it to 4." }
        }
    }

    Test-Step "Inline policy psb-lab-assistant-policy" {
        $cfg = $ctx["lambda:$fn"]
        if (-not $cfg) { return "Cannot check the role of $fn because the function was not found." }
        $roleName = Get-RoleNameFromArn $cfg.Role
        $msg = Test-RoleInlinePolicy $roleName "psb-lab-assistant-policy" $fn
        if ($msg) { return $msg }
        $pol = $ctx["policy:psb-lab-assistant-policy"]
        $model = "$($ctx["env:$fn"]["MODEL_ID"])"
        if (-not $model) { $model = "apac.amazon.nova-lite-v1:0" }
        $base = $model -replace '^(us|eu|apac|global)\.', ''
        $out = @()
        if (-not (Test-PolicyAllows $pol "bedrock:InvokeModel" "arn:aws:bedrock:*:*foundation-model/$base")) { $out += "psb-lab-assistant-policy must allow bedrock:InvokeModel on arn:aws:bedrock:*::foundation-model/$base." }
        if ($model -ne $base -and -not (Test-PolicyAllows $pol "bedrock:InvokeModel" "arn:aws:bedrock:*:*inference-profile/$model")) { $out += "psb-lab-assistant-policy must allow bedrock:InvokeModel on arn:aws:bedrock:${Region}:<account>:inference-profile/$model (the profile in MODEL_ID)." }
        if (-not (Test-PolicyAllows $pol "lambda:InvokeFunction" "arn:aws:lambda:${Region}:*:function:psb-query-telemetry*")) { $out += "psb-lab-assistant-policy must allow lambda:InvokeFunction on arn:aws:lambda:${Region}:<account>:function:psb-query-telemetry." }
        return $out
    }

    Test-Step "Route POST /assistant with authorizer" {
        $api = Get-LabApi
        if (-not $api) { return "HTTP API psb-lab-api was not found. Complete Lab 03 first." }
        $out = @()
        $r = @(Get-AG2RouteList -ApiId $api.ApiId) | Where-Object { $_.RouteKey -eq "POST /assistant" } | Select-Object -First 1
        if (-not $r) { return "Route POST /assistant is missing on psb-lab-api. Create it under Routes > Create." }
        $auth = @(Get-AG2AuthorizerList -ApiId $api.ApiId) | Where-Object { $_.Name -eq "psb-lab-cognito-authorizer" } | Select-Object -First 1
        if (-not $auth -or "$($r.AuthorizationType)" -ne "JWT" -or $r.AuthorizerId -ne $auth.AuthorizerId) { $out += "Route POST /assistant is not protected by psb-lab-cognito-authorizer. Open Authorization, select POST /assistant and attach the authorizer." }
        $intId = ("$($r.Target)" -replace '^integrations/', '')
        $int = @(Get-AG2IntegrationList -ApiId $api.ApiId) | Where-Object { $_.IntegrationId -eq $intId } | Select-Object -First 1
        if (-not $int -or "$($int.IntegrationUri)" -notlike "*function:$fn*") { $out += "Route POST /assistant is not integrated with Lambda $fn. Create a Lambda integration for $fn (payload 2.0) and attach it to the route." }
        elseif ("$($int.PayloadFormatVersion)" -ne "2.0") { $out += "The POST /assistant integration uses payload format $($int.PayloadFormatVersion). Set it to 2.0." }
        if (-not (Test-LambdaInvokePermission $fn "apigateway.amazonaws.com")) { $out += "Lambda $fn does not allow API Gateway to invoke it. Re-attach the integration in the console or run aws lambda add-permission with principal apigateway.amazonaws.com." }
        return $out
    }

    Test-Step "$fn was invoked in the last 24 hours" {
        $hit = Find-LogEvent "/aws/lambda/$fn" '"START RequestId"' 1440
        if (-not $hit) { return "No invocations of $fn were found in the last 24 hours. Run the ask-question test event or ask a question from the dashboard chat panel." }
    }

    Test-Step "Dashboard redeployed on Amplify" {
        $app = @(Get-AMPAppList) | Where-Object { $_.Name -eq "psb-lab-dashboard" } | Select-Object -First 1
        if (-not $app) { return "Amplify app psb-lab-dashboard was not found. Complete Lab 05 first." }
        $ok = @(@(Get-OrNull { Get-AMPJobList -AppId $app.AppId -BranchName "main" }) | Where-Object { $_ -and "$($_.Status)" -eq "SUCCEED" })
        if ($ok.Count -lt 2) { return "Branch main of psb-lab-dashboard has $($ok.Count) successful deployment(s). Set assistantEnabled: true in config.js, rebuild, zip and deploy the new zip to main." }
    }

    $script:SuccessText = "Lab 08 complete: psb-assistant is configured with least-privilege Bedrock and Lambda access, POST /assistant is protected by the Cognito authorizer, the assistant has been invoked and the dashboard was redeployed with the chat panel."
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
