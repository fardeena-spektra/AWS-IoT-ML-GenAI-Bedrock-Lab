<h1 align="center">🛠️ Solution Guide: AWS Demo || Bedrock with Claude</h1>
<p align="center"><b>Fastest path through Labs 01-09 with AWS CLI v2 in PowerShell</b> | 🌏 <b>Region: ap-southeast-1</b></p>

---

## 🎯 How to use this guide

| Item | Detail |
|---|---|
| Where to run | Lab VM, **Windows PowerShell** (works in PowerShell 5.1 and 7) |
| Credentials | Run `aws configure` once with the lab AWS access keys (the AccessKey / SecretKey pair the validators use; the desktop file **aws credentials.txt** only has the console sign-in), region `ap-southeast-1`, output `json` |
| JSON input | Every JSON argument is written to a file with `Set-Content` and passed as `file://...` (no quote escaping problems) |
| Order | Run **Session setup** first in every new PowerShell window, then the lab blocks in order |
| Console fallbacks | Used where the CLI is awkward: Cognito Hosted UI sign-in, Amplify drag and drop (CLI upload also shown), SageMaker Studio notebook |

> ⚠️ **Note:** Replace `<DEPLOYMENT-ID>` below with your Deployment ID (it is the suffix of the bucket `psb-lab-<id>`).

---

## 🔁 Session setup (run first in every new window)

```powershell
# ---- fixed values ----
$Region       = "ap-southeast-1"
$DeploymentId = "<DEPLOYMENT-ID>"
$env:AWS_DEFAULT_REGION = $Region
$AccountId    = aws sts get-caller-identity --query Account --output text
$Bucket       = "psb-lab-$DeploymentId"
$Assets       = "C:\psb-lab-assets"
$Work         = "C:\psb-lab-work"
New-Item -ItemType Directory -Force -Path $Work | Out-Null
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ---- helpers ----
# Run aws and parse JSON output (works in PowerShell 5.1 and 7)
function AwsJson { $out = & aws @args --output json | Out-String; if ($out.Trim()) { $out | ConvertFrom-Json } }
# Write an object as JSON (ASCII, no BOM) and return the file:// path for the CLI
function JsonFile([string]$Name, $Object) {
    $path = "$Work\$Name"
    ConvertTo-Json -InputObject $Object -Depth 20 | Set-Content -Path $path -Encoding ascii
    return "file://" + ($path -replace '\\', '/')
}
# Copy a policy file from assets\policies with the placeholders filled in
# (iot-device-policy, iot-rule-role-policy, lambda-execution-policy)
function PolicyFile([string]$Name) {
    $text = Get-Content "$Assets\policies\$Name.json" -Raw
    $text = $text.Replace("<AWS-REGION>", $Region).Replace("<AWS-ACCOUNT-ID>", $AccountId).Replace("<S3-BUCKET>", $Bucket)
    if ($SecretArn) { $text = $text.Replace("<SECRET-ARN>", $SecretArn) }
    $path = "$Work\$Name.json"
    Set-Content -Path $path -Value $text -Encoding ascii
    return "file://" + ($path -replace '\\', '/')
}
# Zip assets\lambda\<name>.py as lambda_function.py (same as pasting it into the console editor)
function LambdaZip([string]$Name) {
    $dir = "$Work\pkg-$Name"
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    Copy-Item "$Assets\lambda\$Name.py" "$dir\lambda_function.py" -Force
    $zip = "$Work\$Name.zip"
    Compress-Archive -Path "$dir\lambda_function.py" -DestinationPath $zip -Force
    return "fileb://" + ($zip -replace '\\', '/')
}
# Create a Lambda execution role with basic logging permissions (returns the role ARN)
function LambdaRole([string]$RoleName) {
    $trust = JsonFile "$RoleName-trust.json" @{ Version = "2012-10-17"; Statement = @(@{ Effect = "Allow"; Principal = @{ Service = "lambda.amazonaws.com" }; Action = "sts:AssumeRole" }) }
    $arn = aws iam create-role --role-name $RoleName --assume-role-policy-document $trust --query Role.Arn --output text
    aws iam attach-role-policy --role-name $RoleName --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
    return $arn
}

# ---- look up anything already created (safe to re-run; empty until the lab creates it) ----
$Influx      = (AwsJson timestream-influxdb list-db-instances).items | Where-Object { $_.name -eq "psb-lab-influx" } | Select-Object -First 1
if ($Influx) { $InfluxEndpoint = (AwsJson timestream-influxdb get-db-instance --identifier $Influx.id).endpoint; $InfluxUrl = "https://${InfluxEndpoint}:8086" }
$SecretArn   = aws secretsmanager describe-secret --secret-id psb/influxdb/admin-token --query ARN --output text 2>$null
$IotEndpoint = aws iot describe-endpoint --endpoint-type iot:Data-ATS --query endpointAddress --output text
$Api         = (AwsJson apigatewayv2 get-apis).Items | Where-Object { $_.Name -eq "psb-lab-api" } | Select-Object -First 1
if ($Api) { $ApiId = $Api.ApiId; $ApiUrl = $Api.ApiEndpoint }
$Pool        = (AwsJson cognito-idp list-user-pools --max-results 60).UserPools | Where-Object { $_.Name -eq "psb-lab-users" } | Select-Object -First 1
if ($Pool) { $PoolId = $Pool.Id; $ClientId = ((AwsJson cognito-idp list-user-pool-clients --user-pool-id $PoolId).UserPoolClients | Where-Object { $_.ClientName -eq "psb-lab-dashboard" }).ClientId }
$App         = (AwsJson amplify list-apps).apps | Where-Object { $_.name -eq "psb-lab-dashboard" } | Select-Object -First 1
if ($App) { $AppId = $App.appId; $AmplifyUrl = "https://main.$($App.defaultDomain)/" }
$DomainId    = ((AwsJson sagemaker list-domains).Domains | Where-Object { $_.DomainName -eq "psb-lab-domain" }).DomainId
"Account $AccountId | Bucket $Bucket | IoT $IotEndpoint | Influx $InfluxUrl | API $ApiUrl | Pool $PoolId | Client $ClientId | App $AmplifyUrl | Domain $DomainId"
```

