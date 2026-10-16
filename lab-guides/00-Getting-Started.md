<style>
@property --psbA{syntax:'<angle>';inherits:false;initial-value:0deg}
@keyframes psbAurora{0%{background-position:0% 50%}50%{background-position:100% 50%}100%{background-position:0% 50%}}
@keyframes psbSweep{0%{background-position:-150% 0}55%,100%{background-position:250% 0}}
@keyframes psbOrb{0%,100%{transform:translate(0,0) scale(1);opacity:.55}50%{transform:translate(30px,-18px) scale(1.15);opacity:.9}}
@keyframes psbDrop{0%{opacity:0;transform:translateY(-12px)}100%{opacity:1;transform:none}}
@keyframes psbRise{0%{opacity:0;transform:translateY(18px)}100%{opacity:1;transform:none}}
@keyframes psbSpin{to{--psbA:360deg}}
@keyframes psbLift{0%,100%{box-shadow:0 2px 10px rgba(15,27,45,.06)}50%{box-shadow:0 8px 26px rgba(15,27,45,.12)}}
@keyframes psbBar{0%{background-position:0% 0}100%{background-position:200% 0}}
@keyframes psbLine{0%,100%{width:90px}50%{width:150px}}
@keyframes psbHit{0%{transform:scale(1)}35%{transform:scale(1.25)}70%{transform:scale(.94)}100%{transform:scale(1)}}
@keyframes psbWave{0%{box-shadow:0 0 0 0 rgba(255,153,0,.6)}100%{box-shadow:0 0 0 14px rgba(255,153,0,0)}}
.psbgs{position:relative}
/* hero */
.psbgs .psb-hero{background-size:300% 300%!important;animation:psbAurora 14s ease infinite,psbDrop .6s ease-out both;box-shadow:0 12px 32px rgba(15,27,45,.28)}
.psbgs .psb-hero::before{content:"";position:absolute;width:260px;height:260px;left:-60px;top:-90px;border-radius:50%;background:radial-gradient(closest-side,rgba(255,153,0,.35),transparent);animation:psbOrb 9s ease-in-out infinite;pointer-events:none}
.psbgs .psb-hero::after{content:"";position:absolute;inset:0;background:linear-gradient(110deg,transparent 35%,rgba(255,255,255,.12) 50%,transparent 65%);background-size:250% 100%;animation:psbSweep 6s ease-in-out infinite;pointer-events:none}
.psbgs .psb-title{font-size:2em!important;color:#ffffff!important;letter-spacing:.01em}
.psbgs .psb-line{animation:psbLine 4s ease-in-out infinite}
.psbgs .psb-chip{transition:transform .2s ease,background .2s ease,border-color .2s ease}
.psbgs .psb-chip:hover{transform:translateY(-3px);background:rgba(255,153,0,.18)!important;border-color:rgba(255,153,0,.7)!important}
.psbgs .psb-chip:active{animation:psbHit .3s ease}
.psbgs .psb-chip *{color:#ffffff!important;-webkit-text-fill-color:#ffffff!important}
/* cards */
.psbgs .psb-panel{position:relative;animation:psbRise .6s cubic-bezier(.2,.8,.2,1) both,psbLift 7s ease-in-out infinite;transition:transform .25s ease,border-color .25s ease}
.psbgs .psb-panel:nth-of-type(2){animation-delay:.08s,-1s}.psbgs .psb-panel:nth-of-type(3){animation-delay:.16s,-2s}.psbgs .psb-panel:nth-of-type(4){animation-delay:.24s,-3s}
.psbgs .psb-panel:nth-of-type(5){animation-delay:.32s,-4s}.psbgs .psb-panel:nth-of-type(6){animation-delay:.4s,-5s}.psbgs .psb-panel:nth-of-type(7){animation-delay:.48s,-6s}
.psbgs .psb-panel::before{content:"";position:absolute;left:0;top:18px;bottom:18px;width:4px;border-radius:0 4px 4px 0;background:linear-gradient(180deg,#ff9900,#ec7211)}
.psbgs .psb-panel:hover{transform:translateY(-2px);border-color:#ffc266!important}
/* headings */
.psbgs h2{border:0!important;padding-bottom:10px!important;position:relative;color:#16191f!important;font-weight:700!important}
.psbgs h2::after{content:"";position:absolute;left:0;bottom:0;height:3px;width:100%;border-radius:3px;background:linear-gradient(90deg,#ff9900,#ffc266,#232f3e,#ff9900);background-size:200% 100%;animation:psbBar 4s linear infinite}
.psbgs h3{color:#232f3e!important;font-weight:700!important}
/* tables */
.psbgs table{border-radius:10px;overflow:hidden;box-shadow:0 2px 10px rgba(15,27,45,.06)}
.psbgs th{color:#ffffff!important;background:#232f3e!important;border-color:#232f3e!important}
.psbgs tbody tr{transition:background .2s ease,box-shadow .2s ease}
.psbgs tbody tr:hover{background:#fff7eb!important;box-shadow:inset 3px 0 0 #ff9900}
/* tips */
.psbgs blockquote{background:#f2f8fd!important;border-left:4px solid #0972d3!important;border-radius:0 10px 10px 0;transition:transform .2s ease}
.psbgs blockquote:hover{transform:translateX(3px)}
/* screenshots: full animated border */
.psbgs .psb-shot{position:relative;margin:14px 2px 20px;padding:6px;border-radius:14px;border:2px solid transparent;
  background:linear-gradient(#ffffff,#ffffff) padding-box,conic-gradient(from var(--psbA),#ff9900,#232f3e,#0972d3,#232f3e,#ff9900) border-box;
  animation:psbSpin 6s linear infinite;transition:transform .25s ease,box-shadow .25s ease}
.psbgs .psb-shot p{margin:0!important}
.psbgs .psb-shot img{display:block;max-width:100%;height:auto;margin:0 auto;border-radius:9px}
.psbgs .psb-shot:hover{transform:translateY(-2px);box-shadow:0 12px 28px rgba(15,27,45,.18)}
.psbgs .psb-shot:active{animation:psbSpin 6s linear infinite,psbWave .45s ease-out;transform:scale(.99)}
/* links */
.psbgs a{color:#0972d3!important;font-weight:600;transition:color .2s ease}
.psbgs a:hover{color:#ec7211!important}
.psbgs a:active{display:inline-block;animation:psbHit .3s ease}
/* CloudLabs inject values + copy buttons (tables and text only) */
.psbgs td [class]:not([class^=psb]),.psbgs p [class]:not([class^=psb]),.psbgs li [class]:not([class^=psb]){color:#0972d3!important;-webkit-text-fill-color:#0972d3!important;font-weight:600}
.psbgs td img:not([src*="media/"]),.psbgs td svg,.psbgs td i,.psbgs td button,.psbgs [class*=copy],.psbgs [class*=Copy],.psbgs [title*=opy]{cursor:pointer;border-radius:6px;transition:transform .15s ease,filter .15s ease}
.psbgs td img:not([src*="media/"]):hover,.psbgs td svg:hover,.psbgs td i:hover,.psbgs td button:hover,.psbgs [class*=copy]:hover,.psbgs [class*=Copy]:hover,.psbgs [title*=opy]:hover{transform:scale(1.18);filter:drop-shadow(0 0 4px rgba(255,153,0,.8))}
.psbgs td img:not([src*="media/"]):active,.psbgs td svg:active,.psbgs td i:active,.psbgs td button:active,.psbgs [class*=copy]:active,.psbgs [class*=Copy]:active,.psbgs [title*=opy]:active{animation:psbHit .3s ease,psbWave .45s ease-out;filter:drop-shadow(0 0 8px rgba(255,153,0,1))}
@media (prefers-reduced-motion:reduce){.psbgs *,.psbgs *::before,.psbgs *::after{animation:none!important;transition:none!important}}
</style>

<div class="psbgs" style="background:linear-gradient(180deg,#f7f9fc 0%,#eef3f9 100%);border:1px solid #e3e9f1;border-radius:20px;padding:14px 10px 22px;margin:0 -20px;">

<div class="psb-hero" style="position:relative;overflow:hidden;border-radius:18px;padding:30px 18px 26px;margin:0 0 18px;text-align:center;color:#ffffff;background:linear-gradient(120deg,#161e2d,#232f3e,#1b3a5c,#232f3e);">
<div class="psb-badge" style="display:inline-block;padding:4px 14px;border-radius:999px;background:rgba(255,153,0,.16);border:1px solid rgba(255,153,0,.55);color:#ffb84d;font-weight:700;letter-spacing:.14em;font-size:.76em;">GUIDED LAB</div>
<h1 class="psb-title" style="color:#ffffff;margin:12px 0 4px;border:0;">🚀 Getting Started</h1>
<div class="psb-sub" style="color:#d5dbe3;font-weight:600;">AWS Demo || Bedrock with Claude</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 6px;border-radius:3px;background:#ff9900;"></div>
<div class="psb-chips" style="margin-top:10px;">
<span class="psb-chip" style="display:inline-block;margin:4px;padding:6px 14px;border-radius:999px;background:rgba(255,255,255,.10);border:1px solid rgba(255,255,255,.28);color:#ffffff;font-weight:600;">⏱️ 8 Hours 10 Minutes</span>
<span class="psb-chip" style="display:inline-block;margin:4px;padding:6px 14px;border-radius:999px;background:rgba(255,255,255,.10);border:1px solid rgba(255,255,255,.28);color:#ffffff;font-weight:600;">🏆 100 Points</span>
<span class="psb-chip" style="display:inline-block;margin:4px;padding:6px 14px;border-radius:999px;background:rgba(255,255,255,.10);border:1px solid rgba(255,255,255,.28);color:#ffffff;font-weight:600;">🧩 9 Labs</span>
<span class="psb-chip" style="display:inline-block;margin:4px;padding:6px 14px;border-radius:999px;background:rgba(255,255,255,.10);border:1px solid rgba(255,255,255,.28);color:#ffffff;font-weight:600;">🌍 <inject key="LabRegion" enableCopy="false"/></span>
</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #dfe5ee;border-radius:16px;padding:16px 14px;margin:18px 0;">

## 🎯 About This Lab

In this hands-on lab, you build a complete **IoT to Machine Learning to Generative AI** solution on AWS. A simulated sensor device streams telemetry (temperature, humidity, CO₂ and vibration) into **AWS IoT Core**. The data is stored in **Amazon Timestream for InfluxDB** and **Amazon S3**, served through **AWS Lambda** and **Amazon API Gateway**, secured with **Amazon Cognito**, and shown on a dashboard hosted on **AWS Amplify**. You then train an anomaly detection model in **Amazon SageMaker AI**, score live data automatically, and finish with a natural language assistant powered by **Amazon Bedrock**.

**The lab is organised in three phases:**

| Phase | Labs | Focus |
|---|---|---|
| 🔌 **Phase I** | Labs 01 to 05 | Connect, ingest, serve (IoT Core, InfluxDB, S3, Lambda, API Gateway, Cognito, Amplify) |
| 🧠 **Phase II** | Labs 06 to 07 | Machine learning (SageMaker Random Cut Forest anomaly model + scoring pipeline) |
| 🤖 **Phase III** | Labs 08 to 09 | Generative AI + operations (Bedrock assistant, CloudWatch, teardown) |

### 🗺️ Labs Overview

| Lab | Title | Phase | ⏱️ Timing | 🏆 Points |
|:---:|---|:---:|:---:|:---:|
| 01 | 🛰️ IoT Identity and Device Simulator | I | 45 min | 10 |
| 02 | 🔀 Rules Engine to InfluxDB and S3 | I | 65 min | 16 |
| 03 | 🔎 Query Lambda and HTTP API | I | 55 min | 10 |
| 04 | 🔐 Cognito Authentication | I | 40 min | 10 |
| 05 | 📊 Amplify Dashboard | I | 45 min | 9 |
| 06 | 🧪 SageMaker Anomaly Model | II | 70 min | 15 |
| 07 | ⚙️ Automated Scoring Pipeline | II | 50 min | 12 |
| 08 | 🤖 Bedrock Assistant | III | 60 min | 13 |
| 09 | 📈 Observability and Teardown | III | 40 min | 5 |
| | **Total** | | **8 h 10 min** | **100** |

### 🏗️ What you build

<div class="psb-shot">

![Solution architecture](./media/architecture.png)

</div>

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #dfe5ee;border-radius:16px;padding:16px 14px;margin:18px 0;">

## 🖥️ Lab Environment

The lab window is split into two parts:

- **Left side:** your lab virtual machine (VM), a Windows Server 2022 workstation.
- **Right side:** the lab guide, with the steps to complete each task.

Your lab window looks like this:

<div class="psb-shot">

![Lab environment](./media/gs-01.png)

</div>

### 📦 Pre-provisioned Resources

The following resources are already created for you. You do **not** need to create them.

| Resource | Name / Value |
|---|---|
| 🌍 **Region** | <inject key="LabRegion" enableCopy="true"/> |
| 🪣 **S3 bucket** (empty) | <inject key="LabBucketName" enableCopy="true"/> |
| 🧪 **SageMaker Studio domain** | <inject key="SageMakerDomainName" enableCopy="true"/> |
| 👤 **SageMaker user profile** | **psb-lab-user** |
| 🔑 **SageMaker execution role** | **psb-lab-sagemaker-exec-<inject key="DeploymentID" enableCopy="false"/>** (can read and write the lab bucket) |
| 💻 **Lab VM** | **windowsvm-<inject key="DeploymentID" enableCopy="false"/>** (t3.medium) |
| 🧰 **VM tooling** | Chrome, Edge, VS Code, AWS CLI v2, Python 3.12 (python + pip on PATH), Node.js LTS (node / npm), Git |
| 📁 **Lab assets** | **C:\psb-lab-assets** + desktop shortcut **psb-lab-assets** |
| 📄 **Desktop files** | **aws credentials.txt** and the **AWS Console** shortcut |

> ℹ️ **Info:** In Lab 02 you create the **raw/**, **curated/** and **model/** folders in the S3 bucket. In Lab 06 you create the SageMaker space **psb-lab-space**.

### 📁 Lab Assets Folder

The **psb-lab-assets** folder on the desktop (**C:\psb-lab-assets**) contains everything you need:

| Folder / File | Contents |
|---|---|
| 🛰️ **simulator** | **simulate_pi.py** device simulator, **requirements.txt**, and **certs** (device certificates go here in Lab 01) |
| ⚡ **lambdas** | The 4 Lambda functions: **psb-ingest-telemetry**, **psb-query-telemetry**, **psb-score-telemetry**, **psb-assistant** (each with **lambda_function.py**) |
| 🧪 **test-events** | **sample-reading.json**, **direct-query.json**, **manual-run.json**, **ask-question.json** |
| 🔐 **policies** | IAM and IoT policy files (device policy, IoT rule trust and S3 write, Influx token read, score policy, assistant policy) |
| 📊 **dashboard** | React dashboard source (Vite + React 18) and prebuilt fallback **dist.zip** |
| 📓 **notebook** | SageMaker notebook **psb-anomaly-detection.ipynb** |
| 📝 **README.txt** | Short description of the folder |

### 🤖 About Bedrock and Claude

> ℹ️ **Info:** The lab title says **Claude**. The assistant you build in Lab 08 uses **Amazon Nova Lite** (APAC inference profile **apac.amazon.nova-lite-v1:0**) through the same Amazon Bedrock **Converse API**. Claude models can be swapped in by changing the **MODEL_ID** environment variable of the assistant Lambda function (and the model ARNs in its IAM policy). No code change is needed.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #dfe5ee;border-radius:16px;padding:16px 14px;margin:18px 0;">

## 🧭 Lab Window Controls

The top bar and the lab guide menu give you these controls:

<div class="psb-shot">

![Lab window controls](./media/gs-topbar.png)

</div>

| # | Control | Use |
|:---:|---|---|
| 1 | **VM name** | Shows the lab VM you are connected to. |
| 2 | **Timer** | Time remaining in your lab session. |
| 3 | **Progress bar** | Your progress through the lab. |
| 4 | **A↕** | Change the text size of the lab guide. |
| 5 | **Refresh** | Reconnect the VM if the screen stops responding. |
| 6 | **More (...)** | Language, Delete and VM Native Clipboard options. |
| 7 | **Lab guide menu** | Guide, Environment, Progress, Resources and Help. |
| 8 | **Split window** | Split the lab guide and the VM into separate windows. |

### 6️⃣ More Options

Select **More (...)** in the top bar to open these options:

<div class="psb-shot">

![More options](./media/gs-more-menu.png)

</div>

| Option | Use |
|---|---|
| 🌍 **Language** | Switch the lab language, if multi-language support is enabled. |
| 🗑️ **Delete** | Delete the environment once your lab is complete. |
| 📋 **VM Native Clipboard** | Allows copying files within the VM. While it is on, text copied from your local PC cannot be pasted into the VM using keyboard shortcuts. You can turn it off at any time from **More (...)**. |

### 7️⃣ Lab Guide Menu

Use the tabs at the top of the lab guide to move between its sections:

<div class="psb-shot">

![Lab guide menu](./media/gs-menu.png)

</div>

| Option | Use |
|---|---|
| 📖 **Guide** | All tasks and lab information. |
| 🔑 **Environment** | AWS console credentials and lab details. |
| 📈 **Progress** | Your points for validations. |
| ⚙️ **Resources** | Start, stop or restart the lab VM. |
| ❓ **Help** | Support information. |

### 📈 Progress

The **Progress** tab shows your overall points and the status of each **Validation** check. Each lab has one validation, and its points are shown in the lab header:

<div class="psb-shot">

![Progress tab](./media/gs-progress.png)

</div>

### 🔑 Exploring Your Resources

To view your AWS console credentials and resource details, navigate to the **Environment** tab:

<div class="psb-shot">

![Environment tab](./media/gs-02.png)

</div>

### 🪟 Utilizing the Split Window Feature

For convenience, you can open the lab guide in a separate window by selecting the **Split Window** button from the top-right corner:

<div class="psb-shot">

![Split window](./media/gs-05.png)

</div>

### 🖥️ Managing Your Virtual Machine

You can start, stop or restart your virtual machine as needed from the **Resources** tab:

<div class="psb-shot">

![Resources tab](./media/gs-06.png)

</div>

### 📄 Page Navigation

Use **Previous**, the page numbers and **Next** at the bottom of the guide to move between pages:

<div class="psb-shot">

![Page navigation](./media/gs-next.png)

</div>

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #dfe5ee;border-radius:16px;padding:16px 14px;margin:18px 0;">

## ✅ Validate Your Work

Each lab ends with a **Validation Check** that checks your work. Complete all tasks in the lab, scroll to the **Validation Check** at the end of the last task, and click **Validate**:

<div class="psb-shot">

![Validate button](./media/gs-validate.png)

</div>

- On success, the status shows **Success** and the points are added to your **Progress**.
- If a check fails, read the message, fix the issue and click **Validate** again.

> 💡 **Tip:** Validate as often as you like. There is no penalty and no limit.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #dfe5ee;border-radius:16px;padding:16px 14px;margin:18px 0;">

## 🔐 Sign In to the AWS Console

**Step 1:** On the lab VM desktop, double-click the **AWS Console** shortcut, or open the sign-in URL below in the browser:

| Detail | Value |
|---|---|
| 🔗 **Sign-in URL** | <inject key="SignInUrl" enableCopy="true"/> |
| 👤 **IAM username** | <inject key="AWSUserName" enableCopy="true"/> |
| 🔒 **Password** | <inject key="AWSPassword" enableCopy="true"/> |

> 💡 **Tip:** The same credentials are also saved in the **aws credentials.txt** file on the VM desktop.

**Step 2:** Enter the **IAM username (1)** and **Password (2)**, then click **Sign in (3)**:

<div class="psb-shot">

![AWS sign-in](./media/gs-03.png)

</div>

**Step 3:** In the top-right corner of the console, open the **Region** selector and choose **<inject key="LabRegion" enableCopy="false"/>**:

<div class="psb-shot">

![Region selector](./media/gs-04.png)

</div>

> ⚠️ **Note:** Create **every** resource in **<inject key="LabRegion" enableCopy="false"/>**. The pre-provisioned resources and the validation checks only look in this region. If something "disappears" from a console page, check the region selector first.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #dfe5ee;border-radius:16px;padding:16px 14px;margin:18px 0;">

## 🔌 Connect Using RDP (Optional)

To use your own RDP client instead of the browser-based VM, connect with these details:

| Detail | Value |
|---|---|
| 💻 **Computer** | <inject key="WindowsVMPublicIP" enableCopy="true"/> |
| 👤 **Username** | <inject key="windowsvmAdminUsername" enableCopy="true"/> |
| 🔒 **Password** | <inject key="WindowsVMPassword" enableCopy="true"/> |

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #dfe5ee;border-radius:16px;padding:16px 14px;margin:18px 0;">

## 🆘 Support Contact

The CloudLabs support team is available 24/7 via email and live chat.

- 📧 **Email:** <a href="mailto:cloudlabs-support@spektrasystems.com">cloudlabs-support@spektrasystems.com</a>
- 💬 **Live chat:** <a href="https://support.cloudlabs.ai/isv">https://support.cloudlabs.ai/isv</a>


Click **Next** to begin the lab.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #dfe5ee;border-radius:16px;padding:16px 14px;margin:18px 0;">

## 🎉 Happy Learning!

</div>

</div>
