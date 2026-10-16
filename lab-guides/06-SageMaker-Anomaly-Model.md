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
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 06: Train an Anomaly-Detection Model with Amazon SageMaker AI</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">70 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;15 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

Phase I gave you data. Phase II gives you insight.

Your **raw/** prefix in Amazon S3 now holds a growing corpus of sensor readings. In this lab you will open Amazon SageMaker Studio, load that corpus into a notebook, prepare it, and train an anomaly-detection model using SageMaker's built-in Random Cut Forest algorithm. You will evaluate the model against the anomalies the simulator deliberately injected, then deploy it to a serverless inference endpoint.

> **Why Random Cut Forest and not XGBoost?** XGBoost is a supervised algorithm: it needs labelled examples of what you want it to predict. Your sensor data arrives unlabelled; nobody has told you which readings were faults. Random Cut Forest is unsupervised: it learns the shape of normal behaviour and assigns every point an anomaly score based on how much it disrupts that shape. That matches the question this project actually asks ("is this reading unusual?") and it needs no labelling effort at all.

XGBoost would be the right choice for a different question. If PSB later collects maintenance records and wants to predict "will this unit fail in the next 24 hours?", that is supervised binary classification with real labels, and XGBoost would be an excellent starting point. Section 3 of this lab returns to that.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Lab Objectives

You will be able to complete the following tasks:

- Task 1: Back-fill training data and open SageMaker Studio
- Task 2: Prepare the data and train the Random Cut Forest model
- Task 3: Evaluate the model and deploy a serverless endpoint

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Back-fill Training Data and Open SageMaker Studio

Random Cut Forest needs enough history to learn what "normal" looks like. If your simulator has been running for two hours you have roughly 720 readings: usable, but thin. In this task you will back-fill a full day of synthetic history in about two minutes.

1. On the Lab VM, switch to the first PowerShell window (the one running the simulator) and press **Ctrl + C** to stop it.

1. Run the simulator in back-fill mode. Replace `<IOT-ENDPOINT>` with your device data endpoint:

   ```powershell
   cd C:\psb-lab-assets\simulator
   python simulate_pi.py --endpoint <IOT-ENDPOINT> --certs-dir certs --backfill-hours 24 --interval 10
   ```

1. You will see progress output as it publishes:

   ```text
   [sim] back-filling 8640 readings over 24.0 h ...
   [sim] 0/8640
   [sim] 100/8640
   ...
   [sim] back-fill complete.
   ```

   This takes about three minutes. Every reading flows through your IoT rule, so it lands in both InfluxDB and the S3 **raw/** prefix, the same path as live data.

1. When the back-fill finishes, restart the live simulator so telemetry keeps arriving during the rest of the lab:

   ```powershell
   python simulate_pi.py --endpoint <IOT-ENDPOINT> --certs-dir certs --interval 10
   ```

   Leave this window running.

1. In the AWS Management Console search bar, type **SageMaker** and select **Amazon SageMaker AI**.

1. In the left-hand navigation pane, click **Studio**.

1. You will see a pre-provisioned domain named **psb-lab-domain** with a user profile named **psb-lab-user**.

   > **Note:** The domain was created for you by the lab deployment. Creating a SageMaker Studio domain from scratch takes 5 to 10 minutes and requires VPC and IAM configuration that is not the point of this lab.

1. Select the user profile **psb-lab-user** and click **Open Studio**.

1. Studio opens in a new browser tab. The first load takes about a minute.

1. In the Studio launcher, under **Applications**, click **JupyterLab**.

1. Click **Create JupyterLab space**:

   | Field | Value |
   |---|---|
   | Name | **psb-lab-space** |
   | Sharing | **Private** |

   Click **Create space**.

1. On the space configuration page, set:

   | Field | Value |
   |---|---|
   | Instance | **ml.t3.medium** |
   | Image | **SageMaker Distribution 2.x** (the latest available) |
   | Storage (GB) | **20** |

   > **Note:** **ml.t3.medium** costs USD 0.063 per hour in **<inject key="LabRegion" enableCopy="false"/>** and is ample for this notebook; the heavy lifting happens in a separate managed training job, not here. Choosing a large notebook instance for work a small one can do is one of the most common sources of wasted SageMaker spend.

1. Click **Run space**. It takes about two minutes to start.

1. When the status shows **Running**, click **Open JupyterLab**.

1. In the JupyterLab file browser, upload the provided notebook. Click the **Upload Files** icon (an upward arrow) and select:

   ```text
   C:\psb-lab-assets\notebook\psb-anomaly-detection.ipynb
   ```

1. Double-click **psb-anomaly-detection.ipynb** to open it. If prompted to select a kernel, choose **Python 3 (ipykernel)**.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Prepare the Data and Train the Random Cut Forest Model

Work through the notebook cell by cell. Run each cell with **Shift + Enter** and read the output before moving on.

1. **Cell 1: Set up.** Edit the `BUCKET` value to your own bucket name, **<inject key="LabBucketName" enableCopy="true"/>**, then run the cell:

   ```python
   import boto3, io, json, os
   import numpy as np
   import pandas as pd
   import sagemaker
   from sagemaker import RandomCutForest
   from sagemaker.serverless import ServerlessInferenceConfig

   BUCKET = "psb-lab-<DEPLOYMENT-ID>"      # <-- edit this
   RAW_PREFIX = "raw/"
   REGION = "ap-southeast-1"

   session = sagemaker.Session()
   role = sagemaker.get_execution_role()
   s3 = boto3.client("s3", region_name=REGION)

   print("SageMaker role :", role)
   print("Default bucket :", session.default_bucket())
   print("Lab bucket     :", BUCKET)
   ```

1. **Cell 2: Load the raw telemetry.** This reads every JSON object the IoT rule has landed:

   ```python
   def load_raw(bucket, prefix, limit=20000):
       """Read the IoT rule's JSON objects into a DataFrame."""
       paginator = s3.get_paginator("list_objects_v2")
       records, seen = [], 0
       for page in paginator.paginate(Bucket=bucket, Prefix=prefix):
           for obj in page.get("Contents", []):
               if not obj["Key"].endswith(".json"):
                   continue
               body = s3.get_object(Bucket=bucket, Key=obj["Key"])["Body"].read()
               try:
                   records.append(json.loads(body))
               except json.JSONDecodeError:
                   continue
               seen += 1
               if seen >= limit:
                   break
           if seen >= limit:
               break
       return pd.DataFrame(records)

   df = load_raw(BUCKET, RAW_PREFIX)
   print(f"Loaded {len(df):,} readings")
   df.head()
   ```

   > **Note:** Reading tens of thousands of tiny objects one at a time is slow, and it is exactly the "small files problem" that IoT pipelines run into at scale. The production answer is to put Amazon Data Firehose between the IoT rule and S3, which buffers messages and writes larger Parquet files. At lab volume the simple version is fine, and seeing it be slow is a useful lesson.

1. **Cell 3: Prepare the feature matrix.**

   ```python
   FEATURES = ["temperature_c", "humidity_pct", "co2_ppm", "vibration_g"]

   df["ts"] = pd.to_numeric(df["ts"], errors="coerce")
   df = df.dropna(subset=["ts"] + FEATURES).sort_values("ts").reset_index(drop=True)

   # Keep the injected_anomaly flag ASIDE for evaluation only.
   # It is never used for training - Random Cut Forest is unsupervised.
   truth = df["injected_anomaly"].fillna(False).astype(bool).values \
       if "injected_anomaly" in df.columns else None

   X = df[FEATURES].astype("float32").values
   print("Feature matrix:", X.shape)
   print(df[FEATURES].describe().round(2))
   ```

   > **Important:** Notice that `injected_anomaly` is held aside, not fed to the model. Your IoT rule already dropped it from the S3 payload, so in practice this column will be absent; the code handles both cases. Leaking a label into an unsupervised model's features is a classic mistake and produces a model that looks perfect and generalises to nothing.

1. **Cell 4: Train the model.** This launches a managed SageMaker training job:

   ```python
   rcf = RandomCutForest(
       role=role,
       instance_count=1,
       instance_type="ml.m5.large",
       data_location=f"s3://{BUCKET}/model/rcf-train/",
       output_path=f"s3://{BUCKET}/model/",
       num_samples_per_tree=256,
       num_trees=64,
       base_job_name="psb-rcf",
       sagemaker_session=session,
   )

   rcf.fit(rcf.record_set(X))
   print("Training job:", rcf.latest_training_job.name)
   ```

   This takes about five minutes. SageMaker provisions an **ml.m5.large** instance, runs the training container, writes the model artifact to **s3://<inject key="LabBucketName" enableCopy="false"/>/model/**, and tears the instance down. You pay only for those five minutes.

   > **Note on the hyperparameters.** `num_trees=64` is the size of the forest: more trees give a smoother, more stable score at higher training cost. `num_samples_per_tree=256` controls how much data each tree sees; the AWS guidance is to set it so that 1/num_samples_per_tree is roughly the expected proportion of anomalies. Your simulator injects anomalies at 2%, and 1/256 ≈ 0.4%, which is deliberately conservative: it makes the model flag only clear outliers rather than everything slightly unusual.

1. Watch the training log stream in the cell output. When you see **Training seconds:** and **Billable seconds:**, the job is done.

1. Verify the artifact landed. Run:

   ```python
   print(rcf.model_data)
   ```

   You should see an S3 URI ending **/model/psb-rcf-&lt;timestamp&gt;/output/model.tar.gz**.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 3: Evaluate the Model and Deploy a Serverless Endpoint

