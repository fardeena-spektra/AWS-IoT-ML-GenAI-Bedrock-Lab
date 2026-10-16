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
/* v7: vibrant highlights instead of plain bold, icons sized to the text, tight spacing */
.psbgs strong,.psbgs b{color:#0e7490!important;font-weight:600!important}
.psbgs th strong,.psbgs th b,.psbgs .psb-hero b{color:inherit!important}
.psbgs h1 strong,.psbgs h2 strong,.psbgs h3 strong{color:inherit!important}
.psbgs .psb-ico{width:1.3em!important;height:1.3em!important;margin-right:.35em!important;vertical-align:-0.22em!important;border-radius:7px!important;font-size:1em!important;line-height:1!important}
.psbgs .psb-ico img{width:.95em!important;height:.95em!important}
.psbgs h2 .psb-ico,.psbgs h3 .psb-ico{font-size:1em!important}
.psbgs td .psb-ico{font-size:.95em!important}
.psbgs .psb-panel{padding:10px 10px!important;margin:10px 0!important}
.psbgs ol{padding-left:1.75em!important;margin:2px 0 6px!important}
.psbgs ul{padding-left:1.15em!important;margin:2px 0 6px!important}
.psbgs img{max-width:100%!important;height:auto!important}
.psbgs li{margin:0 0 4px!important;padding-left:0!important}
.psbgs li>p,.psbgs p{margin:0 0 6px!important}
.psbgs table{display:table!important;width:100%!important;max-width:100%!important;margin:4px 0 8px!important}
.psbgs th,.psbgs td{padding:6px 8px!important}
.psbgs blockquote{margin:4px 0 8px!important;padding:6px 10px!important}
.psbgs pre{margin:4px 0 8px!important}
.psbgs .psb-shot{margin:4px 0 8px!important;padding:2px!important}
.psbgs h2{margin:0 0 8px!important;padding-bottom:8px!important}
.psbgs h3{margin:10px 0 4px!important}
@media (prefers-reduced-motion:reduce){.psbgs *,.psbgs *::before,.psbgs *::after{animation:none!important;transition:none!important}}
</style>

<div class="psbgs">

<div class="psb-hero" style="position:relative;overflow:hidden;border-radius:16px;padding:28px 20px 24px;margin:0 0 6px;text-align:center;color:#ffffff;background:linear-gradient(120deg,#070b1a,#121a3a,#0d2b36,#16123a);">
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 02: Route Telemetry with the IoT Rules Engine to Timestream for InfluxDB and Amazon S3</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">65 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;16 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

Your device is publishing, but the messages currently go nowhere: the MQTT broker delivers them to whoever is subscribed and then forgets them. In this lab you will make them durable and queryable.

You will provision Amazon Timestream for InfluxDB, a managed InfluxDB 2.7 instance purpose-built for time-series data. You will store its admin token in AWS Secrets Manager. You will write an AWS Lambda function that converts your JSON payload into InfluxDB line protocol and writes it over the HTTP write API. Then you will create a single AWS IoT rule that fans every inbound message out to two actions: the Lambda function, and a direct write to Amazon S3 that builds your machine-learning training corpus.

> **Important: start Task 1 immediately.** Provisioning a Timestream for InfluxDB instance takes 15 to 20 minutes. Task 1 starts it; Tasks 2 and 3 give you productive work to do while it builds. Do not wait and watch it.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Lab Objectives

You will be able to complete the following tasks:

- Task 1: Provision the Timestream for InfluxDB instance
- Task 2: Create the S3 prefixes and the IoT rule's IAM role
- Task 3: Build the ingestion Lambda function
- Task 4: Store the InfluxDB token in AWS Secrets Manager and wire up the Lambda
- Task 5: Create the IoT rule with two actions and verify the data path

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Provision the Timestream for InfluxDB Instance

1. In the AWS Management Console search bar, type **Timestream** and select **Amazon Timestream**.

1. In the left-hand navigation pane, under **InfluxDB databases**, click **InfluxDB instances**.

1. Click **Create Influx database**.

1. Under **DB instance identifier**, enter:

   - **DB instance identifier:** **psb-lab-influx**

1. Under **Credential settings**, provide the following. Write these down now: the admin token is displayed only once, when the instance finishes creating.

   | Field | Value |
   |---|---|
   | Username | **psbadmin** |
   | Password | **PsbLab#2026!Influx** |
   | Organization | **psb** |
   | Bucket | **telemetry** |

1. Under **Instance configuration**, select:

   | Field | Value |
   |---|---|
   | DB instance class | **Burstable classes** → **db.influx.medium** |
   | Deployment option | **Single-AZ** |

   > **Note:** **db.influx.medium** (2 vCPU, 8 GiB) is more than sufficient for a lab publishing one reading every ten seconds. Single-AZ halves the cost and is appropriate for non-production. A production deployment would use Multi-AZ.

1. Under **Storage**, select:

   | Field | Value |
   |---|---|
   | Storage type | **Influx IO Included 3000 IOPS** |
   | Allocated storage | **20 GiB** |

1. Under **Connectivity**:

   | Field | Value |
   |---|---|
   | Virtual private cloud (VPC) | Select the **default** VPC |
   | DB subnet group | Leave as default |
   | Public access | **Publicly accessible** |
   | VPC security group | **Create new** → name it **psb-lab-influx-sg** |
   | Network type | **IPv4** |
   | Port | **8086** |

   > **Important: why public access, and what you would do in production.** Selecting **Publicly accessible** lets your Lambda function reach the database without being attached to a VPC, which removes about fifteen minutes of VPC, subnet and NAT-gateway configuration from this lab. In production you would make the instance private, place the Lambda inside the VPC, and reach the database through a security group rule rather than the internet. Lab 09 revisits this.

1. Under **Additional configuration**, expand the section and confirm:

   | Field | Value |
   |---|---|
   | Log delivery | Leave unchecked |
   | Deletion protection | **Disabled** |

   > **Note:** Deletion protection must be disabled so the lab teardown can remove the instance. An instance left running is the single largest source of unexpected cost in this lab.

1. Click **Create Influx database**.

1. The instance status will show **Creating**. Do not wait here. Leave this browser tab open and move on to Task 2. You will come back in Task 4.

   > **Note:** The InfluxDB instance is checked by the validation at the end of the lab, once it has finished provisioning.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Create the S3 Prefixes and the IoT Rule's IAM Role

While the database provisions, you will prepare the second destination for your telemetry: an Amazon S3 bucket that will become your machine-learning training corpus.

1. In the AWS Management Console search bar, type **S3** and select **S3**.

1. In the bucket list, click your lab bucket **psb-lab-<inject key="DeploymentID" enableCopy="false"/>**.

   > **Note:** This bucket was created for you by the lab deployment. Its exact name is on the **Environment** tab.

1. Click **Create folder**. For **Folder name**, enter **raw** and click **Create folder**.

1. Repeat step 3 twice more to create folders named **curated** and **model**.

   Your bucket should now contain three prefixes:

   | Prefix | Purpose |
   |---|---|
   | raw/ | Every telemetry message, exactly as published. Your ML training corpus. |
   | curated/ | Anomaly scores written back by Phase II. |
   | model/ | SageMaker training artifacts. |

1. Now create the IAM role that the IoT rule will assume to write to S3. In the console search bar, type **IAM** and select **IAM**.

1. In the left-hand navigation pane, click **Roles**, then click **Create role**.

1. On the **Select trusted entity** page:

   | Field | Value |
   |---|---|
   | Trusted entity type | **AWS service** |
   | Service or use case | **IoT** |
   | Use case | **IoT** |

   Click **Next**.

1. On the **Add permissions** page, the AWS-managed IoT policies are pre-selected. Clear every checkbox; you will attach a least-privilege inline policy instead. Click **Next**.

1. For **Role name**, enter the following, then click **Create role**:

   - **Role name:** **psb-lab-iot-rule-role**

1. In the role list, click **psb-lab-iot-rule-role**.

1. On the **Permissions** tab, click **Add permissions** and select **Create inline policy**.

1. Click the **JSON** tab and replace the editor contents with the following. Replace `<S3-BUCKET>` with your bucket name, **<inject key="LabBucketName" enableCopy="true"/>**:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "AllowRuleToLandRawTelemetry",
         "Effect": "Allow",
         "Action": "s3:PutObject",
         "Resource": "arn:aws:s3:::<S3-BUCKET>/raw/*"
       }
     ]
   }
   ```

   > **Note:** The rule needs `s3:PutObject` on the `raw/` prefix and nothing else. It cannot read, cannot delete, and cannot touch `curated/` or `model/`.

1. Click **Next**. For **Policy name**, enter **psb-lab-iot-rule-s3-write** and click **Create policy**.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 3: Build the Ingestion Lambda Function

The AWS IoT Rules Engine has native actions for many AWS services, but not for Timestream for InfluxDB. In this task you will write the small adapter that bridges the gap: a Lambda function that converts JSON to InfluxDB line protocol and writes it over the HTTP API. This adapter pattern is how you connect the Rules Engine to any destination it does not natively support.

1. In the AWS Management Console search bar, type **Lambda** and select **Lambda**.

1. Click **Create function**.

1. On the **Create function** page:

   | Field | Value |
   |---|---|
   | Option | **Author from scratch** |
   | Function name | **psb-ingest-telemetry** |
   | Runtime | **Python 3.13** |
   | Architecture | **x86_64** |

1. Expand **Change default execution role**, select **Create a new role with basic Lambda permissions**, and click **Create function**.

1. On the function page, scroll to the **Code source** editor. Delete everything in **lambda_function.py** and paste the following:

   ```python
   """
   PSB Academy CloudLab - IoT telemetry ingestion.

   Invoked by the AWS IoT rule `psb_telemetry_rule` for every inbound
   MQTT message. Converts the JSON payload into InfluxDB line protocol
   and writes it to Amazon Timestream for InfluxDB.
   """
   import json
   import os
   import time
   import urllib.error
   import urllib.request

   import boto3

   INFLUX_URL = os.environ["INFLUX_URL"]          # https://<endpoint>:8086
   INFLUX_ORG = os.environ["INFLUX_ORG"]          # psb
   INFLUX_BUCKET = os.environ["INFLUX_BUCKET"]    # telemetry
   SECRET_ID = os.environ["INFLUX_SECRET_ID"]     # psb/influxdb/admin-token

   FIELDS = ("temperature_c", "humidity_pct", "co2_ppm", "vibration_g")

   _sm = boto3.client("secretsmanager")
   _token_cache = None

   def _token():
       """Fetch the InfluxDB token once per execution environment."""
       global _token_cache
       if _token_cache is None:
           secret = _sm.get_secret_value(SecretId=SECRET_ID)["SecretString"]
           _token_cache = json.loads(secret)["token"]
       return _token_cache

   def _escape_tag(value):
       """Line protocol tag values escape spaces, commas and equals signs."""
       return (str(value).replace("\\", "\\\\")
                         .replace(" ", "\\ ")
                         .replace(",", "\\,")
                         .replace("=", "\\="))

   def _to_line_protocol(msg):
       """
       reading,device_id=psb-lab-sensor-01,location=north-lab
               temperature_c=22.84,humidity_pct=53.11 1789012345
       """
       tags = [
           f"device_id={_escape_tag(msg.get('device_id', 'unknown'))}",
           f"location={_escape_tag(msg.get('location', 'unspecified'))}",
       ]
       fields = []
       for name in FIELDS:
           value = msg.get(name)
           if value is not None:
               fields.append(f"{name}={float(value)}")
       if not fields:
           return None
       ts = int(msg.get("ts") or time.time())
       return f"reading,{','.join(tags)} {','.join(fields)} {ts}"

   def lambda_handler(event, context):
       line = _to_line_protocol(event)
       if line is None:
           print(f"[skip] no numeric fields in payload: {json.dumps(event)[:200]}")
           return {"written": 0, "reason": "no-fields"}

       url = (f"{INFLUX_URL}/api/v2/write"
              f"?org={INFLUX_ORG}&bucket={INFLUX_BUCKET}&precision=s")
       request = urllib.request.Request(
           url=url,
           data=line.encode("utf-8"),
           method="POST",
           headers={
               "Authorization": f"Token {_token()}",
               "Content-Type": "text/plain; charset=utf-8",
           },
       )
       try:
           with urllib.request.urlopen(request, timeout=8) as response:
               status = response.status
       except urllib.error.HTTPError as err:
           body = err.read().decode("utf-8", "replace")[:300]
           print(f"[error] InfluxDB returned {err.code}: {body}")
           raise

       print(f"[ok] wrote 1 point ({status}): {line}")
       return {"written": 1, "status": status}
   ```

   Read the three points that matter:

   - `_to_line_protocol` builds the InfluxDB write format: `measurement,tag=value field=value timestamp`. Tags are indexed and used for filtering; fields hold the numeric values. Putting `device_id` and `location` in tags is what makes `WHERE location = 'north-lab'` fast later.
   - `_token_cache` is a module-level global. Lambda reuses the execution environment between invocations, so the Secrets Manager call happens once per cold start rather than on every message. At 8,640 messages a day that is the difference between $0.04 and negligible.
   - `raise` on an HTTP error is deliberate. Letting the function fail tells the IoT rule the action failed, which surfaces in CloudWatch instead of silently dropping data.

1. Click **Deploy**.

1. Now increase the timeout. Open the **Configuration** tab, select **General configuration** in the left pane, and click **Edit**.

1. Set the following, then click **Save**:

   | Field | Value |
   |---|---|
   | Memory | **256 MB** |
   | Timeout | **0 min 15 sec** |

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 4: Store the InfluxDB Token in AWS Secrets Manager and Wire Up the Lambda

1. Return to the browser tab showing **Amazon Timestream** → **InfluxDB instances**. Refresh the page.

1. Wait until **psb-lab-influx** shows a status of **Available**. If it still shows **Creating**, wait a few more minutes.

1. Click **psb-lab-influx**.

1. A banner at the top of the page displays the InfluxDB admin token, which begins with a long random string. Copy it now and paste it into a notepad. This banner appears only once; if you navigate away without copying it you will have to delete and recreate the instance.

1. On the same page, under **Connectivity & security**, copy the **Endpoint** value. It looks like:

   ```text
   psb-lab-influx-a1b2c3.timestream-influxdb.ap-southeast-1.on.aws
   ```

   Paste it into your notepad as well.

1. Now store the token securely. In the AWS Management Console search bar, type **Secrets Manager** and select **AWS Secrets Manager**.

1. Click **Store a new secret**.

1. On the **Choose secret type** page, select **Other type of secret**.

1. Under **Key/value pairs**, click the **Plaintext** tab and replace the contents with the following, pasting your token in place of `<INFLUX-ADMIN-TOKEN>`:

   ```json
   { "token": "<INFLUX-ADMIN-TOKEN>" }
   ```

1. Leave the encryption key as **aws/secretsmanager** and click **Next**.

1. For **Secret name**, enter the following, then click **Next**:

   - **Secret name:** **psb/influxdb/admin-token**

1. On the **Configure rotation** page, leave automatic rotation disabled and click **Next**.

1. Review and click **Store**.

1. Click the secret **psb/influxdb/admin-token** and copy its **Secret ARN** into your notepad.

1. Return to the Lambda console and open **psb-ingest-telemetry**.

1. Open the **Configuration** tab and select **Environment variables** in the left pane. Click **Edit**, then **Add environment variable** four times and enter:

   | Key | Value |
   |---|---|
   | INFLUX_URL | **https://&lt;INFLUX-ENDPOINT&gt;:8086** |
   | INFLUX_ORG | **psb** |
   | INFLUX_BUCKET | **telemetry** |
   | INFLUX_SECRET_ID | **psb/influxdb/admin-token** |

   > **Note:** **INFLUX_URL** must include the `https://` scheme and the `:8086` port, with no trailing slash.

