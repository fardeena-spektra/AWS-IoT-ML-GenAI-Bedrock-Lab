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
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Building an End-to-End IoT, Machine Learning and Generative AI Solution on AWS</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-sub" style="color:#f2cc6b;font-weight:700;letter-spacing:.08em;text-align:center;">Lab 08: Amazon Bedrock Assistant</div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">60 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;13 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

Phase III begins. Operators want to ask questions in plain English, such as "How warm was the server room in the last hour?". In this lab, you build an assistant Lambda that uses the **Amazon Bedrock Converse API** with **tool use**: the model calls a **get_sensor_stats** tool, which invokes your **psb-query-telemetry** function for real numbers, then writes the answer. You expose it as **POST /assistant** and turn on the chat panel in the dashboard.

> ℹ️ **Info:** The lab title says Claude. The assistant uses **Amazon Nova Lite** through the same Converse API. You can swap in an Anthropic Claude model later by changing **MODEL_ID** (and the model ARNs in the IAM policy).

> ⚠️ **Note:** In Asia Pacific (Singapore), Nova Lite is served through the **APAC cross-Region inference profile** **apac.amazon.nova-lite-v1:0**. Requests start in ap-southeast-1 and Bedrock routes them to an APAC Region with capacity. Always use the **apac.** prefix in this lab.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Objectives

In this lab, you will complete the following tasks:

1. 🔓 **Task 1:** Enable and test the model in Amazon Bedrock.
1. 🧰 **Task 2:** Create the psb-assistant Lambda function with tool use.
1. 💬 **Task 3:** Add the POST /assistant route and enable the dashboard chat.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🏗️</span>What you build

```text
Dashboard chat ──► POST /assistant (JWT authorizer) ──► psb-assistant
                                                         │  Converse API (apac.amazon.nova-lite-v1:0)
                                                         │  toolUse: get_sensor_stats
                                                         └─► invoke psb-query-telemetry ──► InfluxDB
```

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Enable and Test the Model in Amazon Bedrock

🎯 **Goal:** Make sure Amazon Nova Lite is available in ap-southeast-1 and answers a simple prompt.

1. In the AWS console search bar, type **Bedrock** and open **Amazon Bedrock**. Confirm the region is **Asia Pacific (Singapore)**.

1. In the left menu, select **Model access** (under **Bedrock configurations**).

1. Select **Modify model access** (or **Enable specific models**), select **Amazon** > **Nova Lite**, select **Next**, then **Submit**. Wait until the status shows **Access granted**.

   > ℹ️ **Info:** If the **Model access** page is not shown in your console, serverless foundation models are enabled automatically on first use. Continue with the next step.

1. In the left menu, select **Playgrounds** > **Chat / Text**. Select **Select model**, choose **Amazon** > **Nova Lite**, and select **Apply**.

1. Enter a test prompt and select **Run**:

   ```text
   In one sentence, what is an IoT telemetry anomaly?
   ```

1. Test the Converse API from the command line. Open **AWS CloudShell** (terminal icon in the console top bar) and run:

   ```bash
   aws bedrock-runtime converse \
     --model-id apac.amazon.nova-lite-v1:0 \
     --messages '[{"role":"user","content":[{"text":"Reply with OK"}]}]' \
     --region ap-southeast-1
   ```

   > 💡 **Tip:** CloudShell already uses your console sign-in. The AWS CLI on the lab VM has no credentials configured, so only use it if you have set up CLI credentials yourself. In that case, put the message in a file to avoid PowerShell quoting issues:
   >
   > ```powershell
   > '[{"role":"user","content":[{"text":"Reply with OK"}]}]' | Out-File msg.json -Encoding ascii
   > aws bedrock-runtime converse --model-id apac.amazon.nova-lite-v1:0 --messages file://msg.json --region ap-southeast-1
   > ```

✅ **Expected result:** The playground answers your prompt and the CLI response contains the text **OK**.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Create the psb-assistant Lambda Function with Tool Use

🎯 **Goal:** Deploy the assistant, give it least-privilege access to Bedrock and the query function, and test in and out of scope questions.

1. Open **AWS Lambda** > **Functions** > **Create function**, choose **Author from scratch**, and enter:

   | Setting | Value |
   |---|---|
   | **Function name** | psb-assistant |
   | **Runtime** | Python 3.13 |
   | **Architecture** | x86_64 |
   | **Execution role** | Create a new role with basic Lambda permissions |