---

## 🛰️ Lab 01: IoT identity and simulator

### Task 1 + 2: Thing, certificate and least-privilege policy

```powershell
$Certs = "$Assets\simulator\certs"
aws iot create-thing --thing-name psb-lab-sensor-01

# Certificate + keys written straight into the certs folder, set ACTIVE
$Cert = AwsJson iot create-keys-and-certificate --set-as-active `
    --certificate-pem-outfile "$Certs\psb-lab-sensor-01.cert.pem" `
    --public-key-outfile     "$Certs\psb-lab-sensor-01.public.key" `
    --private-key-outfile    "$Certs\psb-lab-sensor-01.private.key"
Invoke-WebRequest -UseBasicParsing -Uri "https://www.amazontrust.com/repository/AmazonRootCA1.pem" -OutFile "$Certs\root-CA.crt"

# Least-privilege policy (only policy on the certificate)
aws iot create-policy --policy-name psb-lab-device-policy --policy-document (PolicyFile "iot-device-policy")
aws iot attach-policy --policy-name psb-lab-device-policy --target $Cert.certificateArn
aws iot attach-thing-principal --thing-name psb-lab-sensor-01 --principal $Cert.certificateArn

$IotEndpoint = aws iot describe-endpoint --endpoint-type iot:Data-ATS --query endpointAddress --output text
$IotEndpoint   # ends with -ats.iot.ap-southeast-1.amazonaws.com
```

> 💡 **Tip:** If you used the console wizard (**Connect one device**) instead, remove the wizard policy so `psb-lab-device-policy` is the only one:

```powershell
$CertArn = aws iot list-thing-principals --thing-name psb-lab-sensor-01 --query "principals[0]" --output text
aws iot attach-policy --policy-name psb-lab-device-policy --target $CertArn
(AwsJson iot list-attached-policies --target $CertArn).policies | Where-Object { $_.policyName -ne "psb-lab-device-policy" } |
    ForEach-Object { aws iot detach-policy --policy-name $_.policyName --target $CertArn; "detached $($_.policyName)" }
```

### Task 3: Run the simulator (background, logs to file)

```powershell
Set-Location "$Assets\simulator"
python -m pip install -r requirements.txt
$Sim = Start-Process python -ArgumentList "simulate_pi.py --endpoint $IotEndpoint --certs-dir certs --interval 10" `
       -WorkingDirectory "$Assets\simulator" -RedirectStandardOutput "$Work\sim.log" -RedirectStandardError "$Work\sim.err" -PassThru -WindowStyle Hidden
Start-Sleep 30; Get-Content "$Work\sim.log" -Tail 5    # expect rc=0 (Connection Accepted.)
$Sim.Id | Set-Content "$Work\sim.pid"
```

| Result | Meaning |
|---|---|
| `rc=0 (Connection Accepted.)` | Connected |
| `rc=5` | Certificate inactive or policy missing / wrong account in the policy ARNs |

Console check: **IoT Core > MQTT test client**, subscribe to `psb/lab/+/telemetry`. Keep the simulator running 2+ minutes.

### ✅ Expected validator result

| Check | Result |
|---|---|
| Thing psb-lab-sensor-01 exists | PASS |
| Exactly one ACTIVE certificate | PASS |
| psb-lab-device-policy is the only policy on the certificate | PASS |
| psb-lab-device-policy is least privilege | PASS |
| Simulator published telemetry (PublishIn.Success) | PASS (metric can lag up to 5 minutes) |

---

## 🗄️ Lab 02: Rules Engine to InfluxDB + S3

### Task 1: InfluxDB instance (15-20 minutes, continue with Task 2 meanwhile)

```powershell
$Vpc     = aws ec2 describe-vpcs --filters Name=isDefault,Values=true --query "Vpcs[0].VpcId" --output text
$Subnets = (aws ec2 describe-subnets --filters Name=vpc-id,Values=$Vpc --query "Subnets[*].SubnetId" --output text) -split '\s+' | Where-Object { $_ }
$Sg      = aws ec2 create-security-group --group-name psb-lab-influx-sg --description "psb lab InfluxDB 8086" --vpc-id $Vpc --query GroupId --output text
aws ec2 authorize-security-group-ingress --group-id $Sg --protocol tcp --port 8086 --cidr 0.0.0.0/0

$Influx = AwsJson timestream-influxdb create-db-instance --name psb-lab-influx `
    --username psbadmin --password "PsbLab#2026!Influx" --organization psb --bucket telemetry `
    --db-instance-type db.influx.medium --db-storage-type InfluxIOIncludedT1 --allocated-storage 20 `
    --deployment-type SINGLE_AZ --vpc-subnet-ids $Subnets[0] $Subnets[1] --vpc-security-group-ids $Sg `
    --publicly-accessible --port 8086
$Influx.id
```

Wait for **AVAILABLE** (run when you come back from Task 2):

```powershell
do { $st = AwsJson timestream-influxdb get-db-instance --identifier $Influx.id; Write-Host "$(Get-Date -f T) $($st.status)"; if ($st.status -ne "AVAILABLE") { Start-Sleep 60 } } while ($st.status -ne "AVAILABLE")
$InfluxEndpoint = $st.endpoint
$InfluxUrl = "https://${InfluxEndpoint}:8086"
$InfluxUrl
```

Create an API token (CLI path through the InfluxDB API, read/write on the org buckets):

```powershell
$basic = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("psbadmin:PsbLab#2026!Influx"))
Invoke-WebRequest -UseBasicParsing -Method Post -Uri "$InfluxUrl/api/v2/signin" -Headers @{ Authorization = "Basic $basic" } -SessionVariable influx | Out-Null
$OrgId = (Invoke-RestMethod -Uri "$InfluxUrl/api/v2/orgs?org=psb" -WebSession $influx).orgs[0].id
$body = @{ orgID = $OrgId; description = "psb-lab-lambdas"; permissions = @(
    @{ action = "read";  resource = @{ type = "buckets"; orgID = $OrgId } },
    @{ action = "write"; resource = @{ type = "buckets"; orgID = $OrgId } }) } | ConvertTo-Json -Depth 5
$InfluxToken = (Invoke-RestMethod -Method Post -Uri "$InfluxUrl/api/v2/authorizations" -WebSession $influx -ContentType "application/json" -Body $body).token
$InfluxToken.Substring(0, 8) + "..."
```

