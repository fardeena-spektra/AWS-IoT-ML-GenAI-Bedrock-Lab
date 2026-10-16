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
.psbgs td [class]:not([class^=psb]),.psbgs p [class]:not([class^=psb]),.psbgs li [class]:not([class^=psb]){color:#0f766e!important;-webkit-text-fill-color:#0f766e!important;font-weight:600}
.psbgs td img:not([class^=psb]),.psbgs td svg,.psbgs td i,.psbgs td button,.psbgs [class*=copy],.psbgs [class*=Copy],.psbgs [title*=opy]{cursor:pointer;border-radius:6px;transition:transform .15s ease}
.psbgs td img:not([class^=psb]):hover,.psbgs td svg:hover,.psbgs td i:hover,.psbgs td button:hover,.psbgs [class*=copy]:hover,.psbgs [class*=Copy]:hover,.psbgs [title*=opy]:hover{transform:scale(1.2);animation:psbRGB 1.2s linear infinite}
.psbgs td img:not([class^=psb]):active,.psbgs td svg:active,.psbgs td i:active,.psbgs td button:active,.psbgs [class*=copy]:active,.psbgs [class*=Copy]:active,.psbgs [title*=opy]:active{animation:psbHit .3s ease,psbBurst .5s ease-out}
@media (prefers-reduced-motion:reduce){.psbgs *,.psbgs *::before,.psbgs *::after{animation:none!important;transition:none!important}}
</style>

<div class="psbgs">

<div class="psb-hero" style="position:relative;overflow:hidden;border-radius:16px;padding:28px 20px 24px;margin:0 0 6px;text-align:center;color:#ffffff;background:linear-gradient(120deg,#070b1a,#121a3a,#0d2b36,#16123a);">
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 06: Amazon SageMaker AI Anomaly Model</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">70 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;15 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

Phase II begins. Your sensors now stream data into InfluxDB and Amazon S3. In this lab, you load 24 hours of backfilled telemetry from S3 into **Amazon SageMaker AI Studio**, train a **Random Cut Forest (RCF)** anomaly detection model, deploy it to a **serverless endpoint**, and pick a score cutoff that the scoring pipeline uses in Lab 07.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Objectives

In this lab, you will complete the following tasks:

1. 📥 **Task 1:** Backfill 24 hours of history and open SageMaker AI Studio.
1. 🏋️ **Task 2:** Load the data and train the Random Cut Forest model (cells 1 to 4).
1. 🚀 **Task 3:** Deploy, score and choose the anomaly cutoff (cells 5 to 10).

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🏗️</span>What you build

```text
simulator (backfill 24h) ──► IoT rule ──► S3 raw/ ──► JupyterLab notebook
                                                      │
                                                      ├─► RCF training job (ml.m5.large) ──► s3://<bucket>/model/
                                                      └─► serverless endpoint psb-anomaly-endpoint ──► ANOMALY_CUTOFF
```

> ℹ️ **Info:** The SageMaker domain **psb-lab-domain**, user profile **psb-lab-user** and its execution role (with read/write access to your lab bucket) are pre-created for you.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Backfill 24 Hours of History and Open SageMaker AI Studio

🎯 **Goal:** Give the model enough history to learn from, then open a JupyterLab space with the notebook.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📥</span>Backfill the telemetry

1. Switch to the PowerShell window running the simulator and press **Ctrl+C** to stop it.

1. Run the simulator in backfill mode (replace **&lt;IOT-ENDPOINT&gt;** with your device data endpoint from Lab 01):

   ```powershell
   cd C:\psb-lab-assets\simulator
   python simulate_pi.py --endpoint <IOT-ENDPOINT> --certs-dir certs --interval 10 --backfill-hours 24
   ```

   > ℹ️ **Info:** Backfill mode publishes about **8,640 readings** (24 hours at a 10 second interval) with historical timestamps as fast as possible, then exits. It takes a few minutes. About 2% of the readings are injected anomalies flagged with **injected_anomaly: true**.

1. When the backfill finishes, restart live mode and leave it running:

   ```powershell
   python simulate_pi.py --endpoint <IOT-ENDPOINT> --certs-dir certs --interval 10
   ```

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧪</span>Open SageMaker AI Studio

1. In the AWS console search bar, type **SageMaker AI** and open **Amazon SageMaker AI**.

1. In the left menu, select **Applications and IDEs** > **Studio**.

1. Select domain **psb-lab-domain** and user profile **psb-lab-user**, then select **Open Studio**.

1. In Studio, under **Applications**, select **JupyterLab**, then select **+ Create JupyterLab space**.

1. Enter **psb-lab-space** as the name, set **Sharing** to **Private**, and select **Create space**.

1. Configure the space:

   | Setting | Value |
   |---|---|
   | **Name** | psb-lab-space |
   | **Sharing** | Private |
   | **Instance** | ml.t3.medium |
   | **Image** | SageMaker Distribution 2.x (latest 2.x listed) |
   | **Storage (GB)** | 20 |

1. Select **Run space** and wait until the status is **Running** (2 to 3 minutes), then select **Open JupyterLab**.

1. In the JupyterLab file browser, select the **Upload Files** icon and upload **C:\psb-lab-assets\notebook\psb-anomaly-detection.ipynb**.

1. Double-click the notebook to open it. If asked for a kernel, choose **Python 3 (ipykernel)**.

✅ **Expected result:** About 8,640 backfilled objects are landing under **raw/** in your bucket, the simulator is back in live mode, and **psb-anomaly-detection.ipynb** is open in the **psb-lab-space** JupyterLab space.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Load the Data and Train the Random Cut Forest Model

🎯 **Goal:** Run cells 1 to 4 to prepare features and train the RCF model.

1. In cell 1, set the bucket name to your lab bucket:

   ```python
   BUCKET = "<inject key="LabBucketName" enableCopy="false"/>"
   ```

   | Value | |
   |---|---|
   | **Your lab bucket** | <inject key="LabBucketName" enableCopy="true"/> |

1. Run cells 1 to 4 one at a time (**Shift+Enter**). Here is what each cell does:

   | Cell | What it does |
   |---|---|
   | **1** | Imports libraries, creates the SageMaker session, reads the execution role and sets **BUCKET** to psb-lab-&lt;DeploymentID&gt; and the region ap-southeast-1. |
   | **2** | Lists and loads the raw JSON objects from **raw/** in S3 (up to **20,000 records**) into a pandas DataFrame. |
   | **3** | Builds the 4 feature columns **temperature_c**, **humidity_pct**, **co2_ppm**, **vibration_g** and holds the **injected_anomaly** labels aside (the model never sees them; they are only used to measure quality later). |
   | **4** | Trains a **RandomCutForest** estimator: instance **ml.m5.large**, **64 trees**, **256 samples per tree**, output path **s3://&lt;BUCKET&gt;/model/**. Prints **rcf.model_data** when done. |

   > ⏱️ **Training takes about 5 to 8 minutes.** Cell 4 streams the training job log. Wait for **Completed** before continuing.

1. Confirm that cell 4 prints **rcf.model_data**, an S3 path similar to:

   ```text
   s3://psb-lab-<DeploymentID>/model/randomcutforest-2026-..../output/model.tar.gz
   ```

   | Problem | Likely cause and fix |
   |---|---|
   | Cell 2 loads 0 records | **BUCKET** is wrong or the backfill did not land in **raw/**. Check S3 and the IoT rule. |
   | AccessDenied on S3 | The bucket name does not match psb-lab-&lt;DeploymentID&gt;; the execution role can only use the lab bucket. |
   | ResourceLimitExceeded | Use exactly **ml.m5.large** for training. |

✅ **Expected result:** The training job completes and **rcf.model_data** points to a model artifact under **model/** in your bucket.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 3: Deploy, Score and Choose the Anomaly Cutoff

🎯 **Goal:** Run cells 5 to 10 to deploy a serverless endpoint, score the history and record **ANOMALY_CUTOFF** for Lab 07.

1. Run cells 5 to 10 one at a time:

   | Cell | What it does |
   |---|---|
   | **5** | Deploys the model to the **serverless endpoint psb-anomaly-endpoint** (memory **2048 MB**, max concurrency **5**). Takes about **3 to 5 minutes**. |
   | **6** | Sends all records to the endpoint as text/csv in **batches of 500** and collects one anomaly score per reading. |
   | **7** | Sets the cutoff to the **98th percentile** of the scores (about 2% flagged, matching the injected anomaly rate). |
   | **8** | Compares flagged readings with the held-out **injected_anomaly** labels and prints **precision**, **recall** and **F1**. |
   | **9** | Plots the anomaly scores over time with the cutoff as a horizontal line. |
   | **10** | Writes **curated/scored/backfill-scored.csv** to S3 and prints **ANOMALY_CUTOFF = &lt;value&gt;**. |

1. Review the plot in cell 9. Injected spikes should appear above the cutoff line.

1. Copy the value printed by cell 10 and save it in Notepad on the lab VM. You need it in Lab 07:

   ```text
   ANOMALY_CUTOFF = 2.8471
   ```

   > 💡 **Tip:** Your value will differ. Copy the exact number your notebook prints.

1. In the SageMaker AI console, select **Inference** > **Endpoints** and confirm **psb-anomaly-endpoint** shows **InService**.

1. In the S3 console, open your bucket <inject key="LabBucketName" enableCopy="false"/> and confirm **curated/scored/backfill-scored.csv** and the **model/** output exist.

   > ⚠️ **Note:** Keep the space and endpoint running for now. You stop and delete them during teardown in Lab 09.

   ✅ **Expected result:** **psb-anomaly-endpoint** is **InService**, **backfill-scored.csv** is in **curated/scored/**, and you have recorded **ANOMALY_CUTOFF**.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="2b42ba6d-dde6-4d2c-a1ff-17d30f14b658" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you:

- Backfilled 24 hours of telemetry (about 8,640 readings) into S3.
- Created the **psb-lab-space** JupyterLab space in SageMaker AI Studio.
- Trained a **Random Cut Forest** model on ml.m5.large (64 trees, 256 samples per tree).
- Deployed the serverless endpoint **psb-anomaly-endpoint** and measured precision, recall and F1.
- Picked the 98th percentile cutoff and recorded **ANOMALY_CUTOFF** for the scoring pipeline.

Click **Next** to continue.

</div>

</div>
