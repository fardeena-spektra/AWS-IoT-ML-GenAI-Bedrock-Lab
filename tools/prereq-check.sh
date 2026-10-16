#!/usr/bin/env bash
# =============================================================================
# AWS Demo || Bedrock with Claude : pre-requisite check (run in AWS CloudShell)
#
#   curl -s https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/tools/prereq-check.sh | bash
#   (optional) DEPLOYMENT_ID=2430977 bash prereq-check.sh
#
# Read-only, except one tiny Bedrock test call (a few tokens) and one SSM
# Run Command on the lab VM that only reads files and versions.
# =============================================================================
export AWS_PAGER=""
LAB_REGION=ap-southeast-1
if [ -z "${DEPLOYMENT_ID:-}" ]; then
  DEPLOYMENT_ID=$(aws s3api list-buckets --query "Buckets[?starts_with(Name,'psb-lab-')].Name" --output text 2>/dev/null | tr '\t' '\n' | head -1 | sed 's/^psb-lab-//')
fi
if [ -z "${REGION:-}" ]; then
  echo "Finding the region of windowsvm-$DEPLOYMENT_ID (scanning all regions) ..."
  for r in $LAB_REGION $(aws ec2 describe-regions --query "Regions[].RegionName" --output text 2>/dev/null); do
    v=$(aws --region "$r" ec2 describe-instances --filters "Name=tag:Name,Values=windowsvm-$DEPLOYMENT_ID" \
        "Name=instance-state-name,Values=pending,running,stopping,stopped" --query "Reservations[0].Instances[0].InstanceId" --output text 2>/dev/null)
    if [ -n "$v" ] && [ "$v" != "None" ]; then REGION="$r"; break; fi
  done
  REGION="${REGION:-$LAB_REGION}"
fi
export AWS_DEFAULT_REGION="$REGION"
PASS=0; FAIL=0; WARN=0
G=$'\e[32m'; R=$'\e[31m'; Y=$'\e[33m'; B=$'\e[36m'; N=$'\e[0m'
pass(){ echo "  ${G}[PASS]${N} $*"; PASS=$((PASS+1)); }
ERR=/tmp/psb-err; : > $ERR
fail(){ echo "  ${R}[FAIL]${N} $*"; FAIL=$((FAIL+1))
  if grep -qiE 'AccessDenied|UnauthorizedOperation|not authorized' $ERR; then
    echo "         ${R}reason: ACCESS DENIED for this user:${N} $(grep -oiE 'User: .*|not authorized to perform: [a-z0-9:-]+[A-Za-z]+' $ERR | head -1 | cut -c1-200)"; fi; : > $ERR; }
warn(){ echo "  ${Y}[WARN]${N} $*"; WARN=$((WARN+1)); }
info(){ echo "  ${B}[INFO]${N} $*"; }
sec(){ echo; echo "${B}=== $* ===${N}"; }
q(){ aws "$@" 2>$ERR; }

sec "0. Identity and Region"
ID_JSON=$(q sts get-caller-identity)
[ -n "$ID_JSON" ] || { fail "Cannot call AWS (sts get-caller-identity). Check CloudShell credentials."; exit 1; }
ACCOUNT=$(echo "$ID_JSON" | jq -r .Account); CALLER=$(echo "$ID_JSON" | jq -r .Arn)
info "Account : $ACCOUNT"; info "Caller  : $CALLER"; info "Region  : $REGION (resources found here)"
[ "$REGION" = "$LAB_REGION" ] && pass "Lab deployed in $LAB_REGION" || warn "Lab deployed in $REGION, the guides use $LAB_REGION. Checks below run in $REGION."
[ "$(aws configure get region 2>/dev/null || echo "$AWS_REGION")" = "$REGION" ] || info "CloudShell default region differs; this script forces $REGION"

sec "1. Deployment ID and CloudFormation stack"
if [ -z "${DEPLOYMENT_ID:-}" ]; then
  BUCKET=$(q s3api list-buckets --query "Buckets[?starts_with(Name,'psb-lab-')].Name" --output text | tr '\t' '\n' | head -1)
  DEPLOYMENT_ID="${BUCKET#psb-lab-}"