1. **Cell 5: Deploy to a serverless endpoint.**

   ```python
   predictor = rcf.deploy(
       endpoint_name="psb-anomaly-endpoint",
       serverless_inference_config=ServerlessInferenceConfig(
           memory_size_in_mb=2048,
           max_concurrency=5,
       ),
   )
   print("Endpoint:", predictor.endpoint_name)
   ```

   Deployment takes about four minutes.

   > **Why serverless inference.** A real-time endpoint on **ml.m5.large** costs USD 0.144 per hour whether or not anything calls it: about USD 3.46 for a 24-hour lab window, and considerably more if a learner forgets to delete it. A serverless endpoint bills per millisecond of actual compute: this lab's few hundred invocations cost under one cent. The trade-off is a cold start of one to three seconds after an idle period, which matters for a trading system and does not matter at all for a five-minute sensor scoring job.

   The other two options in the SageMaker deployment menu are worth knowing. **Batch Transform** scores a whole S3 prefix in one job and shuts down, ideal for nightly re-scoring of a full day's data. **Asynchronous Inference** queues requests and is designed for large payloads and long inference times.

1. **Cell 6: Score the training data and evaluate.**

   ```python
   from sagemaker.serializers import CSVSerializer
   from sagemaker.deserializers import JSONDeserializer

   predictor.serializer = CSVSerializer()
   predictor.deserializer = JSONDeserializer()

   def score(matrix, batch=500):
       out = []
       for i in range(0, len(matrix), batch):
           chunk = matrix[i:i + batch]
           result = predictor.predict(chunk)
           out.extend(r["score"] for r in result["scores"])
       return np.array(out)

   scores = score(X)
   df["anomaly_score"] = scores

   cutoff = np.percentile(scores, 98.0)     # flag the top 2%
   df["is_anomaly"] = df["anomaly_score"] > cutoff

   print(f"Score range     : {scores.min():.3f} .. {scores.max():.3f}")
   print(f"Mean score      : {scores.mean():.3f}")
   print(f"98th percentile : {cutoff:.3f}")
   print(f"Flagged         : {df['is_anomaly'].sum():,} of {len(df):,}")
   ```

