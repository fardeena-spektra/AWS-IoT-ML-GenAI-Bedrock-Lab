<style>
@property --psbA{syntax:'<angle>';inherits:false;initial-value:0deg}
@keyframes psbAurora{0%{background-position:0% 50%}50%{background-position:100% 50%}100%{background-position:0% 50%}}
@keyframes psbShine{0%{background-position:-200% 0}60%,100%{background-position:200% 0}}
@keyframes psbFloat{0%{transform:translateY(0) rotate(0)}100%{transform:translateY(-140px) rotate(25deg)}}
@keyframes psbDrop{0%{opacity:0;transform:translateY(-14px) scale(.96)}100%{opacity:1;transform:none}}
@keyframes psbRise{0%{opacity:0;transform:translateY(22px) scale(.98)}100%{opacity:1;transform:none}}
@keyframes psbSpin{to{--psbA:360deg}}
@keyframes psbPulse{0%,100%{box-shadow:0 6px 18px rgba(123,92,255,.10)}50%{box-shadow:0 10px 34px rgba(255,61,119,.22)}}
@keyframes psbCorner{0%,100%{width:22px;height:22px;filter:drop-shadow(0 0 0 transparent)}50%{width:48px;height:48px;filter:drop-shadow(0 0 6px currentColor)}}
@keyframes psbHit{0%{transform:scale(1)}30%{transform:scale(1.35)}60%{transform:scale(.9)}100%{transform:scale(1)}}
@keyframes psbWave{0%{box-shadow:0 0 0 0 rgba(255,61,119,.75)}100%{box-shadow:0 0 0 18px rgba(255,61,119,0)}}
@keyframes psbChip{0%,100%{transform:translateY(0)}50%{transform:translateY(-3px)}}
@keyframes psbGlow{0%,100%{text-shadow:0 0 8px rgba(255,255,255,.35),0 2px 10px rgba(80,20,120,.35)}50%{text-shadow:0 0 22px rgba(255,255,255,.95),0 0 40px rgba(255,214,120,.7)}}
@keyframes psbBar{0%{background-position:0% 0}100%{background-position:200% 0}}