1. Click **Save**.

1. Now grant the function permission to read the secret. Still on the **Configuration** tab, select **Permissions** in the left pane and click the **Role name** link; it opens the execution role in IAM.

1. On the role page, click **Add permissions** → **Create inline policy**.

1. Click the **JSON** tab and replace the contents with the following. Replace `<SECRET-ARN>` with the ARN you copied in step 14:

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

1. Click **Next**, name the policy **psb-lab-read-influx-token**, and click **Create policy**.

1. Return to the **psb-ingest-telemetry** function and open the **Test** tab.

1. Create a new test event:

   | Field | Value |
   |---|---|
   | Event name | **sample-reading** |

   Replace the event JSON with:

   ```json
   {
     "device_id": "psb-lab-sensor-01",
     "location": "north-lab",
     "ts": 1789012345,
     "temperature_c": 22.84,
     "humidity_pct": 53.11,
     "co2_ppm": 531.2,
     "vibration_g": 0.0213
   }
   ```

1. Click **Save**, then click **Test**.

1. Confirm the execution result is **succeeded** and that the response body reads:

   ```json
   { "written": 1, "status": 204 }
   ```

   > **Troubleshooting:** A **403** from InfluxDB means the token is wrong; recheck the secret's plaintext. A timeout means the security group is not allowing inbound traffic on port 8086; open the security group **psb-lab-influx-sg** in the EC2 console and confirm it has an inbound rule for TCP 8086 from 0.0.0.0/0. A **404** usually means the bucket name in **INFLUX_BUCKET** does not match the bucket you created in Task 1.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 5: Create the IoT Rule with Two Actions and Verify the Data Path

