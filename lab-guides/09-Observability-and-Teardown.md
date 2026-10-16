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
/* inject values stay on one line, no extra space around them */
.psbgs p [class]:not([class^=psb]):not(pre):not(code):not(pre *):not(code *):not(:has(pre)),.psbgs li [class]:not([class^=psb]):not(pre):not(code):not(pre *):not(code *):not(:has(pre)),.psbgs td [class]:not([class^=psb]):not(pre):not(code):not(pre *):not(code *):not(:has(pre)){white-space:nowrap!important;margin:0!important;padding:0!important;min-width:0!important;width:auto!important;letter-spacing:normal!important;word-break:normal!important;overflow-wrap:normal!important}
.psbgs p [class*=copy],.psbgs li [class*=copy],.psbgs td [class*=copy],.psbgs p [class*=Copy],.psbgs li [class*=Copy],.psbgs td [class*=Copy]{margin-left:3px!important}
@media (prefers-reduced-motion:reduce){.psbgs *,.psbgs *::before,.psbgs *::after{animation:none!important;transition:none!important}}
</style>

<div class="psbgs">

<div class="psb-hero" style="position:relative;overflow:hidden;border-radius:16px;padding:28px 20px 24px;margin:0 0 6px;text-align:center;color:#ffffff;background:linear-gradient(120deg,#070b1a,#121a3a,#0d2b36,#16123a);">
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 09: Observability, Secrets Hygiene and Cost Control</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">40 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;5 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

The solution works. In this final lab you will make it operable.

You will set log retention so your CloudWatch bill does not grow forever, create a metric filter and alarm that fires on sustained high temperature, review what AWS Secrets Manager actually bought you, and, most importantly, delete the two resources that keep billing after the lab ends.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Lab Objectives

You will be able to complete the following tasks:

- Task 1: Apply log retention and create an anomaly alarm
- Task 2: Review secrets and network posture
- Task 3: Cost review and teardown

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Apply Log Retention and Create an Anomaly Alarm

1. In the AWS Management Console search bar, type **CloudWatch** and select **CloudWatch**.

1. In the left-hand navigation pane, expand **Logs** and click **Log groups**.

1. In the filter box, type **psb**. You should see four log groups:

   ```text
   /aws/lambda/psb-ingest-telemetry
   /aws/lambda/psb-query-telemetry
   /aws/lambda/psb-score-telemetry
   /aws/lambda/psb-assistant
   ```

1. Select all four checkboxes, click **Actions**, and choose **Edit retention setting(s)**.

1. Set **Retention setting** to **1 week** and click **Save**.

   > **Why this matters.** A CloudWatch log group defaults to **Never expire**. Ingestion in **<inject key="LabRegion" enableCopy="false"/>** costs USD 0.70 per GB and storage USD 0.03 per GB-month, forever. A chatty Lambda in a long-running account is one of the most common sources of quiet, compounding cost, and nobody notices, because it never appears as a spike.

1. Now create a metric filter that counts high-temperature readings. Click the log group **/aws/lambda/psb-ingest-telemetry**.

1. Select the **Metric filters** tab and click **Create metric filter**.

1. Configure the filter pattern. The ingest function logs each written line, so you can match on the measurement text:

   | Field | Value |
   |---|---|
   | Filter pattern | **[level="[ok]", ..., temp_field]** |

   Click **Next**.

   > **Note:** CloudWatch Logs filter patterns are not regular expressions. For structured JSON logs you would use a JSON pattern such as `{ $.temperature_c > 30 }`. Because this function logs plain text, a simpler and more robust approach for the lab is to alarm on the scoring function's flagged count instead, which is what the next steps do. Click **Cancel** and continue with step 9.

1. Return to **Log groups** and click **/aws/lambda/psb-score-telemetry**.

1. Select the **Metric filters** tab and click **Create metric filter**.

1. Configure:

   | Field | Value |
   |---|---|
   | Filter pattern | **"[ok] scored="** |

   Click **Next**.

   > **Note:** The quotation marks matter. A bare `[ok, scored, flagged]` would be a space-delimited pattern, which declares three positional fields and matches on token count rather than content; it would not do what its name suggests. A quoted string is a literal substring match against the whole log line, which is exactly what you want here: it fires once per successful scoring run and never on a failure.

