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
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 03: Build the Serverless Data API with AWS Lambda and Amazon API Gateway</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">55 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;10 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

Your telemetry is now durable and queryable, but only from inside AWS, with an admin token. A web dashboard cannot and must not hold that token. In this lab you will put a proper API in front of the data.

You will write a query Lambda function that runs a Flux query against Timestream for InfluxDB and returns a clean JSON time series. You will front it with an Amazon API Gateway HTTP API, and you will test it end to end. In Lab 04 you will lock it down with Amazon Cognito; in Lab 05 a React dashboard will consume it; and in Lab 08 your generative-AI assistant will call this very same function as a tool.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Lab Objectives

You will be able to complete the following tasks:

- Task 1: Build the query Lambda function
- Task 2: Create the API Gateway HTTP API and routes
- Task 3: Test the API and inspect the Flux query

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Build the Query Lambda Function

1. In the AWS Management Console search bar, type **Lambda** and select **Lambda**.

1. Click **Create function**.

1. On the **Create function** page:

   | Field | Value |
   |---|---|
   | Option | **Author from scratch** |
   | Function name | **psb-query-telemetry** |
   | Runtime | **Python 3.13** |
   | Architecture | **x86_64** |

1. Expand **Change default execution role**, select **Create a new role with basic Lambda permissions**, and click **Create function**.

1. In the **Code source** editor, replace the contents of **lambda_function.py** with the following:

   ```python
   """
   PSB Academy CloudLab - telemetry query API.

   Two responsibilities:
     * HTTP entry point behind API Gateway  (GET /telemetry, GET /anomalies)
     * Direct invocation as a tool by the Bedrock assistant (Lab 08)
   """
   import csv
   import io
   import json
   import os
   import urllib.parse
   import urllib.request

   import boto3

   INFLUX_URL = os.environ["INFLUX_URL"]
   INFLUX_ORG = os.environ["INFLUX_ORG"]
   INFLUX_BUCKET = os.environ["INFLUX_BUCKET"]
   SECRET_ID = os.environ["INFLUX_SECRET_ID"]

   ALLOWED_METRICS = {
       "temperature_c", "humidity_pct", "co2_ppm",
       "vibration_g", "anomaly_score",
   }
   ALLOWED_LOCATIONS = {"north-lab", "south-lab", "server-room"}

   _sm = boto3.client("secretsmanager")
   _token_cache = None

   def _token():
       global _token_cache
       if _token_cache is None:
           secret = _sm.get_secret_value(SecretId=SECRET_ID)["SecretString"]
           _token_cache = json.loads(secret)["token"]
       return _token_cache

   def _flux(metric, minutes, every, location):
       """Build a Flux query. Inputs are allow-listed by the caller."""
       location_filter = ""
       if location:
           location_filter = (
               f'\n  |> filter(fn: (r) => r["location"] == "{location}")'
           )
       return f'''
   from(bucket: "{INFLUX_BUCKET}")
     |> range(start: -{minutes}m)
     |> filter(fn: (r) => r["_measurement"] == "reading")
     |> filter(fn: (r) => r["_field"] == "{metric}"){location_filter}
     |> aggregateWindow(every: {every}, fn: mean, createEmpty: false)
     |> keep(columns: ["_time", "_value", "location"])
     |> sort(columns: ["_time"])
   '''.strip()

   def _parse_annotated_csv(body):
       """
       InfluxDB /api/v2/query returns ANNOTATED CSV: each result table is
       preceded by #datatype / #group / #default comment lines and its own
       header row. A plain csv.DictReader would read the first comment line
       as the header and silently return nothing, so parse it explicitly.
       """
       rows, header = [], None
       for line in body.splitlines():
           if not line.strip() or line.lstrip().startswith("#"):
               continue                       # annotation or blank line
           fields = next(csv.reader([line]))
           if "_time" in fields or "result" in fields:
               header = fields                # a new table's header row
               continue
           if header:
               rows.append(dict(zip(header, fields)))
       return rows

   def _run_flux(query):
       url = f"{INFLUX_URL}/api/v2/query?org={urllib.parse.quote(INFLUX_ORG)}"
       request = urllib.request.Request(
           url=url,
           data=query.encode("utf-8"),
           method="POST",
           headers={
               "Authorization": f"Token {_token()}",
               "Content-Type": "application/vnd.flux",
               "Accept": "application/csv",
           },
       )
       with urllib.request.urlopen(request, timeout=12) as response:
           body = response.read().decode("utf-8")

       points = []
       for row in _parse_annotated_csv(body):
           if not row.get("_time"):
               continue
           try:
               value = float(row["_value"])
           except (TypeError, ValueError):
               continue
           points.append({
               "time": row["_time"],
               "location": row.get("location") or "all",
               "value": round(value, 4),
           })
       return points

   def query_metric(metric="temperature_c", window_minutes=60,
                    location=None, bucket_seconds=60):
       """Core logic. Called by the HTTP handler and by the Lab 08 tool."""
       if metric not in ALLOWED_METRICS:
           raise ValueError(
               f"metric must be one of {sorted(ALLOWED_METRICS)}")
       if location and location not in ALLOWED_LOCATIONS:
           raise ValueError(
               f"location must be one of {sorted(ALLOWED_LOCATIONS)}")
       window_minutes = max(1, min(int(window_minutes), 1440))
       bucket_seconds = max(10, min(int(bucket_seconds), 3600))

       points = _run_flux(
           _flux(metric, window_minutes, f"{bucket_seconds}s", location))
       values = [p["value"] for p in points]
       summary = {
           "metric": metric,
           "location": location or "all",
           "window_minutes": window_minutes,
           "point_count": len(values),
           "min": round(min(values), 4) if values else None,
           "max": round(max(values), 4) if values else None,
           "mean": round(sum(values) / len(values), 4) if values else None,
           "latest": values[-1] if values else None,
       }
       return {"summary": summary, "points": points}

   def _response(status, body):
       return {
           "statusCode": status,
           "headers": {
               "Content-Type": "application/json",
               "Access-Control-Allow-Origin": "*",
           },
           "body": json.dumps(body),
       }

   def lambda_handler(event, context):
       # Direct invocation (Lab 08 assistant tool) - no HTTP envelope.
       if "requestContext" not in event:
           try:
               return query_metric(**event)
           except ValueError as err:
               return {"error": str(err)}

       params = event.get("queryStringParameters") or {}
       path = event.get("rawPath", "/telemetry")
       metric = params.get("metric",
                           "anomaly_score" if path.endswith("/anomalies")
                           else "temperature_c")
       try:
           result = query_metric(
               metric=metric,
               window_minutes=params.get("window_minutes", 60),
               location=params.get("location"),
               bucket_seconds=params.get("bucket_seconds", 60),
           )
       except ValueError as err:
           return _response(400, {"error": str(err)})
       except Exception as err:                      # noqa: BLE001
           print(f"[error] {type(err).__name__}: {err}")
           return _response(502, {"error": "upstream query failed"})

       return _response(200, result)
   ```

   Three things worth understanding before you deploy:

   - **InfluxDB answers in annotated CSV.** Every result table is preceded by `#datatype`, `#group` and `#default` comment lines and then its own header row. Handing that straight to `csv.DictReader` is the single most common mistake against this API: the reader treats `#datatype,...` as the field names, every lookup for `_time` misses, and the function returns an empty list with no error. `_parse_annotated_csv` skips the comment lines and picks up each table's real header, which is why it also handles a multi-table result correctly.
   - **Flux is a pipeline language.** `from(...) |> range(...) |> filter(...) |> aggregateWindow(...)` reads left to right like a Unix pipe. `aggregateWindow(every: 60s, fn: mean)` downsamples; without it, an hour of ten-second readings would return 360 points per location and the chart would be unreadable.
   - **ALLOWED_METRICS and ALLOWED_LOCATIONS are the security boundary.** The Flux query is built by string interpolation, so unvalidated input would be a query-injection vulnerability. Allow-listing is the correct fix here: an attacker cannot inject a Flux clause because the only values that reach the string are ones you enumerated.
   - **The function has two entry points.** When API Gateway invokes it the event has a `requestContext` key and the function returns an HTTP envelope; when the Lab 08 assistant invokes it directly it returns the raw result. One function, two consumers, no duplicated query logic.