1. **Cell 7: Check the model against the injected anomalies.** This cell runs only if the ground-truth column survived; otherwise it explains why.

   ```python
   if truth is not None and truth.any():
       tp = int((df["is_anomaly"] &  truth).sum())
       fp = int((df["is_anomaly"] & ~truth).sum())
       fn = int((~df["is_anomaly"] &  truth).sum())
       precision = tp / (tp + fp) if (tp + fp) else 0.0
       recall    = tp / (tp + fn) if (tp + fn) else 0.0
       f1 = 2 * precision * recall / (precision + recall) if (precision + recall) else 0.0
       print(f"True positives : {tp}")
       print(f"False positives: {fp}")
       print(f"False negatives: {fn}")
       print(f"Precision      : {precision:.3f}")
       print(f"Recall         : {recall:.3f}")
       print(f"F1             : {f1:.3f}")
   else:
       print("No ground-truth column - your IoT rule correctly dropped it.")
       print("Evaluate by inspecting the highest-scoring readings instead:")
       print(df.nlargest(10, "anomaly_score")[
           ["ts", "location"] + FEATURES + ["anomaly_score"]].to_string(index=False))
   ```

   > **Interpreting the result.** You should see recall around 0.6 to 0.8 and precision around 0.5 to 0.7. That is a reasonable and honest result for an unsupervised model on four correlated features. It is not 0.99, and a model that claimed 0.99 on this data would be a sign that a label had leaked into the features. Recall matters more than precision for equipment monitoring (missing a real fault is worse than sending a technician to check a false alarm), so in production you would lower the percentile cutoff from 98 to, say, 95 and accept more false positives.