> ℹ️ **Info:** Console fallback: open `$InfluxUrl` in Chrome, sign in as **psbadmin** / **PsbLab#2026!Influx**, **Load Data > API Tokens > Generate API Token > All Access API Token**, copy it into `$InfluxToken`.

### Task 2: Bucket folders + IoT rule role

```powershell
foreach ($f in "raw/", "curated/", "model/") { aws s3api put-object --bucket $Bucket --key $f | Out-Null }
aws s3 ls "s3://$Bucket/"

# Trust = AWS service IoT (what the console creates); no managed policies, one inline policy
$IotTrust = JsonFile "iot-rule-trust.json" @{ Version = "2012-10-17"; Statement = @(@{ Effect = "Allow"; Principal = @{ Service = "iot.amazonaws.com" }; Action = "sts:AssumeRole" }) }
aws iam create-role --role-name psb-lab-iot-rule-role --assume-role-policy-document $IotTrust | Out-Null
aws iam put-role-policy --role-name psb-lab-iot-rule-role --policy-name psb-lab-iot-rule-s3-write --policy-document (PolicyFile "iot-rule-role-policy")
$IotRuleRoleArn = aws iam get-role --role-name psb-lab-iot-rule-role --query Role.Arn --output text
```

### Task 3 + 4: Secret, ingest Lambda, inline policy, test

```powershell
$SecretArn = aws secretsmanager create-secret --name psb/influxdb/admin-token `
    --secret-string (JsonFile "influx-secret.json" @{ token = $InfluxToken }) --query ARN --output text

$InfluxEnv = @{ INFLUX_URL = $InfluxUrl; INFLUX_ORG = "psb"; INFLUX_BUCKET = "telemetry"; INFLUX_SECRET_ID = "psb/influxdb/admin-token" }
$IngestRole = LambdaRole "psb-ingest-telemetry-role"
aws iam put-role-policy --role-name psb-ingest-telemetry-role --policy-name psb-lab-read-influx-token --policy-document (PolicyFile "lambda-execution-policy")
Start-Sleep 10   # IAM propagation

aws lambda create-function --function-name psb-ingest-telemetry --runtime python3.13 --architectures x86_64 `
    --handler lambda_function.lambda_handler --role $IngestRole --zip-file (LambdaZip "psb-ingest-telemetry") `
    --memory-size 256 --timeout 15 --environment (JsonFile "ingest-env.json" @{ Variables = $InfluxEnv }) | Out-Null
aws lambda wait function-active-v2 --function-name psb-ingest-telemetry

# Test event sample-reading (from the lab guide)
$sample = JsonFile "sample-reading.json" @{ device_id = "psb-lab-sensor-01"; location = "north-lab"; ts = 1789012345
    temperature_c = 22.84; humidity_pct = 53.11; co2_ppm = 531.2; vibration_g = 0.0213 }
aws lambda invoke --function-name psb-ingest-telemetry --cli-binary-format raw-in-base64-out `
    --payload $sample "$Work\ingest-out.json" | Out-Null
Get-Content "$Work\ingest-out.json"    # {"written": 1, "status": 204}
```

| Error | Fix |
|---|---|
| 403 | Wrong token or secret value (`{"token":"..."}`) |
| Timeout | Port 8086 not open in `psb-lab-influx-sg` or instance not public |
| 404 | Org `psb` or bucket `telemetry` wrong |

### Task 5: IoT rule with Lambda + S3 actions

```powershell
$IngestArn = aws lambda get-function --function-name psb-ingest-telemetry --query Configuration.FunctionArn --output text
$rule = @{
    # Original SQL: injected_anomaly is deliberately NOT selected
    sql = "SELECT device_id, location, ts, temperature_c, humidity_pct, co2_ppm, vibration_g, timestamp() AS ingested_at FROM 'psb/lab/+/telemetry'"
    awsIotSqlVersion = "2016-03-23"
    ruleDisabled = $false
    actions = @(
        @{ lambda = @{ functionArn = $IngestArn } },
        @{ s3 = @{ bucketName = $Bucket; key = 'raw/${parse_time("yyyy/MM/dd/HH", timestamp())}/${newuuid()}.json'; roleArn = $IotRuleRoleArn } }
    )
}
aws iot create-topic-rule --rule-name psb_telemetry_rule --topic-rule-payload (JsonFile "topic-rule.json" $rule)
aws lambda add-permission --function-name psb-ingest-telemetry --statement-id iot-psb-telemetry-rule `
    --action lambda:InvokeFunction --principal iot.amazonaws.com `
    --source-arn "arn:aws:iot:${Region}:${AccountId}:rule/psb_telemetry_rule" --source-account $AccountId | Out-Null

Start-Sleep 60
aws logs tail /aws/lambda/psb-ingest-telemetry --since 5m | Select-String "\[ok\] wrote 1 point \(204\)" | Select-Object -Last 3
aws s3 ls "s3://$Bucket/raw/" --recursive | Select-Object -Last 3
```

### ✅ Expected validator result

| Check | Result |
|---|---|
| InfluxDB psb-lab-influx is available | PASS |
| Bucket has raw/, curated/, model/ | PASS |
| IAM role psb-lab-iot-rule-role | PASS |
| Secret psb/influxdb/admin-token exists | PASS |
| Lambda psb-ingest-telemetry configuration | PASS |
| Lambda role has psb-lab-read-influx-token | PASS |
| IoT rule psb_telemetry_rule | PASS |
| Telemetry objects under raw/ | PASS |
| Ingest Lambda wrote points to InfluxDB | PASS |

---

## 🔎 Lab 03: Query Lambda + HTTP API

### Task 1: Query Lambda