fi
BUCKET="psb-lab-${DEPLOYMENT_ID}"
[ -n "$DEPLOYMENT_ID" ] && pass "Deployment ID detected: $DEPLOYMENT_ID" || { fail "No psb-lab-* bucket found, cannot detect the deployment ID (set DEPLOYMENT_ID=...)"; }
STACK=$(q cloudformation describe-stacks --query "Stacks[?Outputs[?OutputKey=='LabBucketName' && OutputValue=='$BUCKET']].[StackName,StackStatus]" --output text | head -1)
if [ -n "$STACK" ]; then
  S_NAME=$(echo "$STACK" | awk '{print $1}'); S_STATUS=$(echo "$STACK" | awk '{print $2}')
  [[ "$S_STATUS" == *_COMPLETE && "$S_STATUS" != *ROLLBACK* ]] && pass "Stack $S_NAME is $S_STATUS" || fail "Stack $S_NAME is $S_STATUS"
  echo "  Outputs:"
  q cloudformation describe-stacks --stack-name "$S_NAME" --query "Stacks[0].Outputs[].[OutputKey,OutputValue]" --output text \
    | grep -viE "password" | sed 's/^/    /'
  for k in AWSAccountId LabRegion LabBucketName SageMakerDomainName SignInUrl AWSUserName WindowsVMPublicIP; do
    v=$(q cloudformation describe-stacks --stack-name "$S_NAME" --query "Stacks[0].Outputs[?OutputKey=='$k'].OutputValue" --output text)
    [ -n "$v" ] && [ "$v" != "None" ] && pass "Output $k present (inject key)" || warn "Output $k missing (redeploy with the latest template, then map it in CloudLabs)"
  done
else
  warn "Lab stack not visible to this user (CloudLabs may deploy it with another role). Resource checks continue."
fi

