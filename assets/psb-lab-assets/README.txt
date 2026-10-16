PSB lab assets (AWS Demo || Bedrock with Claude)
================================================
Path used by the lab guide: C:\psb-lab-assets. Region for everything: ap-southeast-1.

simulator\   simulate_pi.py + requirements.txt (pip install -r requirements.txt).
             certs\ : extract connect_device_package.zip here (Lab 01).
lambda\      Lambda code. Paste each file into lambda_function.py in the Lambda console.
               psb-ingest-telemetry.py   Lab 02
               psb-query-telemetry.py    Lab 03
               psb-score-telemetry.py    Lab 07
               psb-assistant.py          Lab 08
dashboard\   React dashboard (Vite). Edit src\config.js, then npm install and npm run build (Lab 05).
             dist.zip = pre-built fallback; it reads config.json at its root.
notebook\    psb-anomaly-detection.ipynb for SageMaker Studio (Lab 06).
policies\    iot-device-policy.json        Lab 01 IoT policy
             iot-rule-role-policy.json     Lab 02 IoT rule role (S3 write to raw/)
             lambda-execution-policy.json  Lab 02/03 secret read
             Replace the <...> placeholders before pasting.
