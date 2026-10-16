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
@media (prefers-reduced-motion:reduce){.psbgs *,.psbgs *::before,.psbgs *::after{animation:none!important;transition:none!important}}
</style>

<div class="psbgs">

<div class="psb-hero" style="position:relative;overflow:hidden;border-radius:16px;padding:28px 20px 24px;margin:0 0 6px;text-align:center;color:#ffffff;background:linear-gradient(120deg,#070b1a,#121a3a,#0d2b36,#16123a);">
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 09: Observability and Teardown</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">40 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;5 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

Your platform is complete: devices, ingestion, API, dashboard, machine learning and a generative AI assistant. In this final lab, you make it operable and safe: set log retention, search logs, alert when the scoring pipeline stalls, review security choices, review cost drivers, and tear down the expensive resources.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Objectives

In this lab, you will complete the following tasks:

1. 📈 **Task 1:** Configure log retention, search logs, and create a metric filter and alarm.
1. 🛡️ **Task 2:** Review the security posture.
1. 💰 **Task 3:** Review costs and tear down.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Configure Log Retention, Search Logs, and Create a Metric Filter and Alarm

🎯 **Goal:** Keep logs for a sensible period and get alerted when scoring stops.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🗂️</span>Set log retention

1. Open **CloudWatch** > **Logs** > **Log groups** and filter on **/aws/lambda/psb-**.

1. For each log group below, select it, select **Actions** > **Edit retention setting(s)**, choose **1 week (7 days)**, and select **Save**:

   | Log group | Retention |
   |---|---|
   | /aws/lambda/psb-ingest-telemetry | 1 week |
   | /aws/lambda/psb-query-telemetry | 1 week |
   | /aws/lambda/psb-score-telemetry | 1 week |
   | /aws/lambda/psb-assistant | 1 week |

   > 💡 **Tip:** Lambda log groups default to **Never expire**, which slowly grows storage cost.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔎</span>Search the logs

1. Select **Logs** > **Logs Insights**, choose the log group **/aws/lambda/psb-ingest-telemetry**, set the time range to **1h**, enter this query, and select **Run query**:

   ```text
   fields @timestamp, @message
   | filter @message like /ERROR|Error|Traceback|Task timed out/
   | sort @timestamp desc
   | limit 20
   ```

1. Change the filter line to `| filter @message like /\[ok\] wrote/` and run it again to see successful writes.

   > ℹ️ **Info:** You can also open the log group and use **Search all log streams** with a filter pattern such as **"[ok] wrote"** or **ERROR**.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧮</span>Create the metric filter

1. Open the log group **/aws/lambda/psb-score-telemetry**, select the **Metric filters** tab, and select **Create metric filter**.

1. Enter the filter pattern and select **Next**:

   | Setting | Value |
   |---|---|
   | **Filter pattern** | "[ok] scored=" |

1. Assign the metric and select **Next**, then **Create metric filter**:

   | Setting | Value |
   |---|---|
   | **Filter name** | psb-lab-anomaly-batches |
   | **Metric namespace** | PSBLab |
   | **Metric name** | AnomalyBatches |
   | **Metric value** | 1 |
   | **Default value** | 0 |

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🚨</span>Create the alarm

1. Select **Alarms** > **All alarms** > **Create alarm** > **Select metric**.

1. Select **PSBLab** > **Metrics with no dimensions** > **AnomalyBatches**, then **Select metric**.

1. Configure the metric and conditions:

   | Setting | Value |
   |---|---|
   | **Statistic** | Sum |
   | **Period** | 5 minutes |
   | **Threshold type** | Static |
   | **Condition** | Lower/Equal (<=) |
   | **Threshold** | 0 |
   | **Datapoints to alarm** | 3 out of 3 |
   | **Missing data treatment** | Treat missing data as bad (breaching threshold) |

1. Select **Next**. Under **Notification**, select **Remove** so no SNS action is configured, then select **Next**.