sec "2. Network (CloudLabs wrapper)"
VPC=$(q ec2 describe-vpcs --filters "Name=tag:Name,Values=clgvpc-$DEPLOYMENT_ID" --query "Vpcs[0].VpcId" --output text)
[ -n "$VPC" ] && [ "$VPC" != "None" ] && pass "VPC clgvpc-$DEPLOYMENT_ID ($VPC)" || fail "VPC clgvpc-$DEPLOYMENT_ID not found"
NSUB=$(q ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC" --query "length(Subnets)" --output text)
[ "${NSUB:-0}" -ge 2 ] 2>/dev/null && pass "$NSUB subnets in the lab VPC" || fail "Expected 2 subnets in the lab VPC, found ${NSUB:-0}"
q ec2 describe-security-groups --filters "Name=group-name,Values=clgSg-$DEPLOYMENT_ID" --query "SecurityGroups[0].GroupId" --output text | grep -q sg- \
  && pass "Security group clgSg-$DEPLOYMENT_ID" || fail "Security group clgSg-$DEPLOYMENT_ID not found"
q ec2 describe-key-pairs --key-names "labkeypair-$DEPLOYMENT_ID" >/dev/null && pass "Key pair labkeypair-$DEPLOYMENT_ID" || fail "Key pair labkeypair-$DEPLOYMENT_ID not found"
DEFVPC=$(q ec2 describe-vpcs --filters Name=isDefault,Values=true --query "Vpcs[0].VpcId" --output text)
[ -n "$DEFVPC" ] && [ "$DEFVPC" != "None" ] && pass "Default VPC exists ($DEFVPC), needed for InfluxDB in Lab 02" || fail "No default VPC in $REGION. Lab 02 creates InfluxDB in the default VPC."

sec "3. Lab VM (Amazon EC2 + SSM)"
INST=$(q ec2 describe-instances --filters "Name=tag:Name,Values=windowsvm-$DEPLOYMENT_ID" "Name=instance-state-name,Values=pending,running,stopped" \
  --query "Reservations[0].Instances[0].[InstanceId,State.Name,InstanceType,IamInstanceProfile.Arn,PublicIpAddress]" --output text)
IID=$(echo "$INST" | awk '{print $1}')
if [ -n "$IID" ] && [ "$IID" != "None" ]; then
  read -r _ ISTATE ITYPE IPROF IPIP <<<"$INST"
  [ "$ISTATE" = running ] && pass "VM windowsvm-$DEPLOYMENT_ID ($IID) is running, public IP $IPIP" || fail "VM is $ISTATE (start it from the Resources tab)"
  [[ "$ITYPE" =~ ^t3\.(medium|large)$|^t2\.medium$ ]] && pass "Instance type $ITYPE" || warn "Instance type $ITYPE (t3.medium expected)"
  [ "$IPROF" != "None" ] && pass "Instance profile attached" || fail "No instance profile (SSM will not work)"
  PING=$(q ssm describe-instance-information --filters "Key=InstanceIds,Values=$IID" --query "InstanceInformationList[0].PingStatus" --output text)
  [ "$PING" = Online ] && pass "SSM agent Online" || fail "SSM agent status: ${PING:-not registered} (VM seeding cannot be checked)"
else
  fail "VM windowsvm-$DEPLOYMENT_ID not found"; PING=""
fi

if [ "$PING" = Online ]; then
  sec "4. Seeded on the VM (via SSM Run Command, read-only)"
  cat > /tmp/psb-vmcheck.ps1 <<'PS'
$ErrorActionPreference='SilentlyContinue'
function Chk($name,$ok,$detail){ if($ok){"PASS|$name|$detail"}else{"FAIL|$name|$detail"} }
$env:Path=[Environment]::GetEnvironmentVariable('Path','Machine')
$root='C:\psb-lab-assets'
$files=@('simulator\simulate_pi.py','simulator\requirements.txt','lambda\psb-ingest-telemetry.py','lambda\psb-query-telemetry.py','lambda\psb-score-telemetry.py','lambda\psb-assistant.py','dashboard\package.json','dashboard\src\config.js','dashboard\src\App.jsx','dashboard\dist.zip','notebook\psb-anomaly-detection.ipynb','policies\iot-device-policy.json','policies\iot-rule-role-policy.json','policies\lambda-execution-policy.json')
foreach($f in $files){ Chk "asset $f" (Test-Path (Join-Path $root $f)) '' }
Chk 'folder simulator\certs' (Test-Path "$root\simulator\certs") 'learner extracts the connection kit here in Lab 01'
Chk 'config.js has no assistantEnabled yet' (-not (Select-String -Path "$root\dashboard\src\config.js" -Pattern 'assistantEnabled' -Quiet)) 'Lab 08 adds it'
Chk 'desktop shortcut psb-lab-assets' (Test-Path 'C:\Users\Public\Desktop\psb-lab-assets.lnk') ''
Chk 'desktop file aws credentials.txt' (Test-Path 'C:\Users\Public\Desktop\aws credentials.txt') ''
$lnk=Get-ChildItem 'C:\Users\Public\Desktop','C:\Users\*\Desktop' -Filter '*.lnk' -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'AWS|Console' } | Select-Object -First 1
if($lnk){ "PASS|desktop AWS Console shortcut|$($lnk.Name)" } else { 'WARN|desktop AWS Console shortcut|not found (optional, the learner can use the Sign-in URL)' }
$py=(& python --version 2>&1) -join ' '; Chk 'python' ($py -match 'Python 3') $py
$pm=(& python -m pip show paho-mqtt 2>&1 | Select-String '^Version').ToString(); Chk 'paho-mqtt 1.6.x' ($pm -match '1\.6\.') $pm
$nd=(& node -v 2>&1) -join ' '; Chk 'node' ($nd -match '^v\d+') $nd
$np=(& npm.cmd -v 2>&1) -join ' '; Chk 'npm' ($np -match '^\d+') $np
$gt=(& git --version 2>&1) -join ' '; Chk 'git' ($gt -match 'git version') $gt
$aw=(& aws --version 2>&1) -join ' '; Chk 'aws cli v2' ($aw -match 'aws-cli/2') $aw
$code=(Test-Path 'C:\Program Files\Microsoft VS Code\Code.exe') -or (Test-Path 'C:\Users\*\AppData\Local\Programs\Microsoft VS Code\Code.exe'); Chk 'VS Code' $code ''
$chrome=(Test-Path 'C:\Program Files\Google\Chrome\Application\chrome.exe') -or (Test-Path 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'); Chk 'Google Chrome' $chrome ''
Chk 'Microsoft Edge' (Test-Path 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe') ''
$reg=[Environment]::GetEnvironmentVariable('AWS_DEFAULT_REGION','Machine'); Chk 'AWS_DEFAULT_REGION (machine)' ($reg -eq '__REGION__') $reg
$u=Get-LocalUser -Name 'labuser'; Chk 'local user labuser' ($null -ne $u) ''
Chk 'bootstrap log C:\cloudlabs-bootstrap.log' (Test-Path 'C:\cloudlabs-bootstrap.log') ''
$err=Select-String -Path 'C:\cloudlabs-bootstrap.log' -Pattern 'failed:|download attempt .* failed' -ErrorAction SilentlyContinue | Select-Object -Last 3
if($err){ $err | ForEach-Object { "WARN|bootstrap log|$($_.Line.Trim())" } }
PS
  CMD_ID=$(aws ssm send-command --instance-ids "$IID" --document-name AWS-RunPowerShellScript \
    --comment "psb prereq check (read-only)" --timeout-seconds 120 \
    --parameters "$(sed -i "s/__REGION__/$REGION/" /tmp/psb-vmcheck.ps1; jq -n --rawfile s /tmp/psb-vmcheck.ps1 '{commands: ($s | split("\n"))}')" \
    --query Command.CommandId --output text 2>/dev/null)
  if [ -z "$CMD_ID" ]; then
    fail "Could not send the SSM command (missing ssm:SendCommand permission?)"
  else
    info "SSM command $CMD_ID sent, waiting for the VM ..."
    for i in $(seq 1 40); do
      ST=$(q ssm get-command-invocation --command-id "$CMD_ID" --instance-id "$IID" --query Status --output text)
      [[ "$ST" =~ ^(Success|Failed|Cancelled|TimedOut)$ ]] && break; sleep 3
    done
    OUT=$(q ssm get-command-invocation --command-id "$CMD_ID" --instance-id "$IID" --query StandardOutputContent --output text)
    [ -n "$OUT" ] || fail "No output from the VM (status: $ST)"
    while IFS='|' read -r r n d; do
      case "$r" in
        PASS) pass "$n ${d:+($d)}";; FAIL) fail "$n ${d:+($d)}";; WARN) warn "$n: $d";;
      esac
    done <<<"$OUT"
  fi