1. **Cell 8: Plot the result.**

   ```python
   import matplotlib.pyplot as plt

   sub = df[df["location"] == "north-lab"].tail(2000)
   fig, ax = plt.subplots(2, 1, figsize=(13, 7), sharex=True)

   ax[0].plot(sub["ts"], sub["temperature_c"], lw=0.8, label="temperature_c")
   flagged = sub[sub["is_anomaly"]]
   ax[0].scatter(flagged["ts"], flagged["temperature_c"],
                 s=26, color="crimson", zorder=3, label="flagged")
   ax[0].set_ylabel("°C"); ax[0].legend(loc="upper left")
   ax[0].set_title("north-lab temperature with Random Cut Forest anomalies")

   ax[1].plot(sub["ts"], sub["anomaly_score"], lw=0.8, color="#B8562B")
   ax[1].axhline(cutoff, ls="--", color="grey", label=f"cutoff {cutoff:.2f}")
   ax[1].set_ylabel("anomaly score"); ax[1].set_xlabel("epoch seconds")
   ax[1].legend(loc="upper left")
   plt.tight_layout(); plt.show()
   ```

   Look at the two panels together. The score rises sharply where the injected heat and CO₂ events occurred, and stays low through the normal diurnal cycle, which is the behaviour you want. A model that fired on every afternoon temperature peak would be learning the daily cycle as an anomaly, not a fault.

1. **Cell 9: Write the scored data to the curated prefix.**

   ```python
   out = df[["ts", "device_id", "location"] + FEATURES
            + ["anomaly_score", "is_anomaly"]].copy()
   buf = io.StringIO()
   out.to_csv(buf, index=False)
   key = "curated/scored/backfill-scored.csv"
   s3.put_object(Bucket=BUCKET, Key=key, Body=buf.getvalue().encode())
   print(f"Wrote s3://{BUCKET}/{key}  ({len(out):,} rows)")
   ```

1. **Cell 10: Record the cutoff for Lab 07.** The scoring Lambda needs the same threshold:

   ```python
   print("ANOMALY_CUTOFF for Lab 07 =", round(float(cutoff), 4))
   ```

   Copy this number into your notepad.

1. Verify the endpoint is live. Return to the Amazon SageMaker AI console, expand **Inference** in the left-hand navigation, and click **Endpoints**. Confirm **psb-anomaly-endpoint** shows status **InService**.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="2b42ba6d-dde6-4d2c-a1ff-17d30f14b658" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you have completed the following:

- Back-filled 24 hours of telemetry through the live IoT pipeline.
- Opened Amazon SageMaker Studio and created a JupyterLab space.
- Loaded raw telemetry from S3, prepared a feature matrix, and held ground truth aside.
- Trained a Random Cut Forest anomaly-detection model with a managed SageMaker training job.
- Evaluated precision and recall against the injected anomalies and plotted the result.
- Deployed the model to a serverless inference endpoint and wrote scored output to S3.

You have successfully completed the lab. Click **Next** to continue to the next lab.

</div>

</div>
