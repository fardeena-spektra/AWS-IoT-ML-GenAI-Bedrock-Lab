<h1 align="center">🧠 Lab 06: Train an Anomaly Detection Model with SageMaker AI</h1>
<p align="center"><b>AWS Demo || Bedrock with Claude</b> | ⏱️ <b>Estimated Timing: 70 Minutes</b></p>

---

## 🎯 Overview

Phase II begins. Your sensors now stream data into InfluxDB and Amazon S3. In this lab, you load 24 hours of backfilled telemetry from S3 into **Amazon SageMaker AI Studio**, train a **Random Cut Forest (RCF)** anomaly detection model, deploy it to a **serverless endpoint**, and pick a score cutoff that the scoring pipeline uses in Lab 07.

## 📋 Objectives

In this lab, you will complete the following tasks:

1. 📥 **Task 1:** Backfill 24 hours of history and open SageMaker AI Studio.
1. 🏋️ **Task 2:** Load the data and train the Random Cut Forest model (cells 1 to 4).
1. 🚀 **Task 3:** Deploy, score and choose the anomaly cutoff (cells 5 to 10).

## 🏗️ What you build

```text
simulator (backfill 24h) ──► IoT rule ──► S3 raw/ ──► JupyterLab notebook
                                                      │
                                                      ├─► RCF training job (ml.m5.large) ──► s3://<bucket>/model/
                                                      └─► serverless endpoint psb-anomaly-endpoint ──► ANOMALY_CUTOFF
```

> ℹ️ **Info:** The SageMaker domain **psb-lab-domain**, user profile **psb-lab-user** and its execution role (with read/write access to your lab bucket) are pre-created for you.

---

## 🧩 Task 1: Backfill 24 hours of history and open SageMaker AI Studio

🎯 **Goal:** Give the model enough history to learn from, then open a JupyterLab space with the notebook.

### 📥 Backfill the telemetry

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

### 🧪 Open SageMaker AI Studio

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

---

## 🧩 Task 2: Load the data and train the Random Cut Forest model

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

---

## 🧩 Task 3: Deploy, score and choose the anomaly cutoff

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

   <validation step="6fbeccac-a90e-4b5c-bdff-42f1a7e47d06" />

## 📝 Summary

In this lab, you:

- Backfilled 24 hours of telemetry (about 8,640 readings) into S3.
- Created the **psb-lab-space** JupyterLab space in SageMaker AI Studio.
- Trained a **Random Cut Forest** model on ml.m5.large (64 trees, 256 samples per tree).
- Deployed the serverless endpoint **psb-anomaly-endpoint** and measured precision, recall and F1.
- Picked the 98th percentile cutoff and recorded **ANOMALY_CUTOFF** for the scoring pipeline.

Click **Next** to continue.