1. Select **Create function**.

1. Open **C:\psb-lab-assets\lambdas\psb-assistant\lambda_function.py** in **VS Code**, copy all of it, paste it into the Lambda console editor, and select **Deploy**.

1. Select **Configuration** > **General configuration** > **Edit**:

   | Setting | Value |
   |---|---|
   | **Memory** | 512 MB |
   | **Timeout** | 1 min 30 sec |

1. Select **Configuration** > **Environment variables** > **Edit** and add:

   | Key | Value |
   |---|---|
   | **MODEL_ID** | apac.amazon.nova-lite-v1:0 |
   | **QUERY_FUNCTION_NAME** | psb-query-telemetry |
   | **MAX_TOOL_TURNS** | 4 |

1. Review how the assistant works:

   > ℹ️ **Info: the tool use loop**
   > 1. The question is sent to the model with a **system prompt** (answer only about the 3 lab locations and 4 metrics; politely refuse anything else) and a **toolConfig** containing **get_sensor_stats**.
   > 1. When the model replies with **stopReason: tool_use**, the function invokes **psb-query-telemetry** directly with the tool input.
   > 1. The tool result is sent back to the model as a **toolResult** message.
   > 1. The loop repeats until the model gives a final answer or **MAX_TOOL_TURNS** (4) is reached.
   > 1. The function returns **{"answer":"...","tool_calls":n}** (wrapped in an API response with CORS when called from API Gateway).

   The tool definition the model sees looks like this:

   ```json
   {
     "toolSpec": {
       "name": "get_sensor_stats",
       "description": "Get summary statistics (count, min, max, mean, latest) for one sensor metric over the last window_minutes, optionally for one lab location.",
       "inputSchema": {
         "json": {
           "type": "object",
           "properties": {
             "metric": {
               "type": "string",
               "enum": ["temperature_c", "humidity_pct", "co2_ppm", "vibration_g", "anomaly_score"],
               "description": "Metric to summarise."
             },
             "location": {
               "type": "string",
               "enum": ["north-lab", "south-lab", "server-room"],
               "description": "Optional lab location. Omit for all locations."
             },
             "window_minutes": {
               "type": "integer", "minimum": 1, "maximum": 1440,
               "description": "How many minutes back to look (1-1440)."
             }
           },
           "required": ["metric", "window_minutes"]
         }
       }
     }
   }
   ```

