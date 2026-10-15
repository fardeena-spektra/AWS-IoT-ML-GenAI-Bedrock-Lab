# ✅ Validation scripts: AWS Demo || Bedrock with Claude

One CloudLabs validation per lab. Each script checks **all tasks of its lab**, prints `[n/N] <check> ... PASS/FAIL` to the function log, and returns `{"Status":"Succeeded|Failed","Message":"..."}`. On failure the message is a numbered list of what is missing and how to fix it.

## ⚙️ CloudLabs settings (all 9 scripts)

| Setting | Value |
|---|---|
| Script Type | PowerShellV2 |
| Run As | System |
| Parameter `DeploymentId` | `GET-DEPLOYMENT-ID` |
| Parameter `AccessKey` | lab account access key ID available to the CloudLabs validation function |
| Parameter `SecretKey` | matching secret access key |
| Parameter `Region` | `ap-southeast-1` (default in the script, map it only if you want to be explicit) |

The bucket is derived as `psb-lab-<DeploymentId>`. All other resources are found by the exact names from the lab guide. Every AWS call is wrapped so a missing resource gives a clean fix message, not an exception. Each script finishes in a few seconds (log searches are capped at about 15 s).

## 🗂️ Scripts

| Lab | Validator file | Step GUID | What it checks |
|---|---|---|---|
| 01 | `LAB01-IoT-Identity-and-Simulator.ps1` | `59e26375-0ffb-4c71-9cb9-f49c28ae85b5` | Thing `psb-lab-sensor-01`; exactly one ACTIVE certificate; `psb-lab-device-policy` is the only policy on it; policy allows `client/psb-lab-sensor-01` connect + `topic/psb/lab/psb-lab-sensor-01/telemetry` publish with no `*`; `AWS/IoT PublishIn.Success` (Protocol=MQTT, or no dimension) > 0 in last 24 h |
| 02 | `LAB02-Rules-Engine-InfluxDB-S3.ps1` | `ec8803f3-325c-470e-9da5-42325d1dc1f5` | InfluxDB `psb-lab-influx` AVAILABLE, public, `db.influx.medium`; `raw/` `curated/` `model/` in the bucket; `psb-lab-iot-rule-role` trusts IoT, no managed policies, inline `psb-lab-iot-rule-s3-write` (PutObject on `raw/*` only); secret `psb/influxdb/admin-token`; `psb-ingest-telemetry` (py3.13, 256 MB, 15 s, 4 Influx env vars, URL `https://...:8086` pointing at the instance) + inline `psb-lab-read-influx-token` (GetSecretValue on the secret ARN); rule `psb_telemetry_rule` enabled, SQL from `psb/lab/+/telemetry`, Lambda + S3 actions (key `raw/...`, role `psb-lab-iot-rule-role`), IoT invoke permission; objects under `raw/`; `[ok] wrote` in the ingest log (24 h) |
| 03 | `LAB03-Query-API.ps1` | `b3b85ffd-0738-464e-95e6-961cb0e28b22` | `psb-query-telemetry` (py3.13, 256 MB, 30 s, Influx env) + inline `psb-lab-read-influx-token`; HTTP API `psb-lab-api` with CORS (origin `*`, headers authorization/content-type, methods GET/POST/OPTIONS, max age 300); routes `GET /telemetry` + `GET /anomalies` integrated to the Lambda (payload 2.0); `$default` stage auto-deploy; API Gateway invoke permission; live invoke with `{"metric":"temperature_c","window_minutes":60,"bucket_seconds":60}` returns points |
| 04 | `LAB04-Cognito-Auth.ps1` | `e7c33a7a-0ce1-4bf3-8625-fe61aca5a505` | Pool `psb-lab-users`; client `psb-lab-dashboard` (implicit + code, scopes email openid profile, callback `http://localhost:5173/`); domain prefix `psb-lab-<DeploymentId>`; `student@psb.lab` CONFIRMED; JWT authorizer `psb-lab-cognito-authorizer` (identity source `$request.header.Authorization`, issuer = pool, audience = client ID); both GET routes use it |
| 05 | `LAB05-Amplify-Dashboard.ps1` | `385a58e4-0c21-49a6-8b28-97567e7c1d96` | Amplify app `psb-lab-dashboard`; branch `main`; latest job SUCCEED; rewrite `/<*>` to `/index.html` (404-200); `https://main.<default-domain>/` in Cognito callback and sign-out URLs |
| 06 | `LAB06-SageMaker-Anomaly-Model.ps1` | `6fbeccac-a90e-4b5c-bdff-42f1a7e47d06` | At least 1000 objects under `raw/` (backfill); domain `psb-lab-domain` InService; user `psb-lab-user`; space `psb-lab-space`; Completed RandomCutForest training job with output under `s3://psb-lab-<id>/model/`; endpoint `psb-anomaly-endpoint` InService; `curated/scored/backfill-scored.csv` |
| 07 | `LAB07-Scoring-Pipeline.ps1` | `764c112b-0f8a-4fe6-bd41-1600dcacdfc2` | `psb-score-telemetry` (py3.13, 512 MB, 60 s, Influx env + `SAGEMAKER_ENDPOINT`, `S3_BUCKET`, numeric `ANOMALY_CUTOFF`, `WINDOW_MINUTES`); inline `psb-lab-score-telemetry-policy` (InvokeEndpoint on the endpoint, PutObject on `curated/*` only, GetSecretValue on the secret); rule `psb-lab-score-every-5-min` `rate(5 minutes)` ENABLED targeting the Lambda + EventBridge invoke permission; `[ok] scored=` in the last 30 min; scored CSVs under `curated/scored/` besides the backfill file |
| 08 | `LAB08-Bedrock-Assistant.ps1` | `e1a21ce3-4651-45b5-9ae9-cd24b2830886` | `psb-assistant` (py3.13, 512 MB, 90 s, `MODEL_ID`, `QUERY_FUNCTION_NAME=psb-query-telemetry`, numeric `MAX_TOOL_TURNS`); inline `psb-lab-assistant-policy` (`bedrock:InvokeModel` on the MODEL_ID inference profile `apac.amazon.nova-lite-v1:0` and the `amazon.nova-lite-v1:0` foundation model, `lambda:InvokeFunction` on `psb-query-telemetry`, no `*`); route `POST /assistant` with the JWT authorizer and a payload 2.0 integration to `psb-assistant`; invocations in the last 24 h; Amplify `main` has 2 or more successful jobs |
| 09 | `LAB09-Observability-and-Teardown.ps1` | `027c2deb-6e02-4002-a48b-92c92d1dcb95` | Retention 7 days on the 4 `/aws/lambda/psb-*` groups; metric filter `psb-lab-anomaly-batches` (`"[ok] scored="`, PSBLab/AnomalyBatches, value 1, default 0); alarm `psb-lab-scoring-pipeline-stalled` (Sum, 300 s, `<= 0`, 3 of 3, missing = breaching, no actions); teardown: endpoint gone (or Deleting), rule disabled, InfluxDB deleted or DELETING, no InService/Pending app in `psb-lab-space` |