1. Click **Deploy**.

1. Open the **Configuration** tab → **General configuration** → **Edit**, and set:

   | Field | Value |
   |---|---|
   | Memory | **256 MB** |
   | Timeout | **0 min 30 sec** |

   Click **Save**.

1. Open **Configuration** → **Environment variables** → **Edit**, and add the same four variables you used in Lab 02:

   | Key | Value |
   |---|---|
   | INFLUX_URL | **https://&lt;INFLUX-ENDPOINT&gt;:8086** |
   | INFLUX_ORG | **psb** |
   | INFLUX_BUCKET | **telemetry** |
   | INFLUX_SECRET_ID | **psb/influxdb/admin-token** |

   Click **Save**.

1. Open **Configuration** → **Permissions**, click the **Role name** link, and add the same inline secret-read policy you created in Lab 02 Task 4:

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

   Name it **psb-lab-read-influx-token** and click **Create policy**.

1. Return to the function, open the **Test** tab, and create a test event named **direct-query** with this body:

   ```json
   {
     "metric": "temperature_c",
     "window_minutes": 30,
     "bucket_seconds": 60
   }
   ```

1. Click **Test**. You should get a result like:

   ```json
   {
     "summary": {
       "metric": "temperature_c",
       "location": "all",
       "window_minutes": 30,
       "point_count": 28,
       "min": 21.94,
       "max": 24.11,
       "mean": 22.87,
       "latest": 23.02
     },
     "points": [ { "time": "2026-09-10T14:02:00Z", "location": "north-lab", "value": 22.84 } ]
   }
   ```

   > **Troubleshooting:** `point_count: 0` means no data in the window; confirm your simulator is still running and try `window_minutes: 240`.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Create the API Gateway HTTP API and Routes

1. In the AWS Management Console search bar, type **API Gateway** and select **API Gateway**.