In this task you will create a single rule that fans every inbound message out to two destinations. This is the pattern that lets one telemetry stream serve both an operational dashboard and a machine-learning corpus without the device knowing or caring.

1. Return to the AWS IoT Core console. In the left-hand navigation pane, expand **Message routing** and click **Rules**.

1. Click **Create rule**.

1. On the **Specify rule properties** page:

   | Field | Value |
   |---|---|
   | Rule name | **psb_telemetry_rule** |
   | Description | **Fan telemetry out to Timestream for InfluxDB and Amazon S3** |

   Click **Next**.

   > **Note:** IoT rule names permit letters, numbers and underscores, but not hyphens. This is why the rule uses underscores while everything else in the lab uses hyphens.

1. On the **Configure SQL statement** page, set **SQL version** to **2016-03-23** and replace the SQL statement with:

   ```sql
   SELECT
     device_id,
     location,
     ts,
     temperature_c,
     humidity_pct,
     co2_ppm,
     vibration_g,
     timestamp() AS ingested_at
   FROM 'psb/lab/+/telemetry'
   ```

   Click **Next**.

   > **Note:** Two things are happening here. The `+` wildcard in the FROM clause means this one rule serves an entire fleet, not just your single device. And `timestamp() AS ingested_at` adds a server-side ingestion timestamp, useful for measuring device clock drift, and a good habit in any IoT pipeline. Notice that `injected_anomaly` is not selected: it is deliberately dropped so it never reaches your training data.

