<h1 align="center">🔀 Lab 02: Rules Engine to InfluxDB and S3</h1>
<p align="center"><b>AWS Demo || Bedrock with Claude</b> | ⏱️ <b>Estimated Timing: 65 Minutes</b> | 🏆 <b>Points: 16</b></p>

---

## 🎯 Overview

Your sensor is now publishing to AWS IoT Core. In this lab, you route every message to two destinations with the **IoT Rules Engine**: a time-series database (**Amazon Timestream for InfluxDB**) for fast dashboards and queries, and an **Amazon S3** data lake for machine learning. A **Lambda** function converts each JSON message to InfluxDB line protocol, using an API token stored in **AWS Secrets Manager**.

## 📋 Objectives

- **Task 1:** Create the InfluxDB instance **psb-lab-influx** and get its API token.
- **Task 2:** Prepare the S3 bucket folders and the IoT rule IAM role.
- **Task 3:** Create the ingest Lambda function **psb-ingest-telemetry**.
- **Task 4:** Store the token in Secrets Manager, configure and test the Lambda.
- **Task 5:** Create the IoT rule **psb_telemetry_rule** and verify end-to-end ingestion.

## 🏗️ What you build

```text
IoT Core topic psb/lab/+/telemetry ──> Rule psb_telemetry_rule ─┬─> Lambda psb-ingest-telemetry ──> InfluxDB psb-lab-influx (bucket telemetry)
                                                                └─> S3 psb-lab-<id>/raw/yyyy/MM/dd/HH/<uuid>.json
```

---

## 🧩 Task 1: Create the InfluxDB Instance

🎯 **Goal:** Launch a Timestream for InfluxDB instance that the Lambda function can reach on port **8086**.

1. First, create the security group. In the console search bar, open **EC2**, then select **Network & Security** > **Security Groups** > **Create security group**:

   | Setting | Value |
   |---|---|
   | Security group name | **psb-lab-influx-sg** |
   | Description | **InfluxDB access for psb lab** |
   | VPC | The **default** VPC |
   | Inbound rule | Type **Custom TCP**, Port range **8086**, Source **Anywhere-IPv4 (0.0.0.0/0)** |

   Click **Create security group**.

   > ⚠️ **Note:** Opening port 8086 to the internet is acceptable only for this short-lived lab. You review this risk in Lab 09.

1. In the console search bar, open **Amazon Timestream**. In the left menu select **InfluxDB databases**, then click **Create InfluxDB database**.

1. Enter the following settings:

   | Setting | Value |
   |---|---|
   | Deployment settings | **Single-AZ** (single DB instance) |
   | DB instance name | **psb-lab-influx** |
   | Initial username | **psbadmin** |
   | Initial organization name | **psb** |
   | Initial bucket name | **telemetry** |
   | Password / Confirm password | **PsbLab#2026!Influx** |
   | DB instance class | **db.influx.medium** |
   | Storage type | **Influx IO Included (3000 IOPS)** |
   | Allocated storage | **20 GiB** |
   | Virtual Private Cloud (VPC) | **Default VPC** |
   | Subnets | Leave the default subnets |
   | Public access | **Publicly accessible** |
   | VPC security groups | **psb-lab-influx-sg** (remove **default** if it is selected) |
   | Database port | **8086** |
   | Deletion protection (if shown) | **Not selected (off)** |

   Leave all other settings as default and click **Create InfluxDB database**.

   > ⏳ **Note:** The instance takes **15 to 20 minutes** to become **Available**. Continue with **Task 2** and **Task 3** while it is created, then come back for the token.

1. When the status is **Available**, open **psb-lab-influx** and copy the **Endpoint** value into Notepad as **INFLUX-ENDPOINT** (for example **xxxxxxxx-xxxxxx.ap-southeast-1.timestream-influxdb.amazonaws.com**).