```powershell
$QueryRole = LambdaRole "psb-query-telemetry-role"
aws iam put-role-policy --role-name psb-query-telemetry-role --policy-name psb-lab-read-influx-token --policy-document (PolicyFile "lambda-execution-policy")
Start-Sleep 10
aws lambda create-function --function-name psb-query-telemetry --runtime python3.13 --architectures x86_64 `
    --handler lambda_function.lambda_handler --role $QueryRole --zip-file (LambdaZip "psb-query-telemetry") `
    --memory-size 256 --timeout 30 --environment (JsonFile "query-env.json" @{ Variables = $InfluxEnv }) | Out-Null
aws lambda wait function-active-v2 --function-name psb-query-telemetry

# Test event direct-query (from the lab guide)
$dq = JsonFile "direct-query.json" @{ metric = "temperature_c"; window_minutes = 30; bucket_seconds = 60 }
aws lambda invoke --function-name psb-query-telemetry --cli-binary-format raw-in-base64-out `
    --payload $dq "$Work\query-out.json" | Out-Null
(Get-Content "$Work\query-out.json" -Raw | ConvertFrom-Json).summary    # point_count > 0 (0 = no data, try window_minutes 240)
```

> ⚠️ **Note:** In a new window, set `$InfluxEnv` again: `$InfluxEnv = @{ INFLUX_URL = $InfluxUrl; INFLUX_ORG = "psb"; INFLUX_BUCKET = "telemetry"; INFLUX_SECRET_ID = "psb/influxdb/admin-token" }`.

### Task 2: HTTP API, integration, routes, stage, CORS

```powershell
$cors  = JsonFile "cors.json" @{ AllowOrigins = @("*"); AllowHeaders = @("authorization", "content-type"); AllowMethods = @("GET", "POST", "OPTIONS"); MaxAge = 300 }
$ApiId = aws apigatewayv2 create-api --name psb-lab-api --protocol-type HTTP --cors-configuration $cors --query ApiId --output text
$QueryArn = aws lambda get-function --function-name psb-query-telemetry --query Configuration.FunctionArn --output text
$QueryIntId = aws apigatewayv2 create-integration --api-id $ApiId --integration-type AWS_PROXY `
    --integration-uri $QueryArn --payload-format-version 2.0 --query IntegrationId --output text
foreach ($rk in "GET /telemetry", "GET /anomalies") {
    aws apigatewayv2 create-route --api-id $ApiId --route-key $rk --target "integrations/$QueryIntId" | Out-Null
}
aws apigatewayv2 create-stage --api-id $ApiId --stage-name '$default' --auto-deploy | Out-Null
aws lambda add-permission --function-name psb-query-telemetry --statement-id apigw-psb-lab-api `
    --action lambda:InvokeFunction --principal apigateway.amazonaws.com `
    --source-arn "arn:aws:execute-api:${Region}:${AccountId}:${ApiId}/*/*" | Out-Null
$ApiUrl = aws apigatewayv2 get-api --api-id $ApiId --query ApiEndpoint --output text
$ApiUrl
```

### Task 3: Test

```powershell
curl.exe "$ApiUrl/telemetry?metric=temperature_c&window_minutes=30"
curl.exe "$ApiUrl/telemetry?metric=co2_ppm&window_minutes=60&location=north-lab"
curl.exe -i "$ApiUrl/telemetry?metric=DROP_TABLE"     # 400 {"error": "metric must be one of [...]"}
```

InfluxDB UI (**Data Explorer > Script Editor**):

```text
from(bucket: "telemetry")
  |> range(start: -1h)
  |> filter(fn: (r) => r["_measurement"] == "reading")
  |> filter(fn: (r) => r["_field"] == "temperature_c")
  |> aggregateWindow(every: 1m, fn: mean, createEmpty: false)
```

### ✅ Expected validator result

| Check | Result |
|---|---|
| Lambda psb-query-telemetry configuration | PASS |
| Lambda role has psb-lab-read-influx-token | PASS |
| HTTP API psb-lab-api with CORS | PASS |
| Routes, integration and $default stage | PASS |
| Direct invoke returns points | PASS (simulator must be running) |

---

## 🔐 Lab 04: Cognito authentication

### Task 1: User pool, app client, domain, user

```powershell
$PoolId = aws cognito-idp create-user-pool --pool-name psb-lab-users --username-attributes email `
    --auto-verified-attributes email --query UserPool.Id --output text

$ClientId = aws cognito-idp create-user-pool-client --user-pool-id $PoolId --client-name psb-lab-dashboard --no-generate-secret `
    --allowed-o-auth-flows-user-pool-client --allowed-o-auth-flows implicit code --allowed-o-auth-scopes email openid profile `
    --callback-urls "http://localhost:5173/" --logout-urls "http://localhost:5173/" --supported-identity-providers COGNITO `
    --explicit-auth-flows ALLOW_USER_SRP_AUTH ALLOW_USER_PASSWORD_AUTH ALLOW_REFRESH_TOKEN_AUTH `
    --query UserPoolClient.ClientId --output text

aws cognito-idp create-user-pool-domain --domain "psb-lab-$DeploymentId" --user-pool-id $PoolId
$CognitoDomain = "psb-lab-$DeploymentId.auth.$Region.amazoncognito.com"

aws cognito-idp admin-create-user --user-pool-id $PoolId --username student@psb.lab `
    --temporary-password "PsbLab#2026!" --message-action SUPPRESS `
    --user-attributes Name=email,Value=student@psb.lab Name=email_verified,Value=true
"Pool $PoolId | Client $ClientId | Domain https://$CognitoDomain"
```

Set the new password and get an ID token. **Fastest (CLI):**

```powershell
aws cognito-idp admin-set-user-password --user-pool-id $PoolId --username student@psb.lab --password "PsbLab#2026!New" --permanent
$env:ID_TOKEN = aws cognito-idp initiate-auth --client-id $ClientId --auth-flow USER_PASSWORD_AUTH `
    --auth-parameters "USERNAME=student@psb.lab,PASSWORD=PsbLab#2026!New" --query AuthenticationResult.IdToken --output text
$env:ID_TOKEN.Substring(0, 20) + "..."
```

