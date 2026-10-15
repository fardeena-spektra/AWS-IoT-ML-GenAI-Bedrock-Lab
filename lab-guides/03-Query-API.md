<h1 align="center">🔎 Lab 03: Query Lambda and HTTP API</h1>
<p align="center"><b>AWS Demo || Bedrock with Claude</b> | ⏱️ <b>Estimated Timing: 55 Minutes</b> | 🏆 <b>Points: 10</b></p>

---

## 🎯 Overview

Telemetry is now flowing into InfluxDB. In this lab, you build a read path: a **Lambda** function that runs safe, allow-listed **Flux** queries, exposed through an **Amazon API Gateway HTTP API**. The dashboard (Lab 05) and the Bedrock assistant (Lab 08) both use this API.

## 📋 Objectives

- **Task 1:** Create and test the query Lambda function **psb-query-telemetry**.
- **Task 2:** Create the HTTP API **psb-lab-api** with two routes and CORS.
- **Task 3:** Test the API from PowerShell and compare with the InfluxDB Data Explorer.

## 🏗️ What you build

```text
Client ──HTTPS──> API Gateway psb-lab-api ──(GET /telemetry, GET /anomalies)──> Lambda psb-query-telemetry ──Flux──> InfluxDB
```

---

## 🧩 Task 1: Create the Query Lambda Function

🎯 **Goal:** Create **psb-query-telemetry**, which returns time-bucketed statistics for one metric.

1. Open **Lambda** > **Functions** > **Create function** > **Author from scratch**:

   | Setting | Value |
   |---|---|
   | Function name | **psb-query-telemetry** |
   | Runtime | **Python 3.13** |
   | Architecture | **x86_64** |
   | Execution role | **Create a new role with basic Lambda permissions** |

   Click **Create function**.

1. Open **C:\psb-lab-assets\lambdas\psb-query-telemetry\lambda_function.py** in **VS Code**, copy all, paste it into the Lambda **Code** tab (replacing everything in **lambda_function.py**) and click **Deploy**.

   **What this code does:**

   | Step | Behaviour |
   |---|---|
   | 🧾 Inputs | **metric** (default **temperature_c**), **window_minutes** (1 to 1440, default **30**), **bucket_seconds** (default **60**) and optional **location**. |
   | 🛡️ Allow-lists | **metric** must be one of **temperature_c**, **humidity_pct**, **co2_ppm**, **vibration_g** (or **anomaly_score**), and **location** one of **north-lab**, **south-lab**, **server-room**. Anything else returns **400** with **{"error": ...}**. This prevents **Flux injection**, because user input is never pasted into the query unchecked. |
   | 📡 Query | Sends a Flux query to **POST /api/v2/query** with **Accept: application/csv** and parses the **annotated CSV** response. |
   | 🌐 API mode | For API Gateway HTTP API (payload **v2.0**) events with route **GET /telemetry** or **GET /anomalies**, it reads **queryStringParameters** and returns **{statusCode, headers, body}** with CORS **\*** and JSON content type. |
   | 🧪 Direct mode | When invoked directly (no **requestContext**), it returns the raw result dictionary. |
   | 📦 Response | **{"metric", "window_minutes", "bucket_seconds", "location", "points":[{"time","location","value"}], "summary":{"count","min","max","mean","latest"}}** |
   | 🚨 Anomalies | **GET /anomalies** returns **{"window_minutes", "points":[{"time","location","anomaly_score","flagged",...}], "flagged_count"}** from the **anomaly** measurement (filled in Lab 07). |

1. Select **Configuration** > **General configuration** > **Edit** and set:

   | Setting | Value |
   |---|---|
   | Memory | **256 MB** |
   | Timeout | **0 min 30 sec** |

   Click **Save**.

1. Select **Configuration** > **Environment variables** > **Edit** and add the same 4 variables as the ingest function:

   | Key | Value |
   |---|---|
   | **INFLUX_URL** | **https://&lt;INFLUX-ENDPOINT&gt;:8086** |
   | **INFLUX_ORG** | **psb** |
   | **INFLUX_BUCKET** | **telemetry** |
   | **INFLUX_SECRET_ID** | **psb/influxdb/admin-token** |

   Click **Save**.

1. Select **Configuration** > **Permissions**, click the **Role name** link, then **Add permissions** > **Create inline policy** > **JSON**. Paste the same policy as Lab 02 (replace **&lt;SECRET-ARN&gt;**):

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