1. On the **Attach rule actions** page, under **Rule actions**, for **Action 1** select **Lambda** from the dropdown.

1. Under **Lambda function**, select **psb-ingest-telemetry**.

1. Click **Add rule action** to add a second action.

1. For **Action 2**, select **S3** from the dropdown.

1. Configure the S3 action:

   | Field | Value |
   |---|---|
   | S3 bucket | Click **Browse S3** and select **psb-lab-<inject key="DeploymentID" enableCopy="false"/>** |
   | Key | **raw/${parse_time("yyyy/MM/dd/HH", timestamp())}/${newuuid()}.json** |
   | Canned ACL | Leave as **None** |

   > **Note:** The key expression uses two IoT SQL functions. `parse_time` formats the ingestion timestamp into a Hive-style date partition, which lets SageMaker and Athena prune by date later. `newuuid()` guarantees a unique object name so concurrent messages never overwrite one another. Getting this key design right at ingestion time is far cheaper than reorganising a bucket with millions of objects later.

1. Under **IAM role**, click **Select** and choose **psb-lab-iot-rule-role**.

1. Click **Next**, review the configuration, and click **Create**.

1. Confirm that **psb_telemetry_rule** appears in the rules list with status **Enabled**.

1. Now verify the whole path. Your simulator should still be running in the first PowerShell window. Wait two minutes, then return to the S3 console.