**Console way (as in the lab guide):** open the Hosted UI URL below in Chrome, sign in with `PsbLab#2026!`, set `PsbLab#2026!New`, then copy `id_token` from the address bar (the localhost page will not load, that is expected) into `$env:ID_TOKEN`.

```powershell
"https://$CognitoDomain/login?client_id=$ClientId&response_type=token&scope=email+openid&redirect_uri=http://localhost:5173/"
```

### Task 2: JWT authorizer on both routes

```powershell
$jwt = JsonFile "jwt.json" @{ Audience = @($ClientId); Issuer = "https://cognito-idp.$Region.amazonaws.com/$PoolId" }
$AuthId = aws apigatewayv2 create-authorizer --api-id $ApiId --name psb-lab-cognito-authorizer --authorizer-type JWT `
    --identity-source '$request.header.Authorization' --jwt-configuration $jwt --query AuthorizerId --output text
(AwsJson apigatewayv2 get-routes --api-id $ApiId).Items | Where-Object { $_.RouteKey -in @("GET /telemetry", "GET /anomalies") } | ForEach-Object {
    aws apigatewayv2 update-route --api-id $ApiId --route-id $_.RouteId --authorization-type JWT --authorizer-id $AuthId | Out-Null
    "secured $($_.RouteKey)"
}
Start-Sleep 5
curl.exe -s -o NUL -w "no token: %{http_code}`n" "$ApiUrl/telemetry?metric=temperature_c"
curl.exe -s -o NUL -w "with token: %{http_code}`n" -H "Authorization: Bearer $env:ID_TOKEN" "$ApiUrl/telemetry?metric=temperature_c"

# Decode the token claims (email, aud, iss, exp)
$p = $env:ID_TOKEN.Split('.')[1].Replace('-', '+').Replace('_', '/'); while ($p.Length % 4) { $p += '=' }
[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($p)) | ConvertFrom-Json | Select-Object email, aud, iss, exp
```

| Request | Expected |
|---|---|
| No token | 401 |
| `Authorization: Bearer <id_token>` | 200 |

### ✅ Expected validator result

| Check | Result |
|---|---|
| User pool psb-lab-users exists | PASS |
| App client psb-lab-dashboard OAuth settings | PASS |
| Cognito domain on psb-lab-users | PASS (any prefix) |
| User student@psb.lab is confirmed | PASS |
| JWT authorizer psb-lab-cognito-authorizer | PASS |
| Authorizer attached to both GET routes | PASS |

---

## 📊 Lab 05: Amplify dashboard

### Task 1: Configure and build

```powershell
$cfgPath = "$Assets\dashboard\src\config.js"
$cfg = Get-Content $cfgPath -Raw
# Cognito domain: https:// and no trailing slash. Invoke URL: no trailing slash.
$cfg = $cfg.Replace("<USER-POOL-ID>", $PoolId).Replace("<CLIENT-ID>", $ClientId)
$cfg = $cfg.Replace("<COGNITO-DOMAIN>", "https://psb-lab-$DeploymentId.auth.$Region.amazoncognito.com").Replace("<INVOKE-URL>", $ApiUrl.TrimEnd('/'))
Set-Content $cfgPath $cfg -Encoding ascii
Get-Content $cfgPath | Select-String "userPoolId|userPoolClientId|cognitoDomain|apiBaseUrl"

Set-Location "$Assets\dashboard"
npm install
npm run build
Compress-Archive -Path dist\* -DestinationPath dashboard-build.zip -Force
```

> 💡 **Tip:** Build fails? Use the pre-built `dashboard\dist.zip`: extract it, put the same four values in `config.json` at its root (it is merged over `src/config.js`), then zip the **contents** (index.html at the zip root) as `dashboard-build.zip`. For Lab 08 set `"assistantEnabled": true` in that `config.json`.

### Task 2: Amplify app, deploy, rewrite, Cognito URLs

```powershell
$rules = JsonFile "amplify-rules.json" @(@{ source = "/<*>"; target = "/index.html"; status = "404-200" })
$AppId = aws amplify create-app --name psb-lab-dashboard --custom-rules $rules --query app.appId --output text
aws amplify create-branch --app-id $AppId --branch-name main | Out-Null

function Deploy-Dashboard {
    $dep = AwsJson amplify create-deployment --app-id $AppId --branch-name main
    Invoke-WebRequest -UseBasicParsing -Method Put -Uri $dep.zipUploadUrl -InFile "$Assets\dashboard\dashboard-build.zip" -ContentType "application/zip" | Out-Null
    aws amplify start-deployment --app-id $AppId --branch-name main --job-id $dep.jobId | Out-Null
    do { Start-Sleep 10; $s = aws amplify get-job --app-id $AppId --branch-name main --job-id $dep.jobId --query job.summary.status --output text; Write-Host "deploy: $s" } while ($s -in @("PENDING", "PROVISIONING", "RUNNING"))
}
Deploy-Dashboard
$AmplifyUrl = "https://main." + (aws amplify get-app --app-id $AppId --query app.defaultDomain --output text) + "/"
$AmplifyUrl
```

Add the Amplify URL to the app client (update-user-pool-client replaces all settings, so every value is passed again):

```powershell
aws cognito-idp update-user-pool-client --user-pool-id $PoolId --client-id $ClientId --client-name psb-lab-dashboard `
    --allowed-o-auth-flows-user-pool-client --allowed-o-auth-flows implicit code --allowed-o-auth-scopes email openid profile `
    --callback-urls "http://localhost:5173/" $AmplifyUrl --logout-urls "http://localhost:5173/" $AmplifyUrl `
    --supported-identity-providers COGNITO --explicit-auth-flows ALLOW_USER_SRP_AUTH ALLOW_USER_PASSWORD_AUTH ALLOW_REFRESH_TOKEN_AUTH | Out-Null
Start-Process chrome $AmplifyUrl
```

Console fallback: **Amplify > Create new app > Deploy without Git**, app name `psb-lab-dashboard`, branch `main`, drag and drop `dashboard-build.zip`, **Save and deploy**; **Hosting > Rewrites and redirects**: `/<*>` to `/index.html`, type **404 (Rewrite)**.