1. Back in Lambda, open the **Test** tab, create a new event named **direct-query** with this content (also in **C:\psb-lab-assets\test-events\direct-query.json**):

   ```json
   {"metric":"temperature_c","window_minutes":30,"bucket_seconds":60}
   ```

1. Click **Save**, then **Test**. Confirm the response contains a **points** list and a **summary** with **count**, **min**, **max**, **mean** and **latest**.

✅ **Expected result:** The direct test returns temperature points from the last 30 minutes with a summary.

---

## 🧩 Task 2: Create the HTTP API

🎯 **Goal:** Expose the query Lambda over HTTPS with two routes.

1. Open **API Gateway** and click **Create API**. Under **HTTP API**, click **Build**.

1. On **Create and configure integrations**:

   | Setting | Value |
   |---|---|
   | Integrations | **Add integration** > **Lambda** |
   | AWS Region | **ap-southeast-1** |
   | Lambda function | **psb-query-telemetry** |
   | Version | **2.0** |
   | API name | **psb-lab-api** |

   Click **Next**.

1. On **Configure routes**, set the first route and add a second one with **Add route**:

   | Method | Resource path | Integration target |
   |---|---|---|
   | **GET** | **/telemetry** | **psb-query-telemetry** |
   | **GET** | **/anomalies** | **psb-query-telemetry** |

   Click **Next**.

1. On **Define stages**, keep the stage **$default** with **Auto-deploy** turned **on**. Click **Next**, review and click **Create**.

1. In the left menu, under **Develop**, select **CORS** and click **Configure**:

   | Setting | Value |
   |---|---|
   | Access-Control-Allow-Origin | **\*** |
   | Access-Control-Allow-Headers | **authorization**, **content-type** |
   | Access-Control-Allow-Methods | **GET**, **POST**, **OPTIONS** |
   | Access-Control-Max-Age | **300** |

   Click **Save**.

1. Select **API: psb-lab-api** at the top of the left menu (or **Deploy** > **Stages** > **$default**) and copy the **Invoke URL** into Notepad as **API-URL** (for example **https://abc123.execute-api.ap-southeast-1.amazonaws.com**, with no trailing slash).

✅ **Expected result:** **psb-lab-api** has routes **GET /telemetry** and **GET /anomalies**, the **$default** stage auto-deploys, and CORS is configured.

---

## 🧩 Task 3: Test the API

🎯 **Goal:** Call the API from the lab VM and confirm that input validation works.

1. Open **PowerShell** on the lab VM. Replace **&lt;API-URL&gt;** with your Invoke URL and run:

   ```powershell
   curl.exe "<API-URL>/telemetry?metric=temperature_c&window_minutes=30"
   ```

   Confirm the JSON response contains **points** and a **summary**.

1. Filter by metric and location:

   ```powershell
   curl.exe "<API-URL>/telemetry?metric=co2_ppm&window_minutes=60&location=north-lab"
   ```

   Confirm all returned points have **location** **north-lab**.

1. Try an invalid metric:

   ```powershell
   curl.exe "<API-URL>/telemetry?metric=DROP_TABLE"
   ```

   Confirm you receive a **400** response with an **error** message. The allow-list blocked the input.

   > 💡 **Tip:** Use **curl.exe** (not **curl**) in PowerShell, because **curl** is an alias for **Invoke-WebRequest**.

1. Compare with InfluxDB directly. Open the **InfluxDB UI**, sign in as **psbadmin**, select **Data Explorer**, switch to **Script Editor** and run:

   ```text
   from(bucket: "telemetry")
     |> range(start: -30m)
     |> filter(fn: (r) => r._measurement == "telemetry" and r._field == "temperature_c")
     |> aggregateWindow(every: 1m, fn: mean)
   ```

   Click **Submit** and confirm the chart matches the values returned by the API.

   ✅ **Expected result:** Valid requests return data, the invalid metric returns **400**, and the Flux query shows the same temperature trend.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="b3b85ffd-0738-464e-95e6-961cb0e28b22" />

## 📝 Summary

In this lab, you:

- Built **psb-query-telemetry**, a Lambda that runs allow-listed Flux queries and parses annotated CSV.
- Created the HTTP API **psb-lab-api** with **GET /telemetry** and **GET /anomalies** on the auto-deployed **$default** stage.
- Configured CORS for the dashboard.
- Tested valid and invalid requests and compared the results with the InfluxDB Data Explorer.

Click **Next** to continue.
