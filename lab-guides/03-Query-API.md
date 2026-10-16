<style>
@property --psbA{syntax:'<angle>';inherits:false;initial-value:0deg}
@keyframes psbSpin{to{--psbA:360deg}}
@keyframes psbAurora{0%{background-position:0% 50%}50%{background-position:100% 50%}100%{background-position:0% 50%}}
@keyframes psbSweep{0%{background-position:-150% 0}55%,100%{background-position:250% 0}}
@keyframes psbOrb{0%,100%{transform:translate(0,0) scale(1);opacity:.5}50%{transform:translate(40px,-16px) scale(1.18);opacity:.9}}
@keyframes psbDrop{0%{opacity:0;transform:translateY(-12px)}100%{opacity:1;transform:none}}
@keyframes psbRise{0%{opacity:0;transform:translateY(20px)}100%{opacity:1;transform:none}}
@keyframes psbLine{0%,100%{width:90px}50%{width:160px}}
@keyframes psbBar{0%{background-position:0% 0}100%{background-position:200% 0}}
@keyframes psbRGB{0%{box-shadow:0 0 0 2px rgba(255,59,59,.55),0 0 22px rgba(255,59,59,.45)}33%{box-shadow:0 0 0 2px rgba(46,204,113,.55),0 0 22px rgba(46,204,113,.45)}66%{box-shadow:0 0 0 2px rgba(59,130,246,.6),0 0 22px rgba(59,130,246,.5)}100%{box-shadow:0 0 0 2px rgba(255,59,59,.55),0 0 22px rgba(255,59,59,.45)}}
@keyframes psbBurst{0%{box-shadow:0 0 0 0 rgba(255,59,59,.8),0 0 0 0 rgba(46,204,113,.7),0 0 0 0 rgba(59,130,246,.7)}100%{box-shadow:0 0 0 10px rgba(255,59,59,0),0 0 0 18px rgba(46,204,113,0),0 0 0 26px rgba(59,130,246,0)}}
@keyframes psbHalo{0%,100%{box-shadow:0 0 0 0 rgba(233,185,73,0),0 0 10px rgba(233,185,73,.25)}50%{box-shadow:0 0 0 3px rgba(20,184,166,.15),0 0 22px rgba(20,184,166,.45)}}
@keyframes psbHit{0%{transform:scale(1)}35%{transform:scale(1.22)}70%{transform:scale(.95)}100%{transform:scale(1)}}
.psbgs{position:relative}
/* hero */
.psbgs .psb-hero{background-size:300% 300%!important;animation:psbAurora 14s ease infinite,psbDrop .6s ease-out both;box-shadow:0 12px 32px rgba(15,27,45,.30)}
.psbgs .psb-hero::before{content:"";position:absolute;width:300px;height:300px;left:-80px;top:-110px;border-radius:50%;background:radial-gradient(closest-side,rgba(233,185,73,.40),transparent);box-shadow:520px 160px 120px 40px rgba(20,184,166,.22);animation:psbOrb 10s ease-in-out infinite;pointer-events:none}
.psbgs .psb-hero::after{content:"";position:absolute;inset:0;background:linear-gradient(110deg,transparent 35%,rgba(255,255,255,.12) 50%,transparent 65%);background-size:250% 100%;animation:psbSweep 6s ease-in-out infinite;pointer-events:none}
.psbgs .psb-title{color:#ffffff!important;text-align:center!important}
.psbgs .psb-hero>div{position:relative;z-index:2}
.psbgs .psb-hero::before{z-index:0}
.psbgs .psb-hero::after{z-index:1}
.psbgs .psb-line{animation:psbLine 4s ease-in-out infinite}
.psbgs .psb-chip{transition:transform .2s ease;cursor:default}
.psbgs .psb-chip *{color:#ffffff!important;-webkit-text-fill-color:#ffffff!important}
.psbgs .psb-chip:hover{transform:translateY(-3px);animation:psbRGB 1.6s linear infinite}
.psbgs .psb-chip:active{animation:psbHit .3s ease,psbBurst .5s ease-out}
/* framed cards with a thick animated border */
.psbgs .psb-panel{position:relative;border:2px solid #1f2a4d!important;background:#ffffff!important;box-shadow:0 6px 18px rgba(11,16,32,.08);animation:psbRise .6s cubic-bezier(.2,.8,.2,1) both;transition:transform .25s ease,box-shadow .25s ease}
.psbgs .psb-panel:nth-of-type(2){animation-delay:.08s}.psbgs .psb-panel:nth-of-type(3){animation-delay:.16s}.psbgs .psb-panel:nth-of-type(4){animation-delay:.24s}
.psbgs .psb-panel:nth-of-type(5){animation-delay:.32s}.psbgs .psb-panel:nth-of-type(6){animation-delay:.4s}.psbgs .psb-panel:nth-of-type(7){animation-delay:.48s}
.psbgs .psb-panel:hover{transform:translateY(-2px);box-shadow:0 12px 28px rgba(11,16,32,.14)}
/* headings */
.psbgs h2{border:0!important;padding-bottom:12px!important;position:relative;color:#16191f!important;font-weight:700!important}
.psbgs h2::after{content:"";position:absolute;left:0;bottom:0;height:3px;width:100%;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6 55%,rgba(20,184,166,0))}
.psbgs h3{color:#1b1f3b!important;font-weight:700!important;margin-top:22px!important}
/* framed icons */
.psbgs .psb-ico{border:2px solid transparent!important;background:linear-gradient(#ffffff,#ffffff) padding-box,conic-gradient(from var(--psbA),#e9b949,#14b8a6,#3b2f8f,#22d3ee,#e9b949) border-box!important;animation:psbSpin 5s linear infinite,psbHalo 3.2s ease-in-out infinite;transition:transform .2s ease}
.psbgs .psb-ico:hover{transform:scale(1.15) rotate(-4deg);animation:psbSpin 1.2s linear infinite,psbRGB 1.2s linear infinite}
.psbgs .psb-ico:active{animation:psbHit .3s ease,psbBurst .5s ease-out}
/* tables */
.psbgs table{border-radius:10px;overflow:hidden;box-shadow:0 2px 10px rgba(15,27,45,.06)}
.psbgs th{color:#ffffff!important;background:#1b1f3b!important;border-color:#1b1f3b!important;border-bottom:2px solid #e9b949!important}
.psbgs tbody tr{transition:background .2s ease,box-shadow .2s ease}
.psbgs tbody tr:hover{background:#fbf6e6!important;box-shadow:inset 4px 0 0 #e9b949}
/* tips */
.psbgs blockquote{background:#effcfa!important;border-left:4px solid #14b8a6!important;border-radius:0 10px 10px 0;transition:transform .2s ease}
.psbgs blockquote:hover{transform:translateX(3px)}
/* screenshots: thick full animated frame, RGB glow on hover, burst on click */
.psbgs .psb-shot{position:relative;margin:16px 2px 22px;padding:4px;border-radius:14px;border:3px solid transparent;background:linear-gradient(#ffffff,#ffffff) padding-box,conic-gradient(from var(--psbA),#e9b949,#14b8a6 25%,#3b2f8f 50%,#22d3ee 75%,#e9b949) border-box;animation:psbSpin 7s linear infinite,psbHalo 4s ease-in-out infinite;transition:transform .25s ease}
.psbgs .psb-shot p{margin:0!important}
.psbgs .psb-shot img{display:block;max-width:100%;height:auto;margin:0 auto;border:0!important;border-radius:9px;box-shadow:none!important}
.psbgs .psb-shot:hover{transform:translateY(-2px);animation:psbSpin 2s linear infinite,psbRGB 1.8s linear infinite}
.psbgs .psb-shot:active{transform:scale(.99);animation:psbSpin 2s linear infinite,psbBurst .55s ease-out}
.psbgs pre{max-width:100%;overflow-x:auto}
.psbgs td,.psbgs th{overflow-wrap:anywhere}
/* links */
.psbgs a{color:#0f766e!important;font-weight:600;transition:color .2s ease}
.psbgs a:hover{color:#b7791f!important}
.psbgs a:active{display:inline-block;animation:psbHit .3s ease}
/* CloudLabs inject values and copy buttons */
.psbgs td [class]:not([class^=psb]):not(pre):not(code):not(pre *):not(code *):not(:has(pre)),.psbgs p [class]:not([class^=psb]):not(pre):not(code):not(pre *):not(code *):not(:has(pre)),.psbgs li [class]:not([class^=psb]):not(pre):not(code):not(pre *):not(code *):not(:has(pre)){color:#0f766e!important;-webkit-text-fill-color:#0f766e!important;font-weight:600}
/* code blocks: same width as the text around them, CloudLabs colours kept */
.psbgs li pre,.psbgs li *:has(pre){margin-left:0!important;margin-right:0!important;width:100%!important;max-width:100%!important;min-width:0!important;box-sizing:border-box!important}
.psbgs div:has(> pre){margin-left:0!important;margin-right:0!important}
.psbgs td img:not([class^=psb]),.psbgs td svg,.psbgs td i,.psbgs td button,.psbgs [class*=copy],.psbgs [class*=Copy],.psbgs [title*=opy]{cursor:pointer;border-radius:6px;transition:transform .15s ease}
.psbgs td img:not([class^=psb]):hover,.psbgs td svg:hover,.psbgs td i:hover,.psbgs td button:hover,.psbgs [class*=copy]:hover,.psbgs [class*=Copy]:hover,.psbgs [title*=opy]:hover{transform:scale(1.2);animation:psbRGB 1.2s linear infinite}
.psbgs td img:not([class^=psb]):active,.psbgs td svg:active,.psbgs td i:active,.psbgs td button:active,.psbgs [class*=copy]:active,.psbgs [class*=Copy]:active,.psbgs [title*=opy]:active{animation:psbHit .3s ease,psbBurst .5s ease-out}
/* compact, uniform spacing */
.psbgs p{margin:0 0 8px!important}
.psbgs ol,.psbgs ul{padding-left:1.35em!important;margin:4px 0 8px!important}
.psbgs li{margin:0 0 6px!important}
.psbgs li>p{margin:0 0 6px!important}
.psbgs li>*:last-child{margin-bottom:0!important}
.psbgs table{width:100%!important;margin:6px 0 10px!important}
.psbgs th,.psbgs td{padding:7px 10px!important}
.psbgs blockquote{margin:6px 0 10px!important;padding:8px 12px!important}
.psbgs blockquote p{margin:0!important}
.psbgs pre{margin:6px 0 10px!important}
.psbgs h2{margin:0 0 10px!important}
.psbgs h3{margin:14px 0 6px!important}
.psbgs h4{margin:12px 0 6px!important}
.psbgs .psb-panel>*:last-child{margin-bottom:0!important}
.psbgs .psb-panel{padding:14px 12px!important;margin:14px 0!important}
.psbgs .psb-shot{margin:6px 0 10px!important;padding:3px!important}
.psbgs .psb-ico{width:1.7em!important;height:1.7em!important;margin-right:6px!important}
@media (prefers-reduced-motion:reduce){.psbgs *,.psbgs *::before,.psbgs *::after{animation:none!important;transition:none!important}}
</style>

<div class="psbgs">

<div class="psb-hero" style="position:relative;overflow:hidden;border-radius:16px;padding:28px 20px 24px;margin:0 0 6px;text-align:center;color:#ffffff;background:linear-gradient(120deg,#070b1a,#121a3a,#0d2b36,#16123a);">
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 03: Query Lambda and HTTP API</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">55 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;10 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

Telemetry is now flowing into InfluxDB. In this lab, you build a read path: a **Lambda** function that runs safe, allow-listed **Flux** queries, exposed through an **Amazon API Gateway HTTP API**. The dashboard (Lab 05) and the Bedrock assistant (Lab 08) both use this API.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Objectives

- **Task 1:** Create and test the query Lambda function **psb-query-telemetry**.
- **Task 2:** Create the HTTP API **psb-lab-api** with two routes and CORS.
- **Task 3:** Test the API from PowerShell and compare with the InfluxDB Data Explorer.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🏗️</span>What you build

```text
Client ──HTTPS──> API Gateway psb-lab-api ──(GET /telemetry, GET /anomalies)──> Lambda psb-query-telemetry ──Flux──> InfluxDB
```

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Create the Query Lambda Function

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
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧾</span>Inputs | **metric** (default **temperature_c**), **window_minutes** (1 to 1440, default **30**), **bucket_seconds** (default **60**) and optional **location**. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🛡️</span>Allow-lists | **metric** must be one of **temperature_c**, **humidity_pct**, **co2_ppm**, **vibration_g** (or **anomaly_score**), and **location** one of **north-lab**, **south-lab**, **server-room**. Anything else returns **400** with **{"error": ...}**. This prevents **Flux injection**, because user input is never pasted into the query unchecked. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📡</span>Query | Sends a Flux query to **POST /api/v2/query** with **Accept: application/csv** and parses the **annotated CSV** response. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🌐</span>API mode | For API Gateway HTTP API (payload **v2.0**) events with route **GET /telemetry** or **GET /anomalies**, it reads **queryStringParameters** and returns **{statusCode, headers, body}** with CORS **\*** and JSON content type. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧪</span>Direct mode | When invoked directly (no **requestContext**), it returns the raw result dictionary. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📦</span>Response | **{"metric", "window_minutes", "bucket_seconds", "location", "points":[{"time","location","value"}], "summary":{"count","min","max","mean","latest"}}** |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🚨</span>Anomalies | **GET /anomalies** returns **{"window_minutes", "points":[{"time","location","anomaly_score","flagged",...}], "flagged_count"}** from the **anomaly** measurement (filled in Lab 07). |

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

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Create the HTTP API

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

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 3: Test the API

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

   <validation step="e3f71658-7f13-4f1f-b292-d0b6308aee2e" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you:

- Built **psb-query-telemetry**, a Lambda that runs allow-listed Flux queries and parses annotated CSV.
- Created the HTTP API **psb-lab-api** with **GET /telemetry** and **GET /anomalies** on the auto-deployed **$default** stage.
- Configured CORS for the dashboard.
- Tested valid and invalid requests and compared the results with the InfluxDB Data Explorer.

Click **Next** to continue.

</div>

</div>
