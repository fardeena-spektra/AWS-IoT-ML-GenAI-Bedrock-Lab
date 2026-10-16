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
@media (prefers-reduced-motion:reduce){.psbgs *,.psbgs *::before,.psbgs *::after{animation:none!important;transition:none!important}}
</style>

<div class="psbgs">

<div class="psb-hero" style="position:relative;overflow:hidden;border-radius:16px;padding:28px 20px 24px;margin:0 0 6px;text-align:center;color:#ffffff;background:linear-gradient(120deg,#070b1a,#121a3a,#0d2b36,#16123a);">
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 02: Rules Engine to InfluxDB and Amazon S3</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">65 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;16 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

Your sensor is now publishing to AWS IoT Core. In this lab, you route every message to two destinations with the **IoT Rules Engine**: a time-series database (**Amazon Timestream for InfluxDB**) for fast dashboards and queries, and an **Amazon S3** data lake for machine learning. A **Lambda** function converts each JSON message to InfluxDB line protocol, using an API token stored in **AWS Secrets Manager**.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Objectives

- **Task 1:** Create the InfluxDB instance **psb-lab-influx** and get its API token.
- **Task 2:** Prepare the S3 bucket folders and the IoT rule IAM role.
- **Task 3:** Create the ingest Lambda function **psb-ingest-telemetry**.
- **Task 4:** Store the token in Secrets Manager, configure and test the Lambda.
- **Task 5:** Create the IoT rule **psb_telemetry_rule** and verify end-to-end ingestion.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🏗️</span>What you build

```text
IoT Core topic psb/lab/+/telemetry ──> Rule psb_telemetry_rule ─┬─> Lambda psb-ingest-telemetry ──> InfluxDB psb-lab-influx (bucket telemetry)
                                                                └─> S3 psb-lab-<id>/raw/yyyy/MM/dd/HH/<uuid>.json
```

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Create the InfluxDB Instance

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

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Prepare the S3 Folders and the IoT Rule Role

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

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 3: Create the Ingest Lambda Function

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
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔄</span>Convert | Takes the rule payload (one JSON object) and builds InfluxDB **line protocol**: measurement **telemetry**, tags **device** and **location**, fields **temperature_c**, **humidity_pct**, **co2_ppm**, **vibration_g**, timestamp in **ms**. **injected_anomaly** is not written to InfluxDB. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📤</span>Write | Sends **POST /api/v2/write?org=psb&bucket=telemetry&precision=ms** with the header **Authorization: Token &lt;token&gt;**. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔐</span>Token cache | Reads the token from Secrets Manager once and caches it across warm invocations. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">❗</span>Errors | On an HTTP error it prints the status and body, then **re-raises** the error so failures are visible. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">✅</span>Success | Prints **[ok] wrote 1 point (204)** and returns **{"written":1,"status":204}**. |

1. Select **Configuration** > **General configuration** > **Edit** and set:

   | Setting | Value |
   |---|---|
   | Memory | **256 MB** |
   | Timeout | **0 min 15 sec** |

   Click **Save**.

✅ **Expected result:** **psb-ingest-telemetry** is deployed with Python 3.13, 256 MB and a 15 second timeout.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 4: Store the Token, Configure and Test the Lambda

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

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 5: Create the IoT Rule and Verify Ingestion

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

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you:

- Created the Timestream for InfluxDB instance **psb-lab-influx** (org **psb**, bucket **telemetry**) and an all-access API token.
- Stored the token in Secrets Manager as **psb/influxdb/admin-token** and granted read access with a least-privilege inline policy.
- Built the **psb-ingest-telemetry** Lambda that converts JSON to InfluxDB line protocol.
- Created **psb_telemetry_rule** to fan out every message to InfluxDB (via Lambda) and the S3 **raw/** data lake.

Click **Next** to continue.

</div>

</div>