1. Open your bucket and navigate into **raw/**. You should see a date-partitioned folder structure such as **raw/2026/09/10/14/**, containing one JSON object per telemetry message.

1. Click into the newest folder and open one of the objects. Click **Open** to view it. Confirm it contains your telemetry fields plus the **ingested_at** value the rule added.

1. Finally, verify the InfluxDB write path. Return to the Lambda console, open **psb-ingest-telemetry**, and select the **Monitor** tab.

1. Click **View CloudWatch logs**. Open the most recent log stream.

1. Confirm you see repeated **[ok] wrote 1 point (204)** entries, one per telemetry message.

   > **Troubleshooting:** If the log group is empty, the rule's Lambda action is not firing; check that the rule is **Enabled** and that the SQL FROM clause exactly matches your topic. If you see errors, they are the same three causes listed in Task 4 step 25.

1. Your Timestream for InfluxDB instance has had time to finish provisioning, so validate the lab now.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="adb3daf1-20c5-45b3-87e6-b458a8052bb5" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you have completed the following:

- Provisioned an Amazon Timestream for InfluxDB instance and stored its admin token in AWS Secrets Manager.
- Built an AWS Lambda function that converts JSON telemetry into InfluxDB line protocol and writes it over the HTTP API.
- Created three S3 prefixes and a least-privilege IAM role for the IoT rule.
- Created a single AWS IoT rule that fans every message out to two actions, and verified that data is landing in both destinations.

You have successfully completed the lab. Click **Next** to continue to the next lab.

</div>

</div>