fi

sec "5. Amazon S3 lab bucket"
if q s3api head-bucket --bucket "$BUCKET" >/dev/null; then
  pass "Bucket $BUCKET exists"
  LOC=$(q s3api get-bucket-location --bucket "$BUCKET" --query LocationConstraint --output text)
  [ "$LOC" = "$REGION" ] && pass "Bucket region $LOC" || fail "Bucket region is $LOC (expected $REGION)"
  CNT=$(q s3api list-objects-v2 --bucket "$BUCKET" --max-keys 5 --query "KeyCount" --output text)
  [ "${CNT:-0}" = 0 ] && pass "Bucket is empty (learner creates raw/, curated/, model/ in Lab 02)" || warn "Bucket already has $CNT+ objects"
  q s3api get-public-access-block --bucket "$BUCKET" --query "PublicAccessBlockConfiguration.BlockPublicPolicy" --output text | grep -q True \
    && pass "Block Public Access on" || warn "Block Public Access not fully on"
else
  fail "Bucket $BUCKET not found"
fi

sec "6. Amazon SageMaker AI (pre-created domain)"
DOM=$(q sagemaker list-domains --query "Domains[?DomainName=='psb-lab-domain'].[DomainId,Status]" --output text)
if [ -n "$DOM" ]; then
  read -r DOMID DSTAT <<<"$DOM"
  [ "$DSTAT" = InService ] && pass "Domain psb-lab-domain ($DOMID) InService" || fail "Domain psb-lab-domain is $DSTAT"
  UP=$(q sagemaker describe-user-profile --domain-id "$DOMID" --user-profile-name psb-lab-user --query Status --output text)
  [ "$UP" = InService ] && pass "User profile psb-lab-user InService" || fail "User profile psb-lab-user: ${UP:-missing}"
  ROLE=$(q sagemaker describe-domain --domain-id "$DOMID" --query DefaultUserSettings.ExecutionRole --output text)
  info "Execution role: $ROLE"
  q iam get-role --role-name "psb-lab-sagemaker-exec-$DEPLOYMENT_ID" >/dev/null && pass "Role psb-lab-sagemaker-exec-$DEPLOYMENT_ID exists" || fail "Role psb-lab-sagemaker-exec-$DEPLOYMENT_ID not found"
  SP=$(q sagemaker list-spaces --domain-id-equals "$DOMID" --query "Spaces[?SpaceName=='psb-lab-space'].Status" --output text)
  [ -z "$SP" ] && pass "Space psb-lab-space not created yet (learner creates it in Lab 06)" || warn "Space psb-lab-space already exists ($SP)"
else
  fail "Domain psb-lab-domain not found"
fi

sec "7. Amazon Bedrock (Lab 08)"
for MID in amazon.nova-lite-v1:0 apac.amazon.nova-lite-v1:0; do
  R_OUT=$(aws bedrock-runtime converse --model-id "$MID" --messages '[{"role":"user","content":[{"text":"Say OK and nothing else."}]}]' \
          --inference-config maxTokens=5 --query "output.message.content[0].text" --output text 2>&1)
  if [ $? -eq 0 ]; then pass "Converse works with $MID (reply: $R_OUT)"
  else info "Converse with $MID not usable here (optional): $(echo "$R_OUT" | tail -1 | cut -c1-160)"; fi
