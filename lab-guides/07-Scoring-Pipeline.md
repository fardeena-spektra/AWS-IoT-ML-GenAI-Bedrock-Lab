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
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 07: Automated Scoring Pipeline</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">50 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;12 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

Your model is live behind a serverless endpoint. In this lab, you automate scoring: a Lambda function reads the latest telemetry from InfluxDB every 5 minutes, sends it to **psb-anomaly-endpoint**, writes anomaly scores back to InfluxDB and a CSV to S3. Your API and dashboard then show the **anomaly_score** metric.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Objectives

In this lab, you will complete the following tasks:

1. 🧮 **Task 1:** Create the psb-score-telemetry Lambda function.
1. ⏰ **Task 2:** Schedule it every 5 minutes with Amazon EventBridge.
1. 🔍 **Task 3:** Verify anomalies in the API, the dashboard and S3.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🏗️</span>What you build

```text
EventBridge rate(5 minutes) ──► psb-score-telemetry
                                  ├─► InfluxDB (read last 6 min of telemetry)
                                  ├─► SageMaker psb-anomaly-endpoint (text/csv)
                                  ├─► InfluxDB measurement "anomaly" (anomaly_score, flagged)
                                  └─► S3 curated/scored/YYYY/MM/DD/HHMMSS.csv
```

> ⚠️ **Note:** Have your **ANOMALY_CUTOFF** value from Lab 06 and the InfluxDB endpoint and secret ARN from Lab 02 ready.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Create the psb-score-telemetry Lambda Function

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

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Schedule It Every 5 Minutes with Amazon EventBridge

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

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 3: Verify Anomalies in the API, the Dashboard and S3

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

   <validation step="288bdeee-f5bd-42b3-a40d-91bc17f3add8" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you:

- Created **psb-score-telemetry** (Python 3.13, 512 MB, 1 minute) with 8 environment variables.
- Granted least-privilege access with **psb-lab-score-telemetry-policy** (secret, endpoint, curated/*).
- Scheduled it with the EventBridge rule **psb-lab-score-every-5-min** (rate(5 minutes)).
- Verified anomaly scores through **GET /anomalies**, the dashboard and **curated/scored/** CSV files.

Click **Next** to continue.

</div>

</div>
