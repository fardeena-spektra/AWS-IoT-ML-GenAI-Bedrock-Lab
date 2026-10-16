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
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 07: Serve Predictions and Close the Loop</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">50 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;12 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

A model in a notebook is an experiment. A model wired into the pipeline is a system.

In this lab you will build a scheduled Lambda function that pulls the most recent readings from Timestream for InfluxDB, sends them to your SageMaker serverless endpoint, and writes the resulting anomaly scores back into the same InfluxDB bucket as a new field. Your existing dashboard will then be able to plot them with no code change at all, because **anomaly_score** was already in the query Lambda's allow-list.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Lab Objectives

You will be able to complete the following tasks:

- Task 1: Build the scoring Lambda function
- Task 2: Schedule it with Amazon EventBridge
- Task 3: Verify the closed loop in the dashboard

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Build the Scoring Lambda Function

1. In the Lambda console, click **Create function**.

1. Configure:

   | Field | Value |
   |---|---|
   | Option | **Author from scratch** |
   | Function name | **psb-score-telemetry** |
   | Runtime | **Python 3.13** |
   | Architecture | **x86_64** |
   | Execution role | **Create a new role with basic Lambda permissions** |

   Click **Create function**.

1. Replace the contents of **lambda_function.py** with:

   ```python
   """
   PSB Academy CloudLab - scheduled anomaly scoring.

   Every 5 minutes:
     1. read the most recent readings from Timestream for InfluxDB
     2. score them against the SageMaker serverless endpoint
     3. write the anomaly_score back into the same InfluxDB bucket
     4. append the scored rows to s3://<bucket>/curated/scored/
   """
   import csv
   import io
   import json
   import os
   import time
   import urllib.request
   from collections import defaultdict

   import boto3

   INFLUX_URL = os.environ["INFLUX_URL"]
   INFLUX_ORG = os.environ["INFLUX_ORG"]
   INFLUX_BUCKET = os.environ["INFLUX_BUCKET"]
   SECRET_ID = os.environ["INFLUX_SECRET_ID"]
   ENDPOINT_NAME = os.environ["SAGEMAKER_ENDPOINT"]
   S3_BUCKET = os.environ["S3_BUCKET"]
   CUTOFF = float(os.environ.get("ANOMALY_CUTOFF", "1.5"))
   WINDOW_MINUTES = int(os.environ.get("WINDOW_MINUTES", "6"))

   FEATURES = ["temperature_c", "humidity_pct", "co2_ppm", "vibration_g"]

   _sm = boto3.client("secretsmanager")
   _runtime = boto3.client("sagemaker-runtime")
   _s3 = boto3.client("s3")
   _token_cache = None

   def _token():
       global _token_cache
       if _token_cache is None:
           secret = _sm.get_secret_value(SecretId=SECRET_ID)["SecretString"]
           _token_cache = json.loads(secret)["token"]
       return _token_cache

   def _parse_annotated_csv(body):
       """InfluxDB returns annotated CSV: skip #comment lines, take each
       table's own header row. See Lab 03 for the full explanation."""
       rows, header = [], None
       for line in body.splitlines():
           if not line.strip() or line.lstrip().startswith("#"):
               continue
           fields = next(csv.reader([line]))
           if "_time" in fields or "result" in fields:
               header = fields
               continue
           if header:
               rows.append(dict(zip(header, fields)))
       return rows

   def _influx(path, body, content_type, accept=None):
       headers = {"Authorization": f"Token {_token()}",
                  "Content-Type": content_type}
       if accept:
           headers["Accept"] = accept
       request = urllib.request.Request(
           url=f"{INFLUX_URL}{path}", data=body.encode("utf-8"),
           method="POST", headers=headers)
       with urllib.request.urlopen(request, timeout=15) as response:
           return response.read().decode("utf-8"), response.status

   def read_recent():
       """Pivot the last WINDOW_MINUTES of readings into feature rows."""
       flux = f'''
   from(bucket: "{INFLUX_BUCKET}")
     |> range(start: -{WINDOW_MINUTES}m)
     |> filter(fn: (r) => r["_measurement"] == "reading")
     |> filter(fn: (r) => contains(value: r["_field"],
                                   set: {json.dumps(FEATURES)}))
     |> pivot(rowKey: ["_time"], columnKey: ["_field"], valueColumn: "_value")
     |> keep(columns: ["_time", "device_id", "location"] + {json.dumps(FEATURES)})
     |> sort(columns: ["_time"])
   '''.strip()
       body, _ = _influx(f"/api/v2/query?org={INFLUX_ORG}", flux,
                         "application/vnd.flux", "application/csv")

       rows = []
       for row in _parse_annotated_csv(body):
           if not row.get("_time"):
               continue
           try:
               features = [float(row[f]) for f in FEATURES]
           except (KeyError, TypeError, ValueError):
               continue          # incomplete pivot row - skip it
           rows.append({
               "time": row["_time"],
               "device_id": row.get("device_id", "unknown"),
               "location": row.get("location", "unspecified"),
               "features": features,
           })
       return rows

   def score(rows):
       payload = "\n".join(",".join(f"{v:.6f}" for v in r["features"])
                           for r in rows)
       response = _runtime.invoke_endpoint(
           EndpointName=ENDPOINT_NAME,
           ContentType="text/csv",
           Accept="application/json",
           Body=payload.encode("utf-8"),
       )
       body = json.loads(response["Body"].read())
       return [float(s["score"]) for s in body["scores"]]

   def write_back(rows, scores):
       """One line-protocol point per reading, same tags, new field."""
       lines = []
       for row, value in zip(rows, scores):
           ts = int(time.mktime(time.strptime(
               row["time"][:19], "%Y-%m-%dT%H:%M:%S")))
           device = row["device_id"].replace(" ", "\\ ")
           location = row["location"].replace(" ", "\\ ")
           lines.append(
               f"reading,device_id={device},location={location} "
               f"anomaly_score={value:.6f} {ts}")
       body = "\n".join(lines)
       _, status = _influx(
           f"/api/v2/write?org={INFLUX_ORG}&bucket={INFLUX_BUCKET}&precision=s",
           body, "text/plain; charset=utf-8")
       return status

   def archive(rows, scores):
       buf = io.StringIO()
       writer = csv.writer(buf)
       writer.writerow(["time", "device_id", "location"] + FEATURES
                       + ["anomaly_score", "is_anomaly"])
       for row, value in zip(rows, scores):
           writer.writerow([row["time"], row["device_id"], row["location"]]
                           + [f"{v:.4f}" for v in row["features"]]
                           + [f"{value:.6f}", int(value > CUTOFF)])
       key = time.strftime("curated/scored/%Y/%m/%d/%H%M%S.csv", time.gmtime())
       _s3.put_object(Bucket=S3_BUCKET, Key=key,
                      Body=buf.getvalue().encode("utf-8"))
       return key

   def lambda_handler(event, context):
       rows = read_recent()
       if not rows:
           print("[skip] no complete readings in window")
           return {"scored": 0}

       scores = score(rows)
       status = write_back(rows, scores)
       key = archive(rows, scores)

       flagged = sum(1 for s in scores if s > CUTOFF)
       by_location = defaultdict(int)
       for row, value in zip(rows, scores):
           if value > CUTOFF:
               by_location[row["location"]] += 1

       print(f"[ok] scored={len(rows)} flagged={flagged} "
             f"influx={status} s3={key} by_location={dict(by_location)}")
       return {"scored": len(rows), "flagged": flagged, "archive": key}
   ```

