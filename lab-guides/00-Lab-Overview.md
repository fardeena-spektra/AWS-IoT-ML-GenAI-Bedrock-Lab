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
@keyframes psbHit{0%{transform:scale(1)}35%{transform:scale(1.22)}70%{transform:scale(.95)}100%{transform:scale(1)}}
.psbgs{position:relative}
/* hero */
.psbgs .psb-hero{background-size:300% 300%!important;animation:psbAurora 14s ease infinite,psbDrop .6s ease-out both;box-shadow:0 12px 32px rgba(15,27,45,.30)}
.psbgs .psb-hero::before{content:"";position:absolute;width:280px;height:280px;left:-70px;top:-100px;border-radius:50%;background:radial-gradient(closest-side,rgba(255,153,0,.38),transparent);animation:psbOrb 9s ease-in-out infinite;pointer-events:none}
.psbgs .psb-hero::after{content:"";position:absolute;inset:0;background:linear-gradient(110deg,transparent 35%,rgba(255,255,255,.12) 50%,transparent 65%);background-size:250% 100%;animation:psbSweep 6s ease-in-out infinite;pointer-events:none}
.psbgs .psb-title{font-size:1.9em!important;color:#ffffff!important}
.psbgs .psb-line{animation:psbLine 4s ease-in-out infinite}
.psbgs .psb-chip{transition:transform .2s ease;cursor:default}
.psbgs .psb-chip *{color:#ffffff!important;-webkit-text-fill-color:#ffffff!important}
.psbgs .psb-chip:hover{transform:translateY(-3px);animation:psbRGB 1.6s linear infinite}
.psbgs .psb-chip:active{animation:psbHit .3s ease,psbBurst .5s ease-out}
/* framed cards with a thick animated border */
.psbgs .psb-panel{position:relative;border:3px solid transparent!important;
  background:linear-gradient(#ffffff,#ffffff) padding-box,conic-gradient(from var(--psbA),#ff9900,#232f3e 25%,#0972d3 50%,#232f3e 75%,#ff9900) border-box!important;
  box-shadow:0 6px 20px rgba(15,27,45,.08);animation:psbRise .6s cubic-bezier(.2,.8,.2,1) both,psbSpin 10s linear infinite;transition:transform .25s ease}
.psbgs .psb-panel:nth-of-type(2){animation-delay:.08s,-1.5s}.psbgs .psb-panel:nth-of-type(3){animation-delay:.16s,-3s}.psbgs .psb-panel:nth-of-type(4){animation-delay:.24s,-4.5s}
.psbgs .psb-panel:nth-of-type(5){animation-delay:.32s,-6s}.psbgs .psb-panel:nth-of-type(6){animation-delay:.4s,-7.5s}.psbgs .psb-panel:nth-of-type(7){animation-delay:.48s,-9s}
.psbgs .psb-panel:hover{transform:translateY(-3px);animation:psbRise .6s both,psbSpin 3s linear infinite,psbRGB 2.4s linear infinite}
/* headings */
.psbgs h2{border:0!important;padding-bottom:12px!important;position:relative;color:#16191f!important;font-weight:700!important}
.psbgs h2::after{content:"";position:absolute;left:0;bottom:0;height:3px;width:100%;border-radius:3px;background:linear-gradient(90deg,#ff9900,#ffc266,#232f3e,#0972d3,#ff9900);background-size:200% 100%;animation:psbBar 4s linear infinite}
.psbgs h3{color:#232f3e!important;font-weight:700!important;margin-top:22px!important}
/* framed icons */
.psbgs .psb-ico{border:2px solid transparent!important;background:linear-gradient(#ffffff,#ffffff) padding-box,conic-gradient(from var(--psbA),#ff9900,#232f3e,#0972d3,#ff9900) border-box!important;
  animation:psbSpin 4s linear infinite;transition:transform .2s ease}
.psbgs .psb-ico:hover{transform:scale(1.15) rotate(-4deg);animation:psbSpin 1.2s linear infinite,psbRGB 1.2s linear infinite}
.psbgs .psb-ico:active{animation:psbHit .3s ease,psbBurst .5s ease-out}
/* tables */
.psbgs table{border-radius:10px;overflow:hidden;box-shadow:0 2px 10px rgba(15,27,45,.06)}
.psbgs th{color:#ffffff!important;background:#232f3e!important;border-color:#232f3e!important}
.psbgs tbody tr{transition:background .2s ease,box-shadow .2s ease}
.psbgs tbody tr:hover{background:#fff7eb!important;box-shadow:inset 4px 0 0 #ff9900}
/* tips */
.psbgs blockquote{background:#f2f8fd!important;border-left:4px solid #0972d3!important;border-radius:0 10px 10px 0;transition:transform .2s ease}
.psbgs blockquote:hover{transform:translateX(3px)}
/* screenshots: thick full animated frame, RGB glow on hover, burst on click */
.psbgs .psb-shot{position:relative;margin:16px 2px 22px;padding:4px;border-radius:14px;border:3px solid transparent;
  background:linear-gradient(#ffffff,#ffffff) padding-box,conic-gradient(from var(--psbA),#ff9900,#232f3e 25%,#0972d3 50%,#232f3e 75%,#ff9900) border-box;
  animation:psbSpin 6s linear infinite;transition:transform .25s ease}
.psbgs .psb-shot p{margin:0!important}
.psbgs .psb-shot img{display:block;max-width:100%;height:auto;margin:0 auto;border:0!important;border-radius:9px;box-shadow:none!important}
.psbgs .psb-shot:hover{transform:translateY(-3px);animation:psbSpin 2s linear infinite,psbRGB 1.8s linear infinite}
.psbgs .psb-shot:active{transform:scale(.99);animation:psbSpin 2s linear infinite,psbBurst .55s ease-out}
/* links */
.psbgs a{color:#0972d3!important;font-weight:600;transition:color .2s ease}
.psbgs a:hover{color:#ec7211!important}
.psbgs a:active{display:inline-block;animation:psbHit .3s ease}
/* CloudLabs inject values and copy buttons */
.psbgs td [class]:not([class^=psb]),.psbgs p [class]:not([class^=psb]),.psbgs li [class]:not([class^=psb]){color:#0972d3!important;-webkit-text-fill-color:#0972d3!important;font-weight:600}
.psbgs td img:not([class^=psb]),.psbgs td svg,.psbgs td i,.psbgs td button,.psbgs [class*=copy],.psbgs [class*=Copy],.psbgs [title*=opy]{cursor:pointer;border-radius:6px;transition:transform .15s ease}
.psbgs td img:not([class^=psb]):hover,.psbgs td svg:hover,.psbgs td i:hover,.psbgs td button:hover,.psbgs [class*=copy]:hover,.psbgs [class*=Copy]:hover,.psbgs [title*=opy]:hover{transform:scale(1.2);animation:psbRGB 1.2s linear infinite}
.psbgs td img:not([class^=psb]):active,.psbgs td svg:active,.psbgs td i:active,.psbgs td button:active,.psbgs [class*=copy]:active,.psbgs [class*=Copy]:active,.psbgs [title*=opy]:active{animation:psbHit .3s ease,psbBurst .5s ease-out}
@media (prefers-reduced-motion:reduce){.psbgs *,.psbgs *::before,.psbgs *::after{animation:none!important;transition:none!important}}
</style>

<div class="psbgs" style="background:linear-gradient(180deg,#f7f9fc 0%,#eef3f9 100%);border:1px solid #e3e9f1;border-radius:20px;padding:14px 10px 22px;margin:0 -20px;">

<div class="psb-hero" style="position:relative;overflow:hidden;border-radius:18px;padding:30px 20px 26px;margin:0 0 6px;text-align:center;color:#ffffff;background:linear-gradient(120deg,#161e2d,#232f3e,#1b3a5c,#232f3e);">
<div class="psb-badge" style="display:inline-block;padding:4px 14px;border-radius:999px;background:rgba(255,153,0,.16);border:1px solid rgba(255,153,0,.6);color:#ffb84d;font-weight:700;letter-spacing:.14em;font-size:.76em;">LAB OVERVIEW</div>
<h1 class="psb-title" style="color:#ffffff;margin:14px 0 6px;border:0;line-height:1.25;">Building an End-to-End IoT, Machine Learning and Generative AI Solution on AWS</h1>
<div class="psb-sub" style="color:#d5dbe3;font-weight:600;">AWS Demo || Bedrock with Claude</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 8px;border-radius:3px;background:#ff9900;"></div>
<div class="psb-chips" style="margin-top:8px;">
<span class="psb-chip" style="display:inline-block;margin:4px;padding:7px 14px;border-radius:999px;background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.30);color:#ffffff;font-weight:600;">⏱️ 8 Hours 10 Minutes</span>
<span class="psb-chip" style="display:inline-block;margin:4px;padding:7px 14px;border-radius:999px;background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.30);color:#ffffff;font-weight:600;">🏆 100 Points</span>
<span class="psb-chip" style="display:inline-block;margin:4px;padding:7px 14px;border-radius:999px;background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.30);color:#ffffff;font-weight:600;">🧩 9 Labs</span>
<span class="psb-chip" style="display:inline-block;margin:4px;padding:7px 14px;border-radius:999px;background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.30);color:#ffffff;font-weight:600;">🌍 <inject key="LabRegion" enableCopy="false"/></span>
</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>About This Lab

In this hands-on lab, you build a complete **IoT to machine learning to generative AI** solution on AWS.

A simulated sensor device streams telemetry (temperature, humidity, CO₂ and vibration) into **AWS IoT Core**. The data is stored in **Amazon Timestream for InfluxDB** and **Amazon S3**, served through **AWS Lambda** and **Amazon API Gateway**, secured with **Amazon Cognito**, and shown on a dashboard hosted on **AWS Amplify**. You then train an anomaly detection model with **Amazon SageMaker AI**, score live data automatically, and finish with a natural language assistant powered by **Amazon Bedrock**.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧭</span>Lab Phases

| Phase | Labs | Focus |
|---|---|---|
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔌</span>**Phase I** | Labs 01 to 05 | Connect, ingest and serve: AWS IoT Core, Amazon Timestream for InfluxDB, Amazon S3, AWS Lambda, Amazon API Gateway, Amazon Cognito, AWS Amplify |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧠</span>**Phase II** | Labs 06 to 07 | Machine learning: Amazon SageMaker AI Random Cut Forest model and an automated scoring pipeline |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🤖</span>**Phase III** | Labs 08 to 09 | Generative AI and operations: Amazon Bedrock assistant, Amazon CloudWatch monitoring and teardown |

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🗺️</span>Labs Overview

| Lab | Title | Phase | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">⏱️</span>Timing | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🏆</span>Points |
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

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🏗️</span>Solution Architecture

The diagram below shows how the services connect across the three phases:

<div class="psb-shot">

![Solution architecture](./media/architecture.png)

</div>

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">☁️</span>AWS Services Used

| Service | Used for |
|---|---|
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AWSIoTCore.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **AWS IoT Core** | Device identity (X.509), MQTT messaging and the Rules Engine |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonTimestream.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon Timestream for InfluxDB** | Time series storage for telemetry and anomaly scores |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonSimpleStorageService.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon S3** | Raw telemetry archive, training data and scored results |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AWSLambda.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **AWS Lambda** | Ingest, query, scoring and assistant functions |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AWSSecretsManager.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **AWS Secrets Manager** | Stores the InfluxDB admin token |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonAPIGateway.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon API Gateway** | HTTP API for telemetry, anomalies and the assistant |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonCognito.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon Cognito** | User sign-in and JWT authorization |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AWSAmplify.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **AWS Amplify Hosting** | Hosts the React dashboard |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonSageMakerAI.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon SageMaker AI** | Trains and serves the Random Cut Forest model |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonEventBridge.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon EventBridge** | Runs the scoring function every 5 minutes |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonBedrock.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon Bedrock** | Natural language assistant with tool use |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AmazonCloudWatch.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **Amazon CloudWatch** | Logs, metric filter and pipeline alarm |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;"><img class="psb-svc" src="https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/media/icons/AWSIdentityandAccessManagement.png" alt="" width="24" height="24" style="width:24px;height:24px;border-radius:4px;"></span> **AWS IAM** | Least-privilege roles and policies |

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📦</span>Pre-provisioned Resources

The following resources are already created for you. You do **not** need to create them.

| Resource | Name / Value |
|---|---|
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🌍</span>**Region** | <inject key="LabRegion" enableCopy="true"/> |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🪣</span>**Amazon S3 bucket** (empty) | <inject key="LabBucketName" enableCopy="true"/> |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧪</span>**Amazon SageMaker AI domain** | <inject key="SageMakerDomainName" enableCopy="true"/> |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">👤</span>**SageMaker AI user profile** | **psb-lab-user** |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔑</span>**SageMaker AI execution role** | **psb-lab-sagemaker-exec-<inject key="DeploymentID" enableCopy="false"/>** (read and write access to the lab bucket) |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">💻</span>**Lab VM (Amazon EC2)** | **windowsvm-<inject key="DeploymentID" enableCopy="false"/>** (t3.medium) |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧰</span>**VM tooling** | Chrome, Edge, VS Code, AWS CLI v2, Python 3.12, Node.js LTS, Git |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📁</span>**Lab assets** | **C:\psb-lab-assets** and the desktop shortcut **psb-lab-assets** |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📄</span>**Desktop files** | **aws credentials.txt** and the **AWS Console** shortcut |

> <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">ℹ️</span>**Info:** In Lab 02 you create the **raw/**, **curated/** and **model/** folders in the S3 bucket. In Lab 06 you create the SageMaker AI space **psb-lab-space**.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📁</span>Lab Assets Folder

The **psb-lab-assets** folder on the desktop (**C:\psb-lab-assets**) contains everything you need:

| Folder / File | Contents |
|---|---|
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🛰️</span>**simulator** | **simulate_pi.py** device simulator, **requirements.txt** and the **certs** folder (device certificates go here in Lab 01) |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">⚡</span>**lambdas** | Code for the four AWS Lambda functions: **psb-ingest-telemetry**, **psb-query-telemetry**, **psb-score-telemetry** and **psb-assistant** |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧪</span>**test-events** | **sample-reading.json**, **direct-query.json**, **manual-run.json** and **ask-question.json** |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔐</span>**policies** | IAM and AWS IoT policy documents used in the labs |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📊</span>**dashboard** | React dashboard source (Vite + React 18) and the prebuilt fallback **dist.zip** |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📓</span>**notebook** | Amazon SageMaker AI notebook **psb-anomaly-detection.ipynb** |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>**README.txt** | Short description of the folder |

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🤖</span>About Amazon Bedrock and Claude

> <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">ℹ️</span>**Info:** The lab title refers to **Claude**. The assistant you build in Lab 08 uses **Amazon Nova Lite** (inference profile **apac.amazon.nova-lite-v1:0**) through the Amazon Bedrock **Converse API**. You can switch to an Anthropic Claude model by changing the **MODEL_ID** environment variable of the assistant function and the model ARNs in its IAM policy. No code change is needed.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">✅</span>Ready to Start

Click **Next** to begin **Lab 01: IoT Identity and Device Simulator**.

</div>

</div>
