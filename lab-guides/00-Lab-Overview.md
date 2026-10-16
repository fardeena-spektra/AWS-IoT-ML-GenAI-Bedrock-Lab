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
.psbgs li pre,.psbgs li div:has(> pre),.psbgs li div:has(> div > pre){margin-left:0!important;margin-right:0!important;width:auto!important;max-width:100%!important;box-sizing:border-box}
.psbgs div:has(> pre){margin-left:0!important;margin-right:0!important}
.psbgs td img:not([class^=psb]),.psbgs td svg,.psbgs td i,.psbgs td button,.psbgs [class*=copy],.psbgs [class*=Copy],.psbgs [title*=opy]{cursor:pointer;border-radius:6px;transition:transform .15s ease}
.psbgs td img:not([class^=psb]):hover,.psbgs td svg:hover,.psbgs td i:hover,.psbgs td button:hover,.psbgs [class*=copy]:hover,.psbgs [class*=Copy]:hover,.psbgs [title*=opy]:hover{transform:scale(1.2);animation:psbRGB 1.2s linear infinite}
.psbgs td img:not([class^=psb]):active,.psbgs td svg:active,.psbgs td i:active,.psbgs td button:active,.psbgs [class*=copy]:active,.psbgs [class*=Copy]:active,.psbgs [title*=opy]:active{animation:psbHit .3s ease,psbBurst .5s ease-out}
@media (prefers-reduced-motion:reduce){.psbgs *,.psbgs *::before,.psbgs *::after{animation:none!important;transition:none!important}}
</style>

<div class="psbgs">

<div class="psb-hero" style="position:relative;overflow:hidden;border-radius:16px;padding:28px 20px 24px;margin:0 0 6px;text-align:center;color:#ffffff;background:linear-gradient(120deg,#070b1a,#121a3a,#0d2b36,#16123a);">
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Building an End-to-End IoT, Machine Learning and Generative AI Solution on AWS</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-sub" style="color:#f2cc6b;font-weight:700;letter-spacing:.08em;text-align:center;">Lab Overview</div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">8 Hours 10 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;100 Points&nbsp;&nbsp;|&nbsp;&nbsp;9 Labs</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>About This Lab

You build an end-to-end solution on AWS: a simulated sensor streams telemetry (temperature, humidity, CO₂, vibration) into **AWS IoT Core**, the data is stored in **Amazon Timestream for InfluxDB** and **Amazon S3**, served through **AWS Lambda** and **Amazon API Gateway**, secured with **Amazon Cognito** and shown on an **AWS Amplify** dashboard. You then detect anomalies with **Amazon SageMaker AI** and add a natural language assistant with **Amazon Bedrock**.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🗺️</span>Labs

| Lab | Title | Phase | Timing | Points |
|:---:|---|:---:|:---:|:---:|
| 01 | IoT Identity and Device Simulator | I | 45 min | 10 |
| 02 | Rules Engine to InfluxDB and Amazon S3 | I | 65 min | 16 |
| 03 | Query Lambda and HTTP API | I | 55 min | 10 |
| 04 | Amazon Cognito Authentication | I | 40 min | 10 |
| 05 | AWS Amplify Dashboard | I | 45 min | 9 |
| 06 | Amazon SageMaker AI Anomaly Model | II | 70 min | 15 |
| 07 | Automated Scoring Pipeline | II | 50 min | 12 |
| 08 | Amazon Bedrock Assistant | III | 60 min | 13 |
| 09 | Observability and Teardown | III | 40 min | 5 |
| | **Total** | | **8 h 10 min** | **100** |

**Phase I:** connect, ingest and serve. **Phase II:** machine learning. **Phase III:** generative AI and operations.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🏗️</span>Solution Architecture

<div class="psb-shot">

![Solution architecture](./media/architecture.png)

</div>

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">☁️</span>AWS Services

| Service | Used for |
|---|---|
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AWSIoTCore.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **AWS IoT Core** | Device identity, MQTT and the Rules Engine |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonTimestream.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon Timestream for InfluxDB** | Telemetry and anomaly scores |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonSimpleStorageService.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon S3** | Raw data, training data and results |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AWSLambda.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **AWS Lambda** | Ingest, query, scoring and assistant functions |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AWSSecretsManager.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **AWS Secrets Manager** | InfluxDB token |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonAPIGateway.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon API Gateway** | HTTP API |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonCognito.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon Cognito** | Sign-in and JWT authorization |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AWSAmplify.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **AWS Amplify Hosting** | Dashboard hosting |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonSageMakerAI.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon SageMaker AI** | Random Cut Forest model and endpoint |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonEventBridge.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon EventBridge** | Scoring schedule (every 5 minutes) |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonBedrock.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon Bedrock** | Assistant with tool use |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonCloudWatch.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon CloudWatch** | Logs, metric filter and alarm |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AWSIdentityandAccessManagement.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **AWS IAM** | Least-privilege roles and policies |

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📦</span>Pre-provisioned Resources

These are already created for you:

| Resource | Name / Value |
|---|---|
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🌍</span>**Region** | <inject key="LabRegion" enableCopy="true"/> |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🪣</span>**Amazon S3 bucket** (empty) | <inject key="LabBucketName" enableCopy="true"/> |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧪</span>**Amazon SageMaker AI domain** | <inject key="SageMakerDomainName" enableCopy="true"/> |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">👤</span>**SageMaker AI user profile** | **psb-lab-user** |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔑</span>**SageMaker AI execution role** | **psb-lab-sagemaker-exec-<inject key="DeploymentID" enableCopy="false"/>** (read/write on the lab bucket) |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">💻</span>**Lab VM** | **windowsvm-<inject key="DeploymentID" enableCopy="false"/>** with Chrome, Edge, VS Code, AWS CLI v2, Python 3.12, Node.js LTS and Git |

> ℹ️ **Info:** You create the **raw/**, **curated/** and **model/** folders in Lab 02, and the SageMaker AI space **psb-lab-space** in Lab 06.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📁</span>Lab Assets (C:\psb-lab-assets)

Also available from the **psb-lab-assets** desktop shortcut:

| Folder | Contents |
|---|---|
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🛰️</span>**simulator** | **simulate_pi.py**, **requirements.txt** and **certs** (device certificates, Lab 01) |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">⚡</span>**lambdas** | Code for **psb-ingest-telemetry**, **psb-query-telemetry**, **psb-score-telemetry** and **psb-assistant** |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧪</span>**test-events** | **sample-reading**, **direct-query**, **manual-run** and **ask-question** JSON events |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔐</span>**policies** | IAM and AWS IoT policy documents |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📊</span>**dashboard** | React dashboard source and prebuilt **dist.zip** |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📓</span>**notebook** | **psb-anomaly-detection.ipynb** for SageMaker AI |

> ℹ️ **Info:** The assistant in Lab 08 uses **Amazon Nova Lite** (**apac.amazon.nova-lite-v1:0**) through the Bedrock **Converse API**. To use an Anthropic Claude model instead, change **MODEL_ID** and the model ARNs in the IAM policy.

Click **Next** to begin **Lab 01**.

</div>

</div>