Click **Sign in** and sign in as `student@psb.lab`: summary strip (latest/min/max/mean), line chart (one line per location), metric selector (temperature_c, humidity_pct, co2_ppm, vibration_g, anomaly_score) and window selector (15 minutes, 1 hour, 6 hours, 24 hours).

### ✅ Expected validator result

| Check | Result |
|---|---|
| Amplify app psb-lab-dashboard exists | PASS |
| Branch main exists | PASS |
| Latest deployment on main succeeded | PASS |
| Rewrite /&lt;*&gt; to /index.html (404-200) | PASS |
| Amplify URL in Cognito callback and sign-out URLs | PASS |

---

## 🤖 Lab 06: SageMaker anomaly model

### Task 1: Backfill, then the JupyterLab space

```powershell
# Stop live mode, run 24 h backfill (about 8,640 readings), restart live mode
Get-Content "$Work\sim.pid" -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_ -ErrorAction SilentlyContinue }
Set-Location "$Assets\simulator"
python simulate_pi.py --endpoint $IotEndpoint --certs-dir certs --interval 10 --backfill-hours 24
$Sim = Start-Process python -ArgumentList "simulate_pi.py --endpoint $IotEndpoint --certs-dir certs --interval 10" `
       -WorkingDirectory "$Assets\simulator" -RedirectStandardOutput "$Work\sim.log" -RedirectStandardError "$Work\sim.err" -PassThru -WindowStyle Hidden
$Sim.Id | Set-Content "$Work\sim.pid"
Start-Sleep 60
(aws s3 ls "s3://$Bucket/raw/" --recursive | Measure-Object).Count    # 1000 or more

# Space psb-lab-space (Private, ml.t3.medium, 20 GB)
$space = JsonFile "space.json" @{ AppType = "JupyterLab"
    JupyterLabAppSettings = @{ DefaultResourceSpec = @{ InstanceType = "ml.t3.medium" } }
    SpaceStorageSettings  = @{ EbsStorageSettings = @{ EbsVolumeSizeInGb = 20 } } }
aws sagemaker create-space --domain-id $DomainId --space-name psb-lab-space --space-settings $space `
    --ownership-settings OwnerUserProfileName=psb-lab-user --space-sharing-settings SharingType=Private
```

Console: **SageMaker AI > Studio**, domain `psb-lab-domain`, user `psb-lab-user`, **Open Studio > JupyterLab**, select `psb-lab-space`, image **SageMaker Distribution 2.x**, **Run space > Open JupyterLab**. Upload `C:\psb-lab-assets\notebook\psb-anomaly-detection.ipynb`.

### Task 2 + 3: Run the notebook (console)

| Cells | What to do | Time |
|---|---|---|
| 1 | Set `BUCKET = "psb-lab-<id>"` | |
| 2-3 | Load raw/ JSON, 4 features; `injected_anomaly` is absent (the IoT rule dropped it), the code handles that | 1-2 min |
| 4 | Train RCF (ml.m5.large, 64 trees, 256 samples/tree, output `s3://<BUCKET>/model/`); then `print(rcf.model_data)` | about 5 min |
| 5 | Deploy serverless endpoint `psb-anomaly-endpoint` (2048 MB, concurrency 5) | about 4 min |
| 6-8 | Score in batches of 500, cutoff = 98th percentile, evaluation (Cell 7 prints the top 10 when there is no ground truth), plot | 2 min |
| 9 | Write `curated/scored/backfill-scored.csv` | |
| 10 | Prints `ANOMALY_CUTOFF for Lab 07 = <value>` | |

Copy the printed `ANOMALY_CUTOFF for Lab 07` value. Check from the VM:

```powershell
aws sagemaker describe-endpoint --endpoint-name psb-anomaly-endpoint --query EndpointStatus --output text   # InService
aws s3 ls "s3://$Bucket/curated/scored/backfill-scored.csv"
aws s3 ls "s3://$Bucket/model/" --recursive | Select-Object -Last 2
```

### ✅ Expected validator result

| Check | Result |
|---|---|
| Backfill data in raw/ (1000+ files) | PASS |
| Domain psb-lab-domain is InService | PASS |
| User profile psb-lab-user exists | PASS |
| JupyterLab space psb-lab-space exists | PASS |
| Completed RandomCutForest training job | PASS |
| Endpoint psb-anomaly-endpoint is InService | PASS |
| Scored backfill file | PASS |

---

## ⏱️ Lab 07: Scoring pipeline

### Task 1: Score Lambda

```powershell
$AnomalyCutoff = "<ANOMALY-CUTOFF>"    # value printed by the notebook, for example 2.1534
$ScoreEnv = $InfluxEnv.Clone()
$ScoreEnv.SAGEMAKER_ENDPOINT = "psb-anomaly-endpoint"
$ScoreEnv.S3_BUCKET = $Bucket
$ScoreEnv.ANOMALY_CUTOFF = $AnomalyCutoff
$ScoreEnv.WINDOW_MINUTES = "6"

$ScoreRole = LambdaRole "psb-score-telemetry-role"
# Inline policy from Lab 07 Task 1 (secret read, invoke one endpoint, write curated/)
$ScorePol = JsonFile "score-policy.json" @{ Version = "2012-10-17"; Statement = @(
    @{ Sid = "AllowReadInfluxToken"; Effect = "Allow"; Action = "secretsmanager:GetSecretValue"; Resource = $SecretArn },
    @{ Sid = "AllowInvokeAnomalyEndpoint"; Effect = "Allow"; Action = "sagemaker:InvokeEndpoint"; Resource = "arn:aws:sagemaker:${Region}:${AccountId}:endpoint/psb-anomaly-endpoint" },
    @{ Sid = "AllowWriteCuratedScores"; Effect = "Allow"; Action = "s3:PutObject"; Resource = "arn:aws:s3:::$Bucket/curated/*" }) }
aws iam put-role-policy --role-name psb-score-telemetry-role --policy-name psb-lab-score-telemetry-policy --policy-document $ScorePol
Start-Sleep 10
aws lambda create-function --function-name psb-score-telemetry --runtime python3.13 --architectures x86_64 `
    --handler lambda_function.lambda_handler --role $ScoreRole --zip-file (LambdaZip "psb-score-telemetry") `
    --memory-size 512 --timeout 60 --environment (JsonFile "score-env.json" @{ Variables = $ScoreEnv }) | Out-Null
aws lambda wait function-active-v2 --function-name psb-score-telemetry
# Test event manual-run = {}
Set-Content "$Work\manual-run.json" "{}" -Encoding ascii
aws lambda invoke --function-name psb-score-telemetry --cli-binary-format raw-in-base64-out `
    --payload "file://$($Work -replace '\\','/')/manual-run.json" "$Work\score-out.json" | Out-Null