1. On the **APIs** page, find the **HTTP API** card and click **Build**.

   > **Note:** You are deliberately choosing HTTP API rather than REST API. HTTP APIs cost roughly 70% less per request, have lower latency, and include a native JWT authorizer, which you will use in Lab 04. REST APIs offer features this lab does not need, such as request validation models, API keys and usage plans.

1. On the **Create and configure integrations** page, click **Add integration**:

   | Field | Value |
   |---|---|
   | Integration type | **Lambda** |
   | AWS Region | **<inject key="LabRegion" enableCopy="false"/>** |
   | Lambda function | **psb-query-telemetry** |
   | Version | **2.0** |

1. For **API name**, enter:

   - **API name:** **psb-lab-api**

   Click **Next**.

1. On the **Configure routes** page, set the first route:

   | Field | Value |
   |---|---|
   | Method | **GET** |
   | Resource path | **/telemetry** |
   | Integration target | **psb-query-telemetry** |

1. Click **Add route** and configure a second route:

   | Field | Value |
   |---|---|
   | Method | **GET** |
   | Resource path | **/anomalies** |
   | Integration target | **psb-query-telemetry** |

   Click **Next**.

1. On the **Configure stages** page, confirm a stage named **$default** with **Auto-deploy** enabled, then click **Next**.

1. Review and click **Create**.

1. On the API detail page, copy the **Invoke URL** from the top of the page. It looks like:

   ```text
   https://abc123xyz.execute-api.ap-southeast-1.amazonaws.com
   ```

   Paste it into your notepad; you will need it in Labs 05 and 08.

1. Now enable CORS so the browser-based dashboard can call the API. In the left-hand navigation pane, click **CORS**, then click **Configure**.

1. Set the following, clicking **Add** after typing each value:

   | Field | Value |
   |---|---|
   | Access-Control-Allow-Origin | **\*** |
   | Access-Control-Allow-Headers | **authorization, content-type** |
   | Access-Control-Allow-Methods | **GET, POST, OPTIONS** |
   | Access-Control-Max-Age | **300** |

   Click **Save**.

   > **Note:** `Access-Control-Allow-Origin: *` is acceptable for a lab. In production you would set it to your Amplify domain only, so that an arbitrary site cannot make authenticated calls on a user's behalf.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 3: Test the API and Inspect the Flux Query

1. On the Lab VM, open your second PowerShell window (the one not running the simulator).

1. Call the API. Replace `<INVOKE-URL>` with the value you copied in Task 2:

   ```powershell
   curl.exe "<INVOKE-URL>/telemetry?metric=temperature_c&window_minutes=30"
   ```

1. You should receive a JSON response containing a **summary** object and a **points** array.

   > **Note:** Use `curl.exe`, not `curl`. In PowerShell, `curl` is an alias for `Invoke-WebRequest`, which has different argument handling.

1. Try filtering by location:

   ```powershell
   curl.exe "<INVOKE-URL>/telemetry?metric=co2_ppm&window_minutes=60&location=north-lab"
   ```

1. Now confirm the allow-list is doing its job. Try an unlisted metric:

   ```powershell
   curl.exe "<INVOKE-URL>/telemetry?metric=DROP_TABLE"
   ```

   You should receive an HTTP 400 with:

   ```json
   { "error": "metric must be one of ['anomaly_score', 'co2_ppm', 'humidity_pct', 'temperature_c', 'vibration_g']" }
   ```

   The invalid value never reaches the Flux string.

1. Finally, look at the raw data in InfluxDB itself so you can see what Flux is querying. In the Amazon Timestream console, open **InfluxDB instances** → **psb-lab-influx** and click the **InfluxDB UI** link under **Connectivity & security**.

1. Sign in with the credentials from Lab 02 Task 1:

   | Field | Value |
   |---|---|
   | Username | **psbadmin** |
   | Password | **PsbLab#2026!Influx** |

1. In the left-hand navigation of the InfluxDB UI, click the **Data Explorer** icon (the graph icon).

1. Click the **Script Editor** button and paste:

   ```text
   from(bucket: "telemetry")
     |> range(start: -1h)
     |> filter(fn: (r) => r["_measurement"] == "reading")
     |> filter(fn: (r) => r["_field"] == "temperature_c")
     |> aggregateWindow(every: 1m, fn: mean, createEmpty: false)
   ```

1. Click **Submit**. You should see a chart of your temperature readings, one line per location.

1. Change `_field` to **co2_ppm** and click **Submit** again. Notice the periodic spikes: those are the anomalies the simulator injects, and they are what your Phase II model will learn to flag.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="e3f71658-7f13-4f1f-b292-d0b6308aee2e" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you have completed the following:

- Built an AWS Lambda function that queries Timestream for InfluxDB with Flux and returns a clean JSON time series.
- Applied allow-list validation to prevent query injection.
- Created an Amazon API Gateway HTTP API with two routes and CORS configured.
- Tested the API end to end and explored the underlying data in the InfluxDB UI.

You have successfully completed the lab. Click **Next** to continue to the next lab.

</div>

</div>