1. On the **Assign metric** page:

   | Field | Value |
   |---|---|
   | Filter name | **psb-lab-anomaly-batches** |
   | Metric namespace | **PSBLab** |
   | Metric name | **AnomalyBatches** |
   | Metric value | **1** |
   | Default value | **0** |
   | Unit | **Count** |

   Click **Next**, then **Create metric filter**.

1. Now create the alarm. In the left-hand navigation pane, expand **Alarms** and click **All alarms**, then click **Create alarm**.

1. Click **Select metric**, choose the **PSBLab** namespace, select **AnomalyBatches**, and click **Select metric**.

1. Configure the metric and conditions:

   | Field | Value |
   |---|---|
   | Statistic | **Sum** |
   | Period | **5 minutes** |
   | Threshold type | **Static** |
   | Whenever AnomalyBatches is… | **Lower/Equal** than **0** |
   | Datapoints to alarm | **3** out of **3** |
   | Missing data treatment | **Treat missing data as bad (breaching)** |

   Click **Next**.

   > **Note:** This alarm fires when the scoring function stops producing output for fifteen minutes: a pipeline-health alarm, not a temperature alarm. This is deliberate and it is the more valuable of the two. A temperature spike is visible on the dashboard; a scoring pipeline that silently died is not, and it is the failure mode that costs you a month of missing anomaly data before anyone notices.

1. On the **Configure actions** page, under **Notification**, select **Remove** to delete the notification block. You will not create an SNS topic in this lab.

   Click **Next**.

1. For **Alarm name**, enter:

   - **Alarm name:** **psb-lab-scoring-pipeline-stalled**

   Click **Next**, review, and click **Create alarm**.

1. Confirm the alarm appears in the list. Within fifteen minutes it should move to **OK** state as the scheduled scoring function produces data points.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Review Secrets and Network Posture

This task has no console clicking. It is a short review of two decisions this lab made deliberately, and what you would change in production.

1. Open the AWS Secrets Manager console and click **psb/influxdb/admin-token**.

1. Select the **Overview** tab and note what you get for USD 0.40 per secret per month:

   - The token is encrypted at rest with a KMS key and never appears in a Lambda environment variable, a CloudFormation template, or a Git repository.
   - Access is governed by IAM, so you can see in CloudTrail exactly which principal read it and when.
   - Three separate Lambda functions share one copy. Rotating it means updating one secret, not three deployments.

1. Now consider what this lab did not do. Click the **Rotation** tab and confirm rotation is **Disabled**.

   In production you would enable rotation. Secrets Manager can invoke a Lambda function on a schedule to create a new InfluxDB token, update the secret, and revoke the old one. The functions pick up the new value on their next cold start, which is exactly why the caching code in this lab caches per execution environment rather than in a global that never refreshes. A long-lived admin token that three functions share is convenient for a lab and is not a production posture.

1. Next, review the network decision. Open the **Amazon Timestream** console → **InfluxDB instances** → **psb-lab-influx** → **Connectivity & security**.

1. Confirm that **Publicly accessible** is **Yes**.

   > **What you would change.** In production the InfluxDB instance would be private, reachable only from inside the VPC. The three Lambda functions would be attached to private subnets in that VPC, with a security group rule allowing TCP 8086 from the Lambda security group only. Because those functions also call Secrets Manager, SageMaker Runtime and S3, you would add VPC interface endpoints for those services (or a NAT gateway) so the functions can reach AWS APIs without a route to the internet.

   This lab took the public path because VPC-attached Lambda adds subnet, route-table, security-group and endpoint configuration that would have consumed an hour and taught networking rather than IoT. The security group you created is still restrictive on port, and the token is still required, but an instance reachable from the internet on port 8086 is protected by one credential, and that is not enough for real data.

1. Finally, review the IAM roles you created. Open the **IAM** console → **Roles** and filter for **psb**. You should have four:

   | Role | What it may do |
   |---|---|
   | psb-lab-iot-rule-role | s3:PutObject on the raw/ prefix only |
   | psb-ingest-telemetry-role-* | Read one secret; write CloudWatch Logs |
   | psb-query-telemetry-role-* | Read one secret; write CloudWatch Logs |
   | psb-score-telemetry-role-* | Read one secret; invoke one endpoint; write curated/ |
   | psb-assistant-role-* | Invoke one model; invoke one function |

   Not one of them has a `"Resource": "*"` statement. Each names the specific ARN it needs. This is what least privilege looks like in practice, and it is achievable: it took perhaps ten extra minutes across the whole lab.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 3: Cost Review and Teardown