.psbgs{position:relative}
/* hero */
.psbgs .psb-hero{background-size:300% 300%!important;animation:psbAurora 10s ease infinite,psbDrop .7s ease-out both;box-shadow:0 14px 40px rgba(123,92,255,.35)}
.psbgs .psb-hero::after{content:"";position:absolute;inset:0;background:linear-gradient(115deg,transparent 30%,rgba(255,255,255,.35) 50%,transparent 70%);background-size:200% 100%;animation:psbShine 4.5s ease-in-out infinite;pointer-events:none}
.psbgs .psb-title{font-size:2.1em!important;color:#ffffff!important;animation:psbGlow 3s ease-in-out infinite}
.psbgs .psb-chip{animation:psbChip 3s ease-in-out infinite;backdrop-filter:blur(4px);border:1px solid rgba(255,255,255,.45);transition:transform .2s ease,background .2s ease}
.psbgs .psb-chip:nth-child(2){animation-delay:-.75s}.psbgs .psb-chip:nth-child(3){animation-delay:-1.5s}.psbgs .psb-chip:nth-child(4){animation-delay:-2.25s}
.psbgs .psb-chip:hover{background:rgba(255,255,255,.38)!important;transform:translateY(-4px) scale(1.06)}
.psbgs .psb-chip:active{animation:psbHit .35s ease}
.psbgs .psb-sparks,.psbgs .psb-sparks::before,.psbgs .psb-sparks::after{position:absolute;left:0;top:100%;width:6px;height:6px;border-radius:50%;background:#fff;pointer-events:none;
  box-shadow:40px 10px 0 -1px rgba(255,255,255,.9),120px 40px 0 -2px rgba(255,255,255,.7),210px 0 0 0 rgba(255,255,255,.8),300px 30px 0 -2px rgba(255,255,255,.6),380px 15px 0 -1px rgba(255,255,255,.9),460px 45px 0 -2px rgba(255,255,255,.7),540px 5px 0 0 rgba(255,255,255,.8);
  animation:psbFloat 6s linear infinite;opacity:.8}
.psbgs .psb-sparks::before{content:"";top:30px;left:20px;animation-duration:8s;opacity:.6}
.psbgs .psb-sparks::after{content:"";top:60px;left:70px;animation-duration:10s;opacity:.5}

/* cards: slide in one after another, rotating neon border */
.psbgs .psb-panel{position:relative;background:linear-gradient(#fff,#fff) padding-box,conic-gradient(from var(--psbA),#ff7a18,#ff3d77,#7b5cff,#00c2ff,#ff7a18) border-box!important;border:2px solid transparent!important;
  animation:psbRise .7s cubic-bezier(.2,.8,.2,1) both,psbSpin 8s linear infinite,psbPulse 6s ease-in-out infinite;transition:transform .25s ease}
.psbgs .psb-panel:nth-of-type(2){animation-delay:.1s,0s,0s}.psbgs .psb-panel:nth-of-type(3){animation-delay:.2s,-1s,-1s}.psbgs .psb-panel:nth-of-type(4){animation-delay:.3s,-2s,-2s}
.psbgs .psb-panel:nth-of-type(5){animation-delay:.4s,-3s,-3s}.psbgs .psb-panel:nth-of-type(6){animation-delay:.5s,-4s,-4s}.psbgs .psb-panel:nth-of-type(7){animation-delay:.6s,-5s,-5s}
.psbgs .psb-panel:hover{transform:translateY(-3px)}
/* headings */
.psbgs h2{border:0!important;padding-bottom:10px!important;position:relative;color:#4c1d95!important;font-weight:700!important;text-shadow:0 1px 0 rgba(255,255,255,.8)}
.psbgs h2::after{content:"";position:absolute;left:0;bottom:0;height:3px;width:100%;border-radius:3px;background:linear-gradient(90deg,#ff7a18,#ff3d77,#7b5cff,#00c2ff,#ff7a18);background-size:200% 100%;animation:psbBar 3s linear infinite}
.psbgs h3{color:#2a1f5c!important;font-weight:700!important}
/* tables */
.psbgs table{border-radius:12px;overflow:hidden;box-shadow:0 4px 16px rgba(123,92,255,.08)}
.psbgs th{color:#ffffff!important;background:linear-gradient(90deg,#ff7a18,#ff3d77,#7b5cff)!important;border-color:transparent!important}
.psbgs td{transition:background .2s ease}
.psbgs tbody tr{transition:transform .2s ease,box-shadow .2s ease}
.psbgs tbody tr:hover{background:linear-gradient(90deg,rgba(255,122,24,.08),rgba(123,92,255,.08))!important;box-shadow:inset 4px 0 0 #ff3d77}
/* tips */
.psbgs blockquote{background:linear-gradient(90deg,rgba(0,194,255,.10),rgba(123,92,255,.06))!important;border-left:4px solid #7b5cff!important;border-radius:0 12px 12px 0;transition:transform .2s ease}
.psbgs blockquote:hover{transform:translateX(4px)}
/* code */
.psbgs pre{background:#14102b!important;border-radius:14px;padding:14px!important;overflow-x:auto!important;max-width:100%;box-shadow:0 0 0 1px #2e2563,0 8px 24px rgba(20,16,43,.35)}
.psbgs pre,.psbgs pre code{color:#a8f0ff!important;background:#14102b!important}
/* screenshots: neon brackets, hover zoom, click hit */
.psbgs .psb-shot{position:relative;margin:14px 4px 22px;padding:8px;border-radius:14px;background:#faf8ff;border:1px solid #ece7ff;transition:transform .25s ease,box-shadow .25s ease}
.psbgs .psb-shot p{margin:0!important}
.psbgs .psb-shot::before,.psbgs .psb-shot::after{content:"";position:absolute;pointer-events:none;animation:psbCorner 2.6s ease-in-out infinite}
.psbgs .psb-shot::before{top:-3px;left:-3px;color:#ff3d77;border-top:3px solid #ff3d77;border-left:3px solid #ff3d77;border-top-left-radius:14px}
.psbgs .psb-shot::after{bottom:-3px;right:-3px;color:#00c2ff;border-bottom:3px solid #00c2ff;border-right:3px solid #00c2ff;border-bottom-right-radius:14px;animation-delay:-1.3s}
.psbgs .psb-shot img{display:block;max-width:100%;height:auto;margin:0 auto;border-radius:9px}
.psbgs .psb-shot:hover{transform:translateY(-3px) scale(1.01);box-shadow:0 14px 34px rgba(123,92,255,.25)}
.psbgs .psb-shot:active{animation:psbWave .45s ease-out;transform:scale(.985)}
/* links */
.psbgs a{color:#7b5cff!important;font-weight:600;transition:color .2s ease}
.psbgs a:hover{color:#ff3d77!important}
.psbgs a:active{display:inline-block;animation:psbHit .35s ease}
/* CloudLabs inject values + copy buttons: vivid, with a hit effect on click */
.psbgs [class]:not([class^=psb]):not([class*=language]):not(code){color:#d6336c!important;-webkit-text-fill-color:#d6336c!important;font-weight:600}
.psbgs img:not([src*="media/"]),.psbgs svg,.psbgs i,.psbgs button,.psbgs [class*=copy],.psbgs [class*=Copy],.psbgs [title*=opy]{cursor:pointer;border-radius:6px;transition:transform .15s ease,filter .15s ease}
.psbgs img:not([src*="media/"]):hover,.psbgs svg:hover,.psbgs i:hover,.psbgs button:hover,.psbgs [class*=copy]:hover,.psbgs [class*=Copy]:hover,.psbgs [title*=opy]:hover{transform:scale(1.2) rotate(-6deg);filter:drop-shadow(0 0 5px rgba(255,61,119,.7))}
.psbgs img:not([src*="media/"]):active,.psbgs svg:active,.psbgs i:active,.psbgs button:active,.psbgs [class*=copy]:active,.psbgs [class*=Copy]:active,.psbgs [title*=opy]:active{animation:psbHit .35s ease,psbWave .45s ease-out;filter:drop-shadow(0 0 10px rgba(255,61,119,1))}
@media (prefers-reduced-motion:reduce){.psbgs *,.psbgs *::before,.psbgs *::after{animation:none!important;transition:none!important}}
</style>

<div class="psbgs" style="background:linear-gradient(180deg,#fff7f2 0%,#f7f4ff 45%,#f0fbff 100%);border:1px solid #ece7ff;border-radius:20px;padding:14px 10px 22px;margin:0 -20px;">

<div class="psb-hero" style="position:relative;overflow:hidden;border-radius:20px;padding:30px 18px 26px;margin:0 0 18px;text-align:center;color:#ffffff;background:linear-gradient(120deg,#ff7a18,#ff3d77,#7b5cff,#00c2ff);">
<div class="psb-sparks"></div>
<div class="psb-badge" style="display:inline-block;padding:4px 12px;border-radius:999px;background:rgba(255,255,255,.22);color:#ffffff;font-weight:700;letter-spacing:.12em;font-size:.78em;">🎮 MISSION BRIEFING</div>
<h1 class="psb-title" style="color:#ffffff;margin:12px 0 4px;border:0;">🚀 Getting Started</h1>
<div class="psb-sub" style="color:#ffffff;font-weight:600;opacity:.95;">AWS Demo || Bedrock with Claude</div>
<div class="psb-chips" style="margin-top:16px;">
<span class="psb-chip" style="display:inline-block;margin:4px;padding:6px 12px;border-radius:999px;background:rgba(255,255,255,.2);color:#ffffff;font-weight:600;">⏱️ 8 Hours 10 Minutes</span>
<span class="psb-chip" style="display:inline-block;margin:4px;padding:6px 12px;border-radius:999px;background:rgba(255,255,255,.2);color:#ffffff;font-weight:600;">🏆 100 Points</span>
<span class="psb-chip" style="display:inline-block;margin:4px;padding:6px 12px;border-radius:999px;background:rgba(255,255,255,.2);color:#ffffff;font-weight:600;">🧩 9 Labs</span>
<span class="psb-chip" style="display:inline-block;margin:4px;padding:6px 12px;border-radius:999px;background:rgba(255,255,255,.2);color:#ffffff;font-weight:600;">🌏 Singapore</span>
</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:2px solid #ece7ff;border-radius:18px;padding:16px 14px;margin:18px 0;">

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

```text
Sensor simulator (VM) ──MQTT/TLS──> AWS IoT Core ──Rule──> Lambda ──> Timestream for InfluxDB
                                                   └──────> Amazon S3 (raw/)
InfluxDB ──> Query Lambda ──> API Gateway (Cognito JWT) ──> Amplify dashboard
S3 raw/ ──> SageMaker RCF model ──> Serverless endpoint <── Score Lambda (every 5 min)
Dashboard chat ──> Assistant Lambda ──> Amazon Bedrock (Converse API + tool use)
```

</div>

<div class="psb-panel" style="background:#ffffff;border:2px solid #ece7ff;border-radius:18px;padding:16px 14px;margin:18px 0;">

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
| 🌍 **Region** | <inject key="LabRegion" enableCopy="true"/> (Asia Pacific (Singapore)) |
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
| 🛰️ **simulator\\** | **simulate_pi.py** device simulator, **requirements.txt**, and **certs\\** (device certificates go here in Lab 01) |
| ⚡ **lambdas\\** | The 4 Lambda functions: **psb-ingest-telemetry**, **psb-query-telemetry**, **psb-score-telemetry**, **psb-assistant** (each with **lambda_function.py**) |
| 🧪 **test-events\\** | **sample-reading.json**, **direct-query.json**, **manual-run.json**, **ask-question.json** |
| 🔐 **policies\\** | IAM and IoT policy files (device policy, IoT rule trust and S3 write, Influx token read, score policy, assistant policy) |
| 📊 **dashboard\\** | React dashboard source (Vite + React 18) and prebuilt fallback **dist.zip** |
| 📓 **notebook\\** | SageMaker notebook **psb-anomaly-detection.ipynb** |
| 📝 **README.txt** | Short description of the folder |

### 🤖 About Bedrock and Claude

> ℹ️ **Info:** The lab title says **Claude**. The assistant you build in Lab 08 uses **Amazon Nova Lite** (APAC inference profile **apac.amazon.nova-lite-v1:0**) through the same Amazon Bedrock **Converse API**. Claude models can be swapped in by changing the **MODEL_ID** environment variable of the assistant Lambda function (and the model ARNs in its IAM policy). No code change is needed.

</div>

<div class="psb-panel" style="background:#ffffff;border:2px solid #ece7ff;border-radius:18px;padding:16px 14px;margin:18px 0;">

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

<div class="psb-panel" style="background:#ffffff;border:2px solid #ece7ff;border-radius:18px;padding:16px 14px;margin:18px 0;">

## ✅ Validate Your Work

Each lab ends with a **Validation Check** that checks your work. Complete all tasks in the lab, scroll to the **Validation Check** at the end of the last task, and click **Validate**:

<div class="psb-shot">

![Validate button](./media/gs-validate.png)

</div>

- On success, the status shows **Success** and the points are added to your **Progress**.
- If a check fails, read the message, fix the issue and click **Validate** again.

> 💡 **Tip:** Validate as often as you like. There is no penalty and no limit.

</div>

<div class="psb-panel" style="background:#ffffff;border:2px solid #ece7ff;border-radius:18px;padding:16px 14px;margin:18px 0;">

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

**Step 3:** In the top-right corner of the console, open the **Region** selector and choose **Asia Pacific (Singapore) ap-southeast-1**:

<div class="psb-shot">

![Region selector](./media/gs-04.png)

</div>

> ⚠️ **Note:** Create **every** resource in **Asia Pacific (Singapore) ap-southeast-1**. The pre-provisioned resources and the validation checks only look in this region. If something "disappears" from a console page, check the region selector first.

</div>

<div class="psb-panel" style="background:#ffffff;border:2px solid #ece7ff;border-radius:18px;padding:16px 14px;margin:18px 0;">

## 🔌 Connect Using RDP (Optional)

To use your own RDP client instead of the browser-based VM, connect with these details:

| Detail | Value |
|---|---|
| 💻 **Computer** | <inject key="WindowsVMPublicIP" enableCopy="true"/> |
| 👤 **Username** | <inject key="windowsvmAdminUsername" enableCopy="true"/> |
| 🔒 **Password** | <inject key="WindowsVMPassword" enableCopy="true"/> |

</div>

<div class="psb-panel" style="background:#ffffff;border:2px solid #ece7ff;border-radius:18px;padding:16px 14px;margin:18px 0;">

## 🆘 Support Contact

The CloudLabs support team is available 24/7 via email and live chat.

- 📧 **Email:** <a href="mailto:cloudlabs-support@spektrasystems.com">cloudlabs-support@spektrasystems.com</a>
- 💬 **Live chat:** <a href="https://support.cloudlabs.ai/isv">https://support.cloudlabs.ai/isv</a>


Click **Next** to begin the lab.

</div>

<div class="psb-panel" style="background:#ffffff;border:2px solid #ece7ff;border-radius:18px;padding:16px 14px;margin:18px 0;">

## 🎉 Happy Learning!

</div>

</div>