Get-Content "$Work\score-out.json"    # {"scored": n, "flagged": m, "archive": "curated/scored/YYYY/MM/DD/HHMMSS.csv"}
```

### Task 2: Every 5 minutes with EventBridge

```powershell
$ScoreArn = aws lambda get-function --function-name psb-score-telemetry --query Configuration.FunctionArn --output text
$RuleArn  = aws events put-rule --name psb-lab-score-every-5-min --schedule-expression "rate(5 minutes)" --state ENABLED --query RuleArn --output text
aws lambda add-permission --function-name psb-score-telemetry --statement-id events-psb-score-every-5-min `
    --action lambda:InvokeFunction --principal events.amazonaws.com --source-arn $RuleArn | Out-Null
aws events put-targets --rule psb-lab-score-every-5-min --targets (JsonFile "score-targets.json" @(@{ Id = "psb-score-telemetry"; Arn = $ScoreArn }))
```

### Task 3: Verify (after 5-10 minutes)

```powershell
aws logs tail /aws/lambda/psb-score-telemetry --since 15m | Select-String "\[ok\] scored="
curl.exe -H "Authorization: Bearer $env:ID_TOKEN" "$ApiUrl/anomalies?window_minutes=60"
aws s3 ls "s3://$Bucket/curated/scored/" --recursive | Select-Object -Last 3
```

Dashboard: select **anomaly_score** in the metric selector and the 6 hours window.

### ✅ Expected validator result

| Check | Result |
|---|---|
| Lambda psb-score-telemetry configuration | PASS |
| Inline policy psb-lab-score-telemetry-policy | PASS |
| EventBridge rule psb-lab-score-every-5-min | PASS |
| Rule targets psb-score-telemetry | PASS |
| Scheduled scoring ran in the last 30 minutes | PASS |
| Scored CSV files under curated/scored/ | PASS |

---

## 💬 Lab 08: Bedrock assistant

### Task 1: Model access and a quick test

```powershell
$msg = JsonFile "converse-msg.json" @(@{ role = "user"; content = @(@{ text = "Reply with OK" }) })
aws bedrock-runtime converse --model-id amazon.nova-lite-v1:0 --messages $msg --query "output.message.content[0].text" --output text   # OK
```

> ℹ️ **Info:** If you get AccessDenied, open **Bedrock > Model access** and enable **Amazon Nova Lite** (if the page is not shown, models are enabled on first use).

### Task 2: Assistant Lambda

```powershell
$AsstRole = LambdaRole "psb-assistant-role"
# Inline policy from Lab 08 Task 2 (foundation-model ARN has an EMPTY account field)
$AsstPol = JsonFile "assistant-policy.json" @{ Version = "2012-10-17"; Statement = @(
    @{ Sid = "AllowInvokeNovaLite"; Effect = "Allow"; Action = @("bedrock:InvokeModel", "bedrock:Converse"); Resource = "arn:aws:bedrock:${Region}::foundation-model/amazon.nova-lite-v1:0" },
    @{ Sid = "AllowInvokeQueryFunction"; Effect = "Allow"; Action = "lambda:InvokeFunction"; Resource = "arn:aws:lambda:${Region}:${AccountId}:function:psb-query-telemetry" }) }
aws iam put-role-policy --role-name psb-assistant-role --policy-name psb-lab-assistant-policy --policy-document $AsstPol
Start-Sleep 10
$AsstEnv = @{ MODEL_ID = "amazon.nova-lite-v1:0"; QUERY_FUNCTION_NAME = "psb-query-telemetry"; MAX_TOOL_TURNS = "4" }
aws lambda create-function --function-name psb-assistant --runtime python3.13 --architectures x86_64 `
    --handler lambda_function.lambda_handler --role $AsstRole --zip-file (LambdaZip "psb-assistant") `
    --memory-size 512 --timeout 90 --environment (JsonFile "assistant-env.json" @{ Variables = $AsstEnv }) | Out-Null
aws lambda wait function-active-v2 --function-name psb-assistant

# Test event ask-question: the question is a JSON string inside "body" (same as API Gateway sends it)
$ask = JsonFile "ask-question.json" @{ body = (@{ question = "What is the average temperature in the north lab over the last hour, and was anything unusual?" } | ConvertTo-Json -Compress) }
aws lambda invoke --function-name psb-assistant --cli-binary-format raw-in-base64-out --payload $ask "$Work\asst-out.json" | Out-Null
(Get-Content "$Work\asst-out.json" -Raw | ConvertFrom-Json).body    # {"answer": ..., "trace": [...], "usage": {...}}
$q = JsonFile "ask-east-wing.json" @{ body = (@{ question = "What was the temperature in the east wing last March?" } | ConvertTo-Json -Compress) }
aws lambda invoke --function-name psb-assistant --cli-binary-format raw-in-base64-out --payload $q "$Work\asst-out2.json" | Out-Null
(Get-Content "$Work\asst-out2.json" -Raw | ConvertFrom-Json).body    # says east-wing is not an available location
```

### Task 3: POST /assistant route and redeploy the dashboard

```powershell
$AsstArn = aws lambda get-function --function-name psb-assistant --query Configuration.FunctionArn --output text
$AuthId  = ((AwsJson apigatewayv2 get-authorizers --api-id $ApiId).Items | Where-Object { $_.Name -eq "psb-lab-cognito-authorizer" }).AuthorizerId
$AsstIntId = aws apigatewayv2 create-integration --api-id $ApiId --integration-type AWS_PROXY `
    --integration-uri $AsstArn --payload-format-version 2.0 --query IntegrationId --output text