1. Enter the alarm name **psb-lab-scoring-pipeline-stalled**, select **Next**, then **Create alarm**.

   > ℹ️ **Info:** The alarm goes to **In alarm** if no scoring batch is logged for 15 minutes (3 periods of 5 minutes), for example when the EventBridge rule, the endpoint or InfluxDB stops working. In production you would add an SNS topic for notifications.

✅ **Expected result:** All 4 log groups keep logs for 1 week, the metric filter **psb-lab-anomaly-batches** exists, and the alarm **psb-lab-scoring-pipeline-stalled** is created (state **OK** or **Insufficient data**).

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Review the Security Posture

🎯 **Goal:** Understand which demo shortcuts you took and how you would harden them for production.

1. Open **Secrets Manager** > **psb/influxdb/admin-token** and note that **Rotation** is **Disabled**.

1. Open **Timestream** > **InfluxDB databases** > **psb-lab-influx** and note **Publicly accessible: Yes**.

1. Open **IAM** > **Roles**, search for **psb**, and review the inline policy of each of the 5 roles below.

1. Compare your findings with this table:

   | Area | Lab setting | Risk | Production recommendation |
   |---|---|---|---|
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔑</span>**Secret psb/influxdb/admin-token** | Rotation off, admin (operator) token | Long-lived, all-powerful token | Enable rotation; use a scoped write token for ingest and a read token for query. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🗄️</span>**InfluxDB psb-lab-influx** | Publicly accessible, port 8086 open in psb-lab-influx-sg | Internet exposure | Private subnets only; run Lambdas in the VPC; restrict the security group to the Lambda security group. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🛰️</span>**psb-lab-iot-rule-role** | Inline **psb-lab-iot-rule-s3-write**: s3:PutObject on raw/* only | Low | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">✅</span>Least privilege. Trust only iot.amazonaws.com. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📥</span>**psb-ingest-telemetry role** | Basic Lambda execution + **psb-lab-read-influx-token** (GetSecretValue on one secret) | Low | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">✅</span>Least privilege. Use a write-only Influx token. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📤</span>**psb-query-telemetry role** | Basic Lambda execution + **psb-lab-read-influx-token** | Low | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">✅</span>Least privilege. Use a read-only Influx token. Allow-listed metrics and locations prevent Flux injection. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧮</span>**psb-score-telemetry role** | Basic Lambda execution + **psb-lab-score-telemetry-policy** (secret, endpoint/psb-anomaly-endpoint, curated/*) | Low | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">✅</span>Least privilege. Scope S3 further to curated/scored/*. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🤖</span>**psb-assistant role** | Basic Lambda execution + **psb-lab-assistant-policy** (one model ARN, one function ARN) | Low | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">✅</span>Least privilege. Add Bedrock Guardrails and rate limits on the API. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔐</span>**Device psb-lab-sensor-01** | Only **psb-lab-device-policy** on its certificate | Low | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">✅</span>Own client ID and topics only. Rotate certificates. |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🌐</span>**API and dashboard** | JWT authorizer on all routes, CORS origin * | Medium (CORS) | Restrict CORS origin to the Amplify domain. |

   > 💡 **Tip:** The 4 Lambda execution roles were created by the console with names like **psb-score-telemetry-role-xxxxxxxx**.

✅ **Expected result:** You can explain each finding and the production fix.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 3: Review Costs and Tear Down

🎯 **Goal:** Know what drives cost and stop or delete the hourly billed resources.

1. Review the main cost drivers in this lab:

   | Resource | Billing basis | Relative cost | Teardown action |
   |---|---|---|---|
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🗄️</span>**Timestream for InfluxDB psb-lab-influx** (db.influx.medium, 20 GiB, 3000 IOPS) | Per instance hour + storage | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔴</span>High | Delete |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧪</span>**SageMaker space psb-lab-space** (ml.t3.medium) | Per hour while running | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🟠</span>Medium | Stop |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🚀</span>**Serverless endpoint psb-anomaly-endpoint** (2048 MB) | Per inference duration + data processed | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🟡</span>Low (idle) | Delete |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🏋️</span>**RCF training job** (ml.m5.large) | Per second of training (already finished) | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🟢</span>One time | None |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🖥️</span>**Lab VM** (t3.medium) | Per hour | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🟠</span>Medium | Managed by CloudLabs |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🛰️</span>**IoT Core, Lambda, API Gateway, EventBridge** | Per message / request | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🟢</span>Very low | Stop simulator, disable rule |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🤖</span>**Bedrock Nova Lite** | Per input/output token | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🟢</span>Very low | None |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📦</span>**S3, CloudWatch Logs, Amplify** | Per GB stored / served | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🟢</span>Very low | Retention set in Task 1 |

1. **Stop the simulator:** in the PowerShell window running **simulate_pi.py**, press **Ctrl+C**.

1. **Stop the space:** open **SageMaker AI** > **Studio** > **Open Studio** > **JupyterLab**, and select **Stop** on **psb-lab-space**. This deletes the running JupyterLab app; the space and its files remain.

1. **Delete the endpoint:** in the SageMaker AI console, select **Inference** > **Endpoints**, select **psb-anomaly-endpoint**, then **Actions** > **Delete** and confirm. Then select **Inference** > **Endpoint configurations**, select the configuration used by the endpoint, and delete it too.

1. **Disable the IoT rule:** open **AWS IoT Core** > **Message routing** > **Rules**, select **psb_telemetry_rule**, then select **Deactivate** (shown as **Disable** in some console versions) and confirm. The rule status changes to **Inactive**.

1. **Delete InfluxDB:** open **Timestream** > **InfluxDB databases**, select **psb-lab-influx**, and select **Delete**. If asked, do not create a final snapshot, type **delete me** to confirm, and select **Delete**.

   > ⚠️ **Note:** Deleting the InfluxDB instance is permanent. The dashboard and API stop returning data after this step. That is expected.

1. Tick off your teardown checklist:

   | | Teardown item |
   |---|---|
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">⬜</span>| Simulator stopped (Ctrl+C) |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">⬜</span>| Space **psb-lab-space** stopped (JupyterLab app deleted) |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">⬜</span>| Endpoint **psb-anomaly-endpoint** deleted |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">⬜</span>| Endpoint configuration deleted |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">⬜</span>| Rule **psb_telemetry_rule** disabled |
   | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">⬜</span>| InfluxDB **psb-lab-influx** deleted (status **Deleting** is fine) |

   ✅ **Expected result:** Observability is configured from Task 1 and every item in the teardown checklist is done.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="e249dee5-b790-4c0d-a7cf-445861bc5142" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you:

- Set 1 week retention on the 4 Lambda log groups and searched logs with Logs Insights.
- Created the metric filter **psb-lab-anomaly-batches** and the alarm **psb-lab-scoring-pipeline-stalled**.
- Reviewed the secret, InfluxDB exposure and the 5 IAM roles for least privilege.
- Reviewed cost drivers and tore down the hourly billed resources.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🏁</span>You Did It!

Across 9 labs you built an end to end AWS platform in ap-southeast-1:

| Phase | What you built |
|---|---|
| **I. Connect, ingest, serve** | IoT Core device identity, Rules Engine to InfluxDB and S3, query API, Cognito sign-in, Amplify dashboard |
| **II. Machine learning** | SageMaker Random Cut Forest model, serverless endpoint, scheduled scoring pipeline |
| **III. Generative AI and operations** | Bedrock tool use assistant, CloudWatch observability, security and cost review |

Need help? Contact cloudlabs-support@spektrasystems.com. We are available 24/7.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎉</span>Happy Learning!

</div>

</div>