## 📦 AWS.Tools modules needed on the Function App

Add these to the Function App `requirements.psd1` (AWS.Tools v4 or v5, all the same version):

| Module | Used by |
|---|---|
| `AWS.Tools.Common` | all |
| `AWS.Tools.SecurityToken` | 01 (optional, used to pin the account ID in policy checks) |
| `AWS.Tools.IoT` | 01, 02, 09 |
| `AWS.Tools.CloudWatch` | 01, 09 |
| `AWS.Tools.CloudWatchLogs` | 02, 07, 08, 09 |
| `AWS.Tools.TimestreamInfluxDB` | 02, 09 |
| `AWS.Tools.S3` | 02, 06, 07 |
| `AWS.Tools.IdentityManagement` | 02, 03, 07, 08 |
| `AWS.Tools.SecretsManager` | 02, 03 |
| `AWS.Tools.Lambda` | 02, 03, 07, 08 |
| `AWS.Tools.ApiGatewayV2` | 03, 04, 08 |
| `AWS.Tools.CognitoIdentityProvider` | 04, 05 |
| `AWS.Tools.Amplify` | 05, 08 |
| `AWS.Tools.SageMaker` | 06, 09 |
| `AWS.Tools.EventBridge` | 07 |

Example `requirements.psd1` lines: `'AWS.Tools.Common' = '4.*'`, `'AWS.Tools.IoT' = '4.*'`, and so on. If a module is missing, the script fails with a clear message naming it.

## 🔐 Permissions the validation keys need (read-only)

`iot:DescribeThing, ListThingPrincipals, DescribeCertificate, ListAttachedPolicies, GetPolicy, GetTopicRule`, `cloudwatch:GetMetricStatistics, DescribeAlarms`, `logs:DescribeLogGroups, DescribeMetricFilters, FilterLogEvents`, `timestream-influxdb:ListDbInstances, GetDbInstance`, `s3:ListBucket`, `iam:GetRole, ListRolePolicies, GetRolePolicy, ListAttachedRolePolicies`, `secretsmanager:DescribeSecret`, `lambda:GetFunctionConfiguration, GetPolicy, InvokeFunction` (only on `psb-query-telemetry`, Lab 03), `apigateway:GET`, `cognito-idp:ListUserPools, DescribeUserPool, ListUserPoolClients, DescribeUserPoolClient, AdminGetUser`, `amplify:ListApps, GetApp, ListBranches, ListJobs`, `sagemaker:ListDomains, DescribeUserProfile, DescribeSpace, ListApps, ListTrainingJobs, DescribeTrainingJob, DescribeEndpoint`, `events:DescribeRule, ListTargetsByRule`, `sts:GetCallerIdentity`.

## 🧪 Testing done

- All 9 scripts parse with zero errors (`[System.Management.Automation.Language.Parser]::ParseFile`).
- Each script was run in pwsh against stub AWS cmdlets for: a fully completed lab (all PASS, `Succeeded`), an empty account (every check FAIL with a fix message, no exceptions), and wrong-policy cases (wizard policy left on the certificate, `iot:*` / `*` in the device policy, PutObject on the whole bucket).
- Not yet run against a live lab account. Run each one once in CloudLabs before go-live.