1. Click **InfluxDB UI** (or open **https://&lt;INFLUX-ENDPOINT&gt;:8086** in the browser) and sign in:

   | Setting | Value |
   |---|---|
   | Username | **psbadmin** |
   | Password | **PsbLab#2026!Influx** |

1. In the InfluxDB UI, select **Load Data** (arrow icon) > **API Tokens** > **Generate API Token** > **All Access API Token**. Enter the description **psb-lab-admin** and click **Save**.

1. Copy the token and save it in Notepad as **INFLUX-TOKEN**.

   > ⚠️ **Note:** The token is shown **only once**. If you lose it, generate a new one. The instance **operator token** also works if you already have it.

✅ **Expected result:** **psb-lab-influx** is **Available**, you can sign in to the InfluxDB UI, and you have the endpoint and an all-access API token.

---

## 🧩 Task 2: Prepare the S3 Folders and the IoT Rule Role

🎯 **Goal:** Create the data lake folders and an IAM role that lets IoT Core write only to **raw/**.

1. Open **S3** and select the pre-created bucket **psb-lab-<inject key="DeploymentID" enableCopy="false"/>**.

1. Click **Create folder** three times to create these folders:

   | Folder | Used for |
   |---|---|
   | **raw/** | Raw telemetry written by the IoT rule (this lab) |
   | **curated/** | Scored data written by SageMaker and the score Lambda (Labs 06 and 07) |
   | **model/** | Trained model artifacts (Lab 06) |

1. Open **IAM** > **Roles** > **Create role**. For **Trusted entity type** select **Custom trust policy** and paste this trust policy (also in **C:\psb-lab-assets\policies\psb-lab-iot-rule-trust.json**):

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "AllowIoTRulesEngine",
         "Effect": "Allow",
         "Principal": { "Service": "iot.amazonaws.com" },
         "Action": "sts:AssumeRole"
       }
     ]
   }
   ```

   Click **Next**.

1. On **Add permissions**, do **not** select any managed policy. Click **Next**.

1. Enter the role name **psb-lab-iot-rule-role** and click **Create role**.

1. Open the role **psb-lab-iot-rule-role**. Select **Add permissions** > **Create inline policy**, switch to the **JSON** editor and paste the policy below (also in **psb-lab-iot-rule-s3-write.json**). Replace **&lt;DEPLOYMENT-ID&gt;** with **<inject key="DeploymentID" enableCopy="false"/>**:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "AllowWriteRawTelemetryOnly",
         "Effect": "Allow",
         "Action": "s3:PutObject",
         "Resource": "arn:aws:s3:::psb-lab-<DEPLOYMENT-ID>/raw/*"
       }
     ]
   }
   ```

1. Click **Next**, enter the policy name **psb-lab-iot-rule-s3-write** and click **Create policy**.

✅ **Expected result:** The bucket has **raw/**, **curated/** and **model/** folders, and **psb-lab-iot-rule-role** trusts **iot.amazonaws.com** with only the inline policy **psb-lab-iot-rule-s3-write** (no managed policies).

---

## 🧩 Task 3: Create the Ingest Lambda Function

🎯 **Goal:** Create **psb-ingest-telemetry**, which writes each IoT message to InfluxDB.

1. Open **Lambda** > **Functions** > **Create function**. Select **Author from scratch** and enter:

   | Setting | Value |
   |---|---|
   | Function name | **psb-ingest-telemetry** |
   | Runtime | **Python 3.13** |
   | Architecture | **x86_64** |
   | Execution role | **Create a new role with basic Lambda permissions** |

   Click **Create function**.

1. On the lab VM, open **C:\psb-lab-assets\lambdas\psb-ingest-telemetry\lambda_function.py** in **VS Code**, select all and copy.

1. In the Lambda console **Code** tab, open **lambda_function.py**, replace all content with the copied code and click **Deploy**.

   **What this code does:**

   | Step | Behaviour |
   |---|---|
   | 🔄 Convert | Takes the rule payload (one JSON object) and builds InfluxDB **line protocol**: measurement **telemetry**, tags **device** and **location**, fields **temperature_c**, **humidity_pct**, **co2_ppm**, **vibration_g**, timestamp in **ms**. **injected_anomaly** is not written to InfluxDB. |
   | 📤 Write | Sends **POST /api/v2/write?org=psb&bucket=telemetry&precision=ms** with the header **Authorization: Token &lt;token&gt;**. |
   | 🔐 Token cache | Reads the token from Secrets Manager once and caches it across warm invocations. |
   | ❗ Errors | On an HTTP error it prints the status and body, then **re-raises** the error so failures are visible. |
   | ✅ Success | Prints **[ok] wrote 1 point (204)** and returns **{"written":1,"status":204}**. |

1. Select **Configuration** > **General configuration** > **Edit** and set:

   | Setting | Value |
   |---|---|
   | Memory | **256 MB** |
   | Timeout | **0 min 15 sec** |

   Click **Save**.

✅ **Expected result:** **psb-ingest-telemetry** is deployed with Python 3.13, 256 MB and a 15 second timeout.

---

## 🧩 Task 4: Store the Token, Configure and Test the Lambda

🎯 **Goal:** Give the Lambda the InfluxDB connection details and a least-privilege way to read the token.

1. Open **Secrets Manager** > **Store a new secret** and enter:

   | Setting | Value |
   |---|---|
   | Secret type | **Other type of secret** |
   | Key/value pair | Key **token**, Value **&lt;INFLUX-TOKEN&gt;** (paste your token) |
   | Encryption key | **aws/secretsmanager** (default) |

   Click **Next**.

1. Enter the secret name **psb/influxdb/admin-token** and click **Next**. Leave **Automatic rotation** off, click **Next**, then **Store**.

   > ℹ️ **Info:** The secret value is stored as **{"token":"&lt;admin token&gt;"}**.

1. Open the secret and copy the **Secret ARN** into Notepad as **SECRET-ARN**.

1. Back in Lambda **psb-ingest-telemetry**, select **Configuration** > **Environment variables** > **Edit** and add these 4 variables. Replace **&lt;INFLUX-ENDPOINT&gt;** with your endpoint:

   | Key | Value |
   |---|---|
   | **INFLUX_URL** | **https://&lt;INFLUX-ENDPOINT&gt;:8086** |
   | **INFLUX_ORG** | **psb** |
   | **INFLUX_BUCKET** | **telemetry** |
   | **INFLUX_SECRET_ID** | **psb/influxdb/admin-token** |

   Click **Save**.

1. Select **Configuration** > **Permissions** and click the **Role name** link to open the execution role in IAM.

1. Select **Add permissions** > **Create inline policy** > **JSON**, and paste the policy below (also in **psb-lab-read-influx-token.json**). Replace **&lt;SECRET-ARN&gt;** with your secret ARN:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "AllowReadInfluxToken",
         "Effect": "Allow",
         "Action": "secretsmanager:GetSecretValue",
         "Resource": "<SECRET-ARN>"
       }
     ]
   }
   ```

   Click **Next**, name it **psb-lab-read-influx-token** and click **Create policy**.

1. Back in Lambda, open the **Test** tab, select **Create new event** and enter the event name **sample-reading**. Paste the content of **C:\psb-lab-assets\test-events\sample-reading.json**, for example:

   ```json
   {"device":"psb-lab-sensor-01","location":"north-lab","timestamp":1760520000000,
    "temperature_c":22.41,"humidity_pct":45.2,"co2_ppm":612.0,"vibration_g":0.021,"injected_anomaly":false}
   ```

1. Click **Save**, then **Test**. Confirm the result:

   ```json
   {"written": 1, "status": 204}
   ```

   **🛠️ Troubleshooting**

   | Symptom | Likely cause and fix |
   |---|---|
   | **403** | Wrong token or wrong secret content. Check the secret key is **token** and the value is a valid all-access token. |
   | **Timeout** | Port **8086** is not open in **psb-lab-influx-sg**, or the instance is not **Publicly accessible**. |
   | **404** | Bucket **telemetry** or org **psb** is wrong in the environment variables or on the instance. |

✅ **Expected result:** The test returns **written: 1** with status **204**.

---

## 🧩 Task 5: Create the IoT Rule and Verify Ingestion

🎯 **Goal:** Route every telemetry message to both the Lambda function and S3.

1. Open **IoT Core** > **Message routing** > **Rules** > **Create rule**.

1. On **Specify rule properties**, enter the rule name **psb_telemetry_rule** and click **Next**.

1. On **Configure SQL statement**, set **SQL version** to **2016-03-23** and paste the SQL statement:

   ```sql
   SELECT device, location, timestamp, temperature_c, humidity_pct, co2_ppm, vibration_g, injected_anomaly, timestamp() AS ingested_at FROM 'psb/lab/+/telemetry'
   ```

   Click **Next**.

   > ℹ️ **Info:** **injected_anomaly** is kept in the S3 raw data so the notebook in Lab 06 can measure precision and recall. The ingest Lambda does not write it to InfluxDB.

1. On **Attach rule actions**, configure **Action 1**:

   | Setting | Value |
   |---|---|
   | Action | **Lambda** (Send a message to a Lambda function) |
   | Lambda function | **psb-ingest-telemetry** |

1. Click **Add rule action** and configure **Action 2**:

   | Setting | Value |
   |---|---|
   | Action | **S3 bucket** (Store a message in an Amazon S3 bucket) |
   | S3 URI / bucket | **psb-lab-<inject key="DeploymentID" enableCopy="false"/>** |
   | Key | see below |
   | IAM role | **psb-lab-iot-rule-role** |

   Use this value for **Key**:

   ```text
   raw/${parse_time("yyyy/MM/dd/HH", timestamp())}/${newuuid()}.json
   ```

1. Click **Next**, review and click **Create**.

   > 💡 **Tip:** The console automatically adds a resource-based permission so IoT Core can invoke the Lambda function.

1. Make sure the simulator from Lab 01 is still running. Wait 1 to 2 minutes.

1. Open **CloudWatch** > **Log groups** > **/aws/lambda/psb-ingest-telemetry** (or Lambda **Monitor** > **View CloudWatch logs**) and open the latest log stream. Confirm lines like:

   ```text
   [ok] wrote 1 point (204)
   ```

1. Open **S3** > **psb-lab-<inject key="DeploymentID" enableCopy="false"/>** > **raw/** and confirm new JSON objects appear under the **yyyy/MM/dd/HH/** folders.

   ✅ **Expected result:** The rule **psb_telemetry_rule** is enabled, the ingest logs show **[ok] wrote 1 point (204)**, and raw JSON objects are arriving in S3.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="adb3daf1-20c5-45b3-87e6-b458a8052bb5" />

## 📝 Summary

In this lab, you:

- Created the Timestream for InfluxDB instance **psb-lab-influx** (org **psb**, bucket **telemetry**) and an all-access API token.
- Stored the token in Secrets Manager as **psb/influxdb/admin-token** and granted read access with a least-privilege inline policy.
- Built the **psb-ingest-telemetry** Lambda that converts JSON to InfluxDB line protocol.
- Created **psb_telemetry_rule** to fan out every message to InfluxDB (via Lambda) and the S3 **raw/** data lake.

Click **Next** to continue.