1. Select **Configuration** > **Permissions**, open the execution role in IAM, select **Add permissions** > **Create inline policy** > **JSON**, and paste this policy. Replace **&lt;AWS-ACCOUNT-ID&gt;** with your account ID:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "InvokeNovaLiteThroughApacProfileOnly",
         "Effect": "Allow",
         "Action": ["bedrock:InvokeModel", "bedrock:InvokeModelWithResponseStream"],
         "Resource": [
           "arn:aws:bedrock:ap-southeast-1:<AWS-ACCOUNT-ID>:inference-profile/apac.amazon.nova-lite-v1:0",
           "arn:aws:bedrock:*::foundation-model/amazon.nova-lite-v1:0"
         ]
       },
       {
         "Sid": "InvokeQueryFunctionOnly",
         "Effect": "Allow",
         "Action": "lambda:InvokeFunction",
         "Resource": "arn:aws:lambda:ap-southeast-1:<AWS-ACCOUNT-ID>:function:psb-query-telemetry"
       }
     ]
   }
   ```

   > ⚠️ **Note:** The Converse API is authorized by **bedrock:InvokeModel**. The policy allows the APAC inference profile in your account and the Nova Lite foundation model in any Region the profile routes to. Foundation model ARNs have an **empty account field** (two colons before foundation-model). The file is also at **C:\psb-lab-assets\policies\psb-lab-assistant-policy.json**.

1. Select **Next**, name the policy **psb-lab-assistant-policy**, and select **Create policy**.

1. Back in Lambda, open the **Test** tab, create an event named **ask-question**, and select **Test**:

   ```json
   {"question":"What was the average temperature in the server-room over the last hour?"}
   ```

1. Create a second test event with an out of scope question and run it:

   ```json
   {"question":"What is the temperature in the east wing?"}
   ```

   | Sample question | Scope | Expected behavior |
   |---|---|---|
   | What was the average temperature in the server-room over the last hour? | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">✅</span>In scope | Calls **get_sensor_stats** and answers with a real number. **tool_calls** ≥ 1. |
   | Which location had the highest CO₂ in the last 30 minutes? | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">✅</span>In scope | Calls the tool for each location and compares. |
   | Were there any anomalies in north-lab in the last hour? | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">✅</span>In scope | Uses **anomaly_score** and reports flagged readings. |
   | What is the temperature in the east wing? | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">❌</span>Out of scope | Politely refuses: only north-lab, south-lab and server-room are monitored. |
   | Write me a poem about the weather in Paris. | <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">❌</span>Out of scope | Politely refuses and explains what it can answer. |

   | Problem | Likely cause and fix |
   |---|---|
   | AccessDeniedException on Converse | Model ARN or region in **psb-lab-assistant-policy** is wrong, or model access is not granted. |
   | AccessDenied on lambda:InvokeFunction | Wrong account ID in the query function ARN. |
   | Task timed out | Timeout is not 1 min 30 sec. |

✅ **Expected result:** The in scope test returns an **answer** with **tool_calls** of 1 or more, and the east wing question is politely refused.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 3: Add the POST /assistant Route and Enable the Dashboard Chat

🎯 **Goal:** Expose the assistant through your protected API and use it from the dashboard.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔗</span>Create the route

1. Open **API Gateway** > **APIs** > **psb-lab-api** > **Routes** and select **Create**.

1. Set the method to **POST**, the path to **/assistant**, and select **Create**.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔌</span>Attach the integration

1. Select the **POST /assistant** route, then select **Attach integration** > **Create and attach an integration**.

1. Configure it:

   | Setting | Value |
   |---|---|
   | **Integration type** | Lambda function |
   | **AWS Region** | ap-southeast-1 |
   | **Lambda function** | psb-assistant |
   | **Payload format version** (Advanced settings) | 2.0 |
   | **Grant API Gateway permission to invoke your Lambda function** | On |

1. Select **Create**.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔐</span>Attach the authorizer

1. In the left menu, select **Authorization**, select the **POST /assistant** route, choose **psb-lab-cognito-authorizer** from the list, and select **Attach authorizer**.

   > ℹ️ **Info:** The **$default** stage has automatic deployment turned on, so the new route is live straight away.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">💬</span>Enable the chat panel

1. In **VS Code**, open **C:\psb-lab-assets\dashboard\src\config.js** and set:

   ```javascript
   assistantEnabled: true
   ```

1. Rebuild and zip the dashboard in PowerShell:

   ```powershell
   cd C:\psb-lab-assets\dashboard
   npm run build
   Compress-Archive -Path dist\* -DestinationPath dashboard-build.zip -Force
   ```

   > 💡 **Tip:** If you used the **dist.zip** fallback in Lab 05, set **assistantEnabled** to **true** in its **config.json** and re-zip instead.

1. Open **AWS Amplify** > **psb-lab-dashboard** > branch **main**, select **Deploy updates**, drag and drop the new **dashboard-build.zip**, and select **Save and deploy**.

1. When the deployment shows **Deployed**, open the dashboard, sign in as **student@psb.lab**, and ask questions in the chat panel, for example:

   ```text
   What was the average temperature in the server-room over the last hour?
   Which location had the highest CO2 in the last 30 minutes?
   What is the humidity in the east wing?
   ```

   > 🧭 **Concept note:** For production agents, look at the open source **Strands Agents SDK** (model-driven agents in a few lines of Python) and **Amazon Bedrock AgentCore** (managed runtime, memory, identity, gateway and observability for agents).

   ✅ **Expected result:** **POST /assistant** is protected by **psb-lab-cognito-authorizer**, and the dashboard chat answers in scope questions with real sensor numbers.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="1bf8d00e-c157-4605-849d-6f74e935a67c" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you:

- Enabled **Amazon Nova Lite** and tested it in the playground and with the Converse API.
- Built **psb-assistant**, which uses Bedrock tool use (**get_sensor_stats**) to fetch real data from **psb-query-telemetry**.
- Restricted it with **psb-lab-assistant-policy** to one model and one function.
- Published **POST /assistant** behind the Cognito JWT authorizer and enabled the dashboard chat panel.

Click **Next** to continue.

</div>

</div>