done
info "Lab 08 uses amazon.nova-lite-v1:0. If only the apac. ID works, use MODEL_ID=apac.amazon.nova-lite-v1:0."

sec "8. Service quotas (SageMaker)"
QS=$(q service-quotas list-service-quotas --service-code sagemaker --query "Quotas[].[QuotaName,Value]" --output text)
chkq(){ local pat="$1" need="$2" label="$3" v
  v=$(echo "$QS" | grep -iE "$pat" | head -1 | awk -F'\t' '{print $2}')
  if [ -z "$v" ]; then warn "$label: quota not found in the list"
  elif awk "BEGIN{exit !($v >= $need)}"; then pass "$label = $v"
  else fail "$label = $v (need $need)"; fi; }
chkq "^ml\.m5\.large for training job usage" 1 "Training ml.m5.large"
chkq "JupyterLab.*ml\.t3\.medium" 1 "Studio JupyterLab ml.t3.medium"
chkq "^Maximum total concurrency that can be allocated across all serverless endpoints" 5 "Serverless endpoint total concurrency"

sec "9. Lab resources that must NOT exist yet (fresh environment)"
nope(){ if eval "$2" >/dev/null 2>&1; then warn "$1 already exists (left over from a previous run?)"; else pass "$1 not created yet"; fi; }
nope "IoT thing psb-lab-sensor-01"           "aws iot describe-thing --thing-name psb-lab-sensor-01"
nope "IoT policy psb-lab-device-policy"       "aws iot get-policy --policy-name psb-lab-device-policy"
nope "IoT rule psb_telemetry_rule"            "aws iot get-topic-rule --rule-name psb_telemetry_rule"
nope "InfluxDB psb-lab-influx"                "aws timestream-influxdb list-db-instances --query \"items[?name=='psb-lab-influx'].id\" --output text | grep -q ."
nope "Secret psb/influxdb/admin-token"        "aws secretsmanager describe-secret --secret-id psb/influxdb/admin-token"
for fn in psb-ingest-telemetry psb-query-telemetry psb-score-telemetry psb-assistant; do nope "Lambda $fn" "aws lambda get-function --function-name $fn"; done
nope "HTTP API psb-lab-api"                   "aws apigatewayv2 get-apis --query \"Items[?Name=='psb-lab-api'].ApiId\" --output text | grep -q ."
nope "Cognito pool psb-lab-users"             "aws cognito-idp list-user-pools --max-results 60 --query \"UserPools[?Name=='psb-lab-users'].Id\" --output text | grep -q ."
nope "Amplify app psb-lab-dashboard"          "aws amplify list-apps --query \"apps[?name=='psb-lab-dashboard'].appId\" --output text | grep -q ."
nope "SageMaker endpoint psb-anomaly-endpoint" "aws sagemaker describe-endpoint --endpoint-name psb-anomaly-endpoint"
nope "EventBridge rule psb-lab-score-every-5-min" "aws events describe-rule --name psb-lab-score-every-5-min"
nope "Alarm psb-lab-scoring-pipeline-stalled" "aws cloudwatch describe-alarms --alarm-names psb-lab-scoring-pipeline-stalled --query 'MetricAlarms[0].AlarmName' --output text | grep -q psb"

sec "10. Service reachability for the learner (read-only list calls)"
for c in "iot list-things --max-results 1" "timestream-influxdb list-db-instances --max-results 1" "lambda list-functions --max-items 1" \
         "secretsmanager list-secrets --max-results 1" "apigatewayv2 get-apis --max-results 1" "cognito-idp list-user-pools --max-results 1" \
         "amplify list-apps --max-results 1" "sagemaker list-endpoints --max-results 1" "events list-rules --limit 1" \
         "logs describe-log-groups --limit 1" "cloudwatch describe-alarms --max-records 1" "iam list-roles --max-items 1"; do
  svc=${c%% *}; aws $c >/dev/null 2>&1 && pass "$svc reachable" || fail "$svc: access denied or not available ($c)"
done

echo
echo "${B}=====================================================${N}"
echo " RESULT: ${G}$PASS passed${N}, ${Y}$WARN warnings${N}, ${R}$FAIL failed${N}"
echo "${B}=====================================================${N}"
[ "$FAIL" -eq 0 ] && echo " Environment ready: you can start Lab 01." || echo " Fix the FAIL items before starting the labs."
