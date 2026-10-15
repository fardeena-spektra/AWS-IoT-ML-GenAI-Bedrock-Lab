<h1 align="center">⚙️ Lab 07: Build the Scheduled Scoring Pipeline</h1>
<p align="center"><b>AWS Demo || Bedrock with Claude</b> | ⏱️ <b>Estimated Timing: 50 Minutes</b></p>

---

## 🎯 Overview

Your model is live behind a serverless endpoint. In this lab, you automate scoring: a Lambda function reads the latest telemetry from InfluxDB every 5 minutes, sends it to **psb-anomaly-endpoint**, writes anomaly scores back to InfluxDB and a CSV to S3. Your API and dashboard then show the **anomaly_score** metric.

## 📋 Objectives

In this lab, you will complete the following tasks:

1. 🧮 **Task 1:** Create the psb-score-telemetry Lambda function.
1. ⏰ **Task 2:** Schedule it every 5 minutes with Amazon EventBridge.
1. 🔍 **Task 3:** Verify anomalies in the API, the dashboard and S3.

## 🏗️ What you build

```text
EventBridge rate(5 minutes) ──► psb-score-telemetry
                                  ├─► InfluxDB (read last 6 min of telemetry)
                                  ├─► SageMaker psb-anomaly-endpoint (text/csv)
                                  ├─► InfluxDB measurement "anomaly" (anomaly_score, flagged)
                                  └─► S3 curated/scored/YYYY/MM/DD/HHMMSS.csv
```

> ⚠️ **Note:** Have your **ANOMALY_CUTOFF** value from Lab 06 and the InfluxDB endpoint and secret ARN from Lab 02 ready.

---

## 🧩 Task 1: Create the psb-score-telemetry Lambda function

🎯 **Goal:** Deploy the scoring function with the right settings, environment variables and least-privilege permissions.

1. Open **AWS Lambda** > **Functions** and select **Create function**.

1. Choose **Author from scratch** and enter:

   | Setting | Value |
   |---|---|
   | **Function name** | psb-score-telemetry |
   | **Runtime** | Python 3.13 |
   | **Architecture** | x86_64 |
   | **Execution role** | Create a new role with basic Lambda permissions |

1. Select **Create function**.

1. On the lab VM, open **C:\psb-lab-assets\lambdas\psb-score-telemetry\lambda_function.py** in **VS Code**, copy all of it, paste it into the Lambda console editor (replacing the sample code), and select **Deploy**.

   > ℹ️ **Info:** The function:
   > - Reads the last **WINDOW_MINUTES** of telemetry from InfluxDB and pivots the 4 fields into rows.
   > - Sends rows to the endpoint as **text/csv** (temperature_c,humidity_pct,co2_ppm,vibration_g).
   > - Reads the RCF response **{"scores":[{"score":x},...]}** and sets **flagged** when score > **ANOMALY_CUTOFF**.
   > - Writes points to the InfluxDB measurement **anomaly** and a CSV to **curated/scored/YYYY/MM/DD/HHMMSS.csv**.
   > - Prints **[ok] scored=&lt;n&gt; flagged=&lt;m&gt;** (also when n=0) and returns **{"scored":n,"flagged":m}**.

1. Select **Configuration** > **General configuration** > **Edit** and set:

   | Setting | Value |
   |---|---|
   | **Memory** | 512 MB |
   | **Timeout** | 1 min 0 sec |

   Select **Save**.

1. Select **Configuration** > **Environment variables** > **Edit**, add the following 8 variables, and select **Save**:

   | Key | Value |
   |---|---|
   | **INFLUX_URL** | https://&lt;INFLUX-ENDPOINT&gt;:8086 |
   | **INFLUX_ORG** | psb |
   | **INFLUX_BUCKET** | telemetry |
   | **INFLUX_SECRET_ID** | psb/influxdb/admin-token |
   | **SAGEMAKER_ENDPOINT** | psb-anomaly-endpoint |
   | **S3_BUCKET** | <inject key="LabBucketName" enableCopy="true"/> |
   | **ANOMALY_CUTOFF** | your value from Lab 06 (for example 2.8471) |
   | **WINDOW_MINUTES** | 6 |

   > 💡 **Tip:** **WINDOW_MINUTES** is 6 so each 5 minute run overlaps the previous one slightly and no reading is missed.

1. Select **Configuration** > **Permissions** and select the execution role name to open it in IAM.