1. Click **Deploy**.

1. Open **Configuration** → **General configuration** → **Edit**:

   | Field | Value |
   |---|---|
   | Memory | **512 MB** |
   | Timeout | **1 min 0 sec** |

   Click **Save**.

   > **Note:** The timeout is a minute rather than 30 seconds because a serverless SageMaker endpoint can take one to three seconds to cold-start, and this function makes three network calls in sequence.

1. Open **Configuration** → **Environment variables** → **Edit** and add:

   | Key | Value |
   |---|---|
   | INFLUX_URL | **https://&lt;INFLUX-ENDPOINT&gt;:8086** |
   | INFLUX_ORG | **psb** |
   | INFLUX_BUCKET | **telemetry** |
   | INFLUX_SECRET_ID | **psb/influxdb/admin-token** |
   | SAGEMAKER_ENDPOINT | **psb-anomaly-endpoint** |
   | S3_BUCKET | **psb-lab-<inject key="DeploymentID" enableCopy="false"/>** |
   | ANOMALY_CUTOFF | The value you copied from Lab 06 Cell 10 |
   | WINDOW_MINUTES | **6** |

   Click **Save**.

   > **Note:** **WINDOW_MINUTES** is 6 while the schedule is every 5 minutes. The one-minute overlap means a reading that arrives right on a boundary is scored rather than skipped. Writing the same point twice in InfluxDB is harmless: a point with the same measurement, tag set and timestamp is overwritten, not duplicated.