Most of the services in this solution are consumption-priced and cost close to nothing when idle. Two are not, and knowing which is the point of this task.

1. Review where the money actually goes in this architecture:

   | Service | Billing model | 24-hour idle cost |
   |---|---|---|
   | Timestream for InfluxDB db.influx.medium | Per instance-hour, always on | ≈ USD 3.41 |
   | SageMaker real-time endpoint ml.m5.large (not used here) | Per instance-hour, always on | ≈ USD 3.46 |
   | SageMaker serverless endpoint | Per millisecond of compute | ≈ USD 0.00 |
   | SageMaker Studio JupyterLab space | Per instance-hour while Running | ≈ USD 1.51 if left running |
   | AWS Lambda | Per request and GB-second | ≈ USD 0.01 |
   | AWS IoT Core | Per message and connection-minute | ≈ USD 0.01 |
   | Amazon S3 | Per GB-month and per request | ≈ USD 0.01 |
   | Amazon API Gateway HTTP API | Per request | < USD 0.01 |
   | Amazon Bedrock Nova Lite | Per token | ≈ USD 0.02 |
   | Amazon Cognito | Per monthly active user | USD 0.00 at this volume |
   | AWS Secrets Manager | Per secret-month + per API call | ≈ USD 0.02 |
   | Amazon CloudWatch | Per GB ingested, per metric, per alarm | ≈ USD 0.05 |

   The pattern is clear: anything provisioned by the hour costs money whether or not you use it; anything billed per request costs nothing when idle. Choosing serverless inference over a real-time endpoint in Lab 06 saved more than the entire rest of the solution costs combined.

1. Now shut down the expensive pieces. First, stop the SageMaker Studio space. Return to the **Amazon SageMaker AI** console → **Studio** → **psb-lab-user** → **Open Studio**.

1. In Studio, click **JupyterLab** in the left-hand navigation, find **psb-lab-space**, and click **Stop space**.

   > **Note:** Stopping the space preserves your notebook and its 20 GB volume. The instance stops billing immediately. Only the EBS volume continues, at pennies per day.

1. Delete the SageMaker inference endpoint. In the Amazon SageMaker AI console, expand **Inference** and click **Endpoints**.

1. Select **psb-anomaly-endpoint**, click **Actions**, and choose **Delete**. Confirm.

   > **Note:** A serverless endpoint costs almost nothing idle, so this step is about hygiene rather than money. It also demonstrates the habit: the endpoint is a deployed artifact, and deployed artifacts should be removed when the experiment ends. The model artifact remains in **s3://<inject key="LabBucketName" enableCopy="false"/>/model/**, so you can redeploy it at any time without retraining.

1. Disable the scheduled scoring rule so it does not keep invoking a deleted endpoint. In the **Amazon EventBridge** console, click **Rules**, select **psb-lab-score-every-5-min**, click **Disable**, and confirm.

1. Finally, the resource that matters most. Return to the **Amazon Timestream** console → **InfluxDB instances**.

1. Select **psb-lab-influx**, click **Actions**, and choose **Delete**.

1. In the confirmation dialog, clear the **Create final snapshot** checkbox, type **delete me** to confirm, and click **Delete**.

   > **Important:** This is the single most important cleanup step in the lab. A **db.influx.medium** Single-AZ instance costs USD 0.142 per hour (USD 3.41 per day, USD 104 per month) and it bills whether or not anything is writing to it. In a real project it is the resource most often left running after a proof of concept ends. Deletion protection was disabled in Lab 02 specifically so this step would work.

1. Confirm the instance status shows **Deleting**.

1. As a final check, note the resources that are safe to leave and cost nothing: the S3 bucket and its contents (pennies), the Lambda functions (free when not invoked), the API Gateway API (free when not called), the Cognito user pool (free at this volume), the IAM roles, and the Amplify app (free below the hosting allowance).

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="e249dee5-b790-4c0d-a7cf-445861bc5142" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you have completed the following:

- Applied one-week retention to all four Lambda log groups.
- Created a CloudWatch metric filter and a pipeline-health alarm that fires when scoring stops.
- Reviewed the secrets and network decisions this lab made, and what production would do differently.
- Confirmed that all five IAM service roles are least-privilege.
- Reviewed where cost actually accrues in the architecture and deleted the two provisioned resources that keep billing.

You have successfully completed the lab. Click **Next** to continue to the next page.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎉</span>Happy Learning!

</div>

</div>
