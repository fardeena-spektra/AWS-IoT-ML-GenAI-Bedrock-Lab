PSB lab assets (AWS Demo || Bedrock with Claude)
================================================
Region for everything: ap-southeast-1 (Asia Pacific, Singapore).

simulator\      simulate_pi.py sensor simulator (MQTT over TLS to AWS IoT Core) + requirements.txt.
                Put the IoT "Connect one device" kit files in simulator\certs (see certs\README.txt).
                Live:     python simulate_pi.py --endpoint <IOT-ENDPOINT> --certs-dir certs --interval 10
                Backfill: add --backfill-hours 24 (Lab 06)
lambdas\        Code for the 4 Lambda functions (copy lambda_function.py into the Lambda console):
                  psb-ingest-telemetry  Lab 02  IoT rule -> InfluxDB
                  psb-query-telemetry   Lab 03  HTTP API /telemetry and /anomalies
                  psb-score-telemetry   Lab 07  SageMaker scoring every 5 minutes
                  psb-assistant         Lab 08  Bedrock Converse assistant with tool use
test-events\    Lambda console test events (sample-reading, direct-query, manual-run, ask-question).
policies\       IAM / IoT policy JSON. Replace <AWS-REGION>, <AWS-ACCOUNT-ID>, <DEPLOYMENT-ID>, <SECRET-ARN>.
dashboard\      React dashboard source (Vite). Edit src\config.js, then: npm install, npm run build.
                dist.zip is a prebuilt fallback: edit config.json at its root, re-zip, upload to Amplify.
notebook\       psb-anomaly-detection.ipynb for SageMaker Studio (Lab 06).