1. Open **Configuration** → **Permissions**, click the **Role name** link, and add an inline policy. Click **Add permissions** → **Create inline policy** → **JSON**, and paste the following, replacing the three placeholders (`<SECRET-ARN>`, `<AWS-ACCOUNT-ID>` with **<inject key="AWSAccountId" enableCopy="true"/>**, and `<S3-BUCKET>` with **<inject key="LabBucketName" enableCopy="true"/>**):

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
         "Resource": "arn:aws:sagemaker:ap-southeast-1:<AWS-ACCOUNT-ID>:endpoint/psb-anomaly-endpoint"
       },
       {
         "Sid": "AllowWriteCuratedScores",
         "Effect": "Allow",
         "Action": "s3:PutObject",
         "Resource": "arn:aws:s3:::<S3-BUCKET>/curated/*"
       }
     ]
   }
   ```

1. Click **Next**, name it **psb-lab-score-telemetry-policy**, and click **Create policy**.

1. Return to the function, open the **Test** tab, create a test event named **manual-run** with the body `{}`, and click **Test**.

1. Confirm the response looks like:

   ```json
   { "scored": 108, "flagged": 3, "archive": "curated/scored/2026/09/10/143005.csv" }
   ```

   > **Troubleshooting:** `"scored": 0` means the pivot returned no complete rows; check that your simulator is still publishing. A **ModelError** from SageMaker usually means the CSV column count does not match what the model was trained on; confirm **FEATURES** is the same four fields, in the same order, as Lab 06 Cell 3. An **AccessDeniedException** means the inline policy above was not saved.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Schedule It with Amazon EventBridge

1. Still on the **psb-score-telemetry** function page, select the **Configuration** tab and click **Triggers** in the left pane.

1. Click **Add trigger**.

1. From the source dropdown, select **EventBridge (CloudWatch Events)**.

1. Configure:

   | Field | Value |
   |---|---|
   | Rule | **Create a new rule** |
   | Rule name | **psb-lab-score-every-5-min** |
   | Rule description | **Score recent telemetry for anomalies** |
   | Rule type | **Schedule expression** |
   | Schedule expression | **rate(5 minutes)** |

1. Click **Add**.

1. Confirm the trigger appears with state **Enabled**.

1. Wait five minutes, then open the **Monitor** tab and click **View CloudWatch logs**.

1. Open the most recent log stream and confirm you see an **[ok] scored=... flagged=...** line from the scheduled invocation.

   > **Note:** `rate(5 minutes)` is a rate expression, the simplest form EventBridge offers. For anything time-of-day dependent you would use a `cron()` expression, which in EventBridge is evaluated in UTC, a frequent source of confusion for teams in UTC+8.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 3: Verify the Closed Loop in the Dashboard

1. Confirm the scores are reachable through your API. In PowerShell, using a fresh token if yours has expired:

   ```powershell
   curl.exe -H "Authorization: Bearer <ID-TOKEN>" "<INVOKE-URL>/anomalies?window_minutes=60"
   ```

1. You should receive a **summary** and **points** array for the **anomaly_score** metric.

   > **Note:** You did not change a single line of the query Lambda to make this work. **anomaly_score** was in **ALLOWED_METRICS** from the start, and the scoring function writes it into the same measurement with the same tags. That is the payoff of keeping one measurement with many fields rather than a separate table per signal.

1. Open your Amplify dashboard URL in a browser and sign in if prompted.

1. In the metric selector, choose **anomaly_score**.

1. Set the window to **6 hours**. You should see the score series, low most of the time with sharp peaks.

1. Switch back to **co2_ppm** over the same window and compare the two charts. The score peaks should line up with the CO₂ spikes.

1. Finally, confirm the S3 archive. In the S3 console, open your bucket and navigate to **curated/scored/**. You should see one CSV object every five minutes, in a date-partitioned path.

1. Download the most recent one and open it. Each row has the four features, the anomaly score, and a binary **is_anomaly** flag.

   > **Why archive to S3 as well as InfluxDB?** InfluxDB is your operational store: fast reads, short retention. S3 is your analytical store: cheap, durable, unlimited retention, and directly queryable by Amazon Athena or readable by the next model you train. Writing to both is the standard pattern, and it is what lets you retrain on six months of history later without keeping six months of hot time-series storage.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="288bdeee-f5bd-42b3-a40d-91bc17f3add8" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you have completed the following:

- Built a Lambda function that reads recent telemetry, scores it against a SageMaker serverless endpoint, and writes the results back.
- Scheduled it with Amazon EventBridge to run every five minutes.
- Verified the anomaly scores flow through the existing API and appear in the dashboard with no frontend change.
- Archived scored output to Amazon S3 for future retraining and analysis.

Phase II is complete. Your solution now detects anomalies continuously, not just in a notebook.

You have successfully completed the lab. Click **Next** to continue to the next lab.

</div>

</div>