aws apigatewayv2 create-route --api-id $ApiId --route-key "POST /assistant" --target "integrations/$AsstIntId" `
    --authorization-type JWT --authorizer-id $AuthId | Out-Null
aws lambda add-permission --function-name psb-assistant --statement-id apigw-psb-lab-api `
    --action lambda:InvokeFunction --principal apigateway.amazonaws.com `
    --source-arn "arn:aws:execute-api:${Region}:${AccountId}:${ApiId}/*/*" | Out-Null

Invoke-RestMethod -Method Post -Uri "$ApiUrl/assistant" -Headers @{ Authorization = "Bearer $env:ID_TOKEN" } `
    -ContentType "application/json" -Body '{"question":"Which location has the highest CO2 right now?"}'

# Turn on the chat panel: add one line inside the config object (Deploy-Dashboard is defined in Lab 05; define it again in a new window)
$cfgPath = "$Assets\dashboard\src\config.js"
$cfg = Get-Content $cfgPath -Raw
if ($cfg -notmatch "assistantEnabled") { $cfg = $cfg.Replace("refreshSeconds:    30,", "refreshSeconds:    30,`n  assistantEnabled: true,") }
Set-Content $cfgPath $cfg -Encoding ascii
Set-Location "$Assets\dashboard"; npm run build
Compress-Archive -Path dist\* -DestinationPath dashboard-build.zip -Force
Deploy-Dashboard
```

Console fallback for the redeploy: **Amplify > psb-lab-dashboard > Deploy updates**, drag and drop the new zip. The chat panel appears beneath the chart; each answer shows the tool calls (trace) under it.

### ✅ Expected validator result

| Check | Result |
|---|---|
| Lambda psb-assistant configuration | PASS |
| Inline policy psb-lab-assistant-policy | PASS |
| Route POST /assistant with authorizer | PASS |
| psb-assistant was invoked in the last 24 hours | PASS |
| Dashboard redeployed on Amplify (2+ successful jobs) | PASS |

---

## 🧹 Lab 09: Observability and teardown

### Task 1: Retention, metric filter, alarm

```powershell
foreach ($n in "psb-ingest-telemetry", "psb-query-telemetry", "psb-score-telemetry", "psb-assistant") {
    aws logs put-retention-policy --log-group-name "/aws/lambda/$n" --retention-in-days 7
}
# Pattern contains double quotes, so the whole request goes in a JSON file
$mf = JsonFile "metric-filter.json" @{
    logGroupName = "/aws/lambda/psb-score-telemetry"; filterName = "psb-lab-anomaly-batches"; filterPattern = '"[ok] scored="'
    metricTransformations = @(@{ metricName = "AnomalyBatches"; metricNamespace = "PSBLab"; metricValue = "1"; defaultValue = 0; unit = "Count" }) }
aws logs put-metric-filter --cli-input-json $mf

aws cloudwatch put-metric-alarm --alarm-name psb-lab-scoring-pipeline-stalled --namespace PSBLab --metric-name AnomalyBatches `
    --statistic Sum --period 300 --evaluation-periods 3 --datapoints-to-alarm 3 --threshold 0 `
    --comparison-operator LessThanOrEqualToThreshold --treat-missing-data breaching    # no actions (no SNS topic)

# Logs Insights style check: recent errors in the ingest log
aws logs tail /aws/lambda/psb-ingest-telemetry --since 1h | Select-String "ERROR|Traceback" | Select-Object -Last 5
```

### Task 2: Security review (console reading)

| Finding | Lab setting | Production recommendation |
|---|---|---|
| Secret rotation | Off | Enable rotation for `psb/influxdb/admin-token` |
| InfluxDB access | Publicly accessible | Private subnets + VPC-attached Lambdas |
| IAM roles (IoT rule + 4 Lambda roles) | Inline least-privilege policies | Keep scoped ARNs, review with IAM Access Analyzer |

### Task 3: Teardown

```powershell
# 1) Stop the simulator
Get-Content "$Work\sim.pid" -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_ -ErrorAction SilentlyContinue }

# 2) Stop the space (delete its running JupyterLab app)
(AwsJson sagemaker list-apps --domain-id-equals $DomainId --space-name-equals psb-lab-space).Apps |
    Where-Object { $_.Status -in @("InService", "Pending") } |
    ForEach-Object { aws sagemaker delete-app --domain-id $DomainId --space-name psb-lab-space --app-type $_.AppType --app-name $_.AppName; "stopping $($_.AppName)" }

# 3) Delete the endpoint (the model stays in s3://<bucket>/model/)
aws sagemaker delete-endpoint --endpoint-name psb-anomaly-endpoint

# 4) Disable the scheduled scoring rule
aws events disable-rule --name psb-lab-score-every-5-min

# 5) Delete InfluxDB (no final snapshot)
$InfluxId = ((AwsJson timestream-influxdb list-db-instances).items | Where-Object { $_.name -eq "psb-lab-influx" }).id
aws timestream-influxdb delete-db-instance --identifier $InfluxId --query status --output text   # DELETING
```

Console way: **EventBridge > Rules > psb-lab-score-every-5-min > Disable**; **Timestream > InfluxDB instances > psb-lab-influx > Actions > Delete**, clear **Create final snapshot**, type `delete me`.

### ✅ Expected validator result

| Check | Result |
|---|---|
| Log retention 1 week on the 4 Lambda log groups | PASS |
| Metric filter psb-lab-anomaly-batches | PASS |
| Alarm psb-lab-scoring-pipeline-stalled | PASS |
| Teardown: endpoint deleted | PASS |
| Teardown: EventBridge rule psb-lab-score-every-5-min disabled | PASS |
| Teardown: InfluxDB deleted (or DELETING) | PASS |
| Teardown: space stopped | PASS |

---

## 🆘 Support

Contact **cloudlabs-support@spektrasystems.com** (24/7).