1. Select **Add permissions** > **Create inline policy**, switch to **JSON**, and paste this policy. Replace **&lt;SECRET-ARN&gt;**, **&lt;AWS-REGION&gt;** (ap-southeast-1), **&lt;AWS-ACCOUNT-ID&gt;** and **&lt;DEPLOYMENT-ID&gt;**:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "AllowReadInfluxToken",
         "Effect": "Allow",
         "Action": "secretsmanager:GetSecretValue",
         "Resource": "<SECRET-ARN>"
       },
       {
         "Sid": "AllowInvokeAnomalyEndpoint",
         "Effect": "Allow",
         "Action": "sagemaker:InvokeEndpoint",
         "Resource": "arn:aws:sagemaker:<AWS-REGION>:<AWS-ACCOUNT-ID>:endpoint/psb-anomaly-endpoint"
       },
       {
         "Sid": "AllowWriteCuratedOnly",
         "Effect": "Allow",
         "Action": "s3:PutObject",
         "Resource": "arn:aws:s3:::psb-lab-<DEPLOYMENT-ID>/curated/*"
       }
     ]
   }
   ```

   The file is also at **C:\psb-lab-assets\policies\psb-lab-score-telemetry-policy.json**. Your Deployment ID is <inject key="DeploymentID" enableCopy="true"/>.

1. Select **Next**, name the policy **psb-lab-score-telemetry-policy**, and select **Create policy**.

1. Back in Lambda, open the **Test** tab, create a new event named **manual-run** with this body, and select **Test**:

   ```json
   {}
   ```

   | Problem | Likely cause and fix |
   |---|---|
   | AccessDenied on InvokeEndpoint | Endpoint ARN in the inline policy has the wrong region or account ID. |
   | AccessDenied on PutObject | **S3_BUCKET** or the bucket name in the policy is wrong. |
   | 403 from InfluxDB | Wrong secret ID or the secret ARN is missing from the policy. |
   | Timeout | Port 8086 not reachable (psb-lab-influx-sg) or the endpoint is cold; run the test again. |

✅ **Expected result:** The test succeeds and the log output shows **[ok] scored=&lt;n&gt; flagged=&lt;m&gt;**.

---

## 🧩 Task 2: Schedule it every 5 minutes with Amazon EventBridge

🎯 **Goal:** Run the scoring function automatically on a fixed schedule.

1. On the **psb-score-telemetry** function page, in **Function overview**, select **Add trigger**.

1. Configure the trigger:

   | Setting | Value |
   |---|---|
   | **Trigger source** | EventBridge (CloudWatch Events) |
   | **Rule** | Create a new rule |
   | **Rule name** | psb-lab-score-every-5-min |
   | **Rule type** | Schedule expression |
   | **Schedule expression** | rate(5 minutes) |

1. Select **Add**.

1. Wait 5 to 10 minutes, then select **Monitor** > **View CloudWatch logs** and open the newest log stream.

   ```text
   [ok] scored=36 flagged=1
   ```

✅ **Expected result:** A new **[ok] scored=... flagged=...** line appears in the log about every 5 minutes.

---

## 🧩 Task 3: Verify anomalies in the API, the dashboard and S3

🎯 **Goal:** See the anomaly scores end to end.

1. Your ID token from Lab 04 expires after 1 hour. If needed, sign in again through the Hosted UI login URL from Lab 04, copy the new **id_token**, and set it in PowerShell:

   ```powershell
   $env:ID_TOKEN = "<ID-TOKEN>"
   ```

1. Call the anomalies route (replace **&lt;API-URL&gt;** with your Invoke URL):

   ```powershell
   curl.exe -H "Authorization: Bearer $env:ID_TOKEN" "<API-URL>/anomalies?window_minutes=60"
   ```

   You see JSON with **window_minutes**, a **points** list (time, location, anomaly_score, flagged, ...) and **flagged_count**.

1. Open your Amplify dashboard, sign in if prompted, and choose **Anomaly score** in the metric selector. Scores are plotted per location.

1. In the S3 console, open <inject key="LabBucketName" enableCopy="false"/> > **curated/scored/** and confirm new CSV files in the **YYYY/MM/DD/** folders.

   ✅ **Expected result:** The API returns anomaly points, the dashboard plots **anomaly_score**, and new CSV files appear in **curated/scored/** every 5 minutes.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="764c112b-0f8a-4fe6-bd41-1600dcacdfc2" />

## 📝 Summary

In this lab, you:

- Created **psb-score-telemetry** (Python 3.13, 512 MB, 1 minute) with 8 environment variables.
- Granted least-privilege access with **psb-lab-score-telemetry-policy** (secret, endpoint, curated/*).
- Scheduled it with the EventBridge rule **psb-lab-score-every-5-min** (rate(5 minutes)).
- Verified anomaly scores through **GET /anomalies**, the dashboard and **curated/scored/** CSV files.

Click **Next** to continue.
