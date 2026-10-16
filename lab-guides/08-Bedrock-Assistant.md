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
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 08: Build a Natural-Language Assistant with Amazon Bedrock</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">60 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;13 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

Your dashboard answers the questions you thought to build a chart for. In this lab you will build something that answers the questions you did not.

You will create an assistant Lambda function that calls the Amazon Bedrock Converse API with a tool declared: **get_sensor_stats**. When a user asks "was anything unusual in the north lab in the last two hours?", the model will decide it needs data, emit a **toolUse** request, your Lambda will execute that tool against the query function you built in Lab 03, return the result, and the model will compose an answer grounded in your real telemetry.

This is the agent pattern, written out in full. There is no framework hiding the loop: you will see every step.

> **A note on Amazon Bedrock AgentCore.** PSB's original draft named Strands Agents on Bedrock AgentCore as the target for a full agent workflow, and that is a reasonable long-term direction. AgentCore is a managed runtime that handles agent hosting, memory, identity and observability. This lab builds the loop by hand first, deliberately: once you have written a toolUse/toolResult cycle yourself, AgentCore stops being magic and becomes a hosting decision. The tool schema and system prompt you write here transfer directly.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Lab Objectives

You will be able to complete the following tasks:

- Task 1: Verify Bedrock model access and test the Converse API
- Task 2: Build the assistant Lambda with tool use
- Task 3: Wire it to the API and the dashboard chat panel

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Verify Bedrock Model Access and Test the Converse API

1. In the AWS Management Console search bar, type **Bedrock** and select **Amazon Bedrock**.

1. In the left-hand navigation pane, scroll down and click **Model access**.

1. Confirm that **Amazon Nova Lite** shows **Access granted**.

   > **Note:** Model access has been enabled for you by the lab deployment because it is an account-level setting that can take several minutes to propagate. If it shows **Available to request**, click **Modify model access**, select **Amazon Nova Lite**, and submit; Amazon-family models are granted immediately.

1. Test the model from the console. In the left-hand navigation pane, under **Playgrounds**, click **Chat / Text**.

1. Click **Select model**, choose **Amazon** as the category and **Nova Lite** as the model, then click **Apply**.

1. Enter a prompt such as **Explain what an anomaly score is, in two sentences.** and click **Run**. Confirm you get a response.

   > **Why Amazon Nova Lite?** It is available on-demand natively in **<inject key="LabRegion" enableCopy="false"/>**, supports the Converse API's tool-use feature, and costs USD 0.081 per million input tokens and USD 0.324 per million output tokens, roughly two cents for this entire lab. Anthropic's Claude models are also excellent for tool use but are reachable from Singapore only through APAC cross-region inference profiles, which bill against a different source region. If you want to switch later, change the **MODEL_ID** environment variable in the next task to `apac.anthropic.claude-sonnet-4-5-20250929-v1:0` or to `amazon.nova-pro-v1:0`; no other code change is needed.

1. Now test the Converse API from the command line. In PowerShell:

   ```powershell
   aws bedrock-runtime converse `
     --region ap-southeast-1 `
     --model-id amazon.nova-lite-v1:0 `
     --messages '[{"role":"user","content":[{"text":"Say OK and nothing else."}]}]'
   ```

1. Confirm you get a JSON response containing `"text": "OK"`.

   > **Note:** The Converse API (`converse` / `converse_stream`) is the modern, model-agnostic interface. The older `invoke_model` API required a different request body shape for every model family. Converse normalises messages, system prompts, inference parameters and tool use across all of them, so switching models really is a one-line change.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Build the Assistant Lambda with Tool Use

1. In the Lambda console, click **Create function**.

1. Configure:

   | Field | Value |
   |---|---|
   | Option | **Author from scratch** |
   | Function name | **psb-assistant** |
   | Runtime | **Python 3.13** |
   | Architecture | **x86_64** |
   | Execution role | **Create a new role with basic Lambda permissions** |

   Click **Create function**.

1. Replace the contents of **lambda_function.py** with:

   ```python
   """
   PSB Academy CloudLab - natural-language telemetry assistant.

   Amazon Bedrock Converse API with tool use. The model is given one
   tool, get_sensor_stats, which is backed by the psb-query-telemetry
   Lambda function built in Lab 03.
   """
   import json
   import os

   import boto3

   MODEL_ID = os.environ.get("MODEL_ID", "amazon.nova-lite-v1:0")
   QUERY_FUNCTION = os.environ["QUERY_FUNCTION_NAME"]
   MAX_TOOL_TURNS = int(os.environ.get("MAX_TOOL_TURNS", "4"))

   _bedrock = boto3.client("bedrock-runtime")
   _lambda = boto3.client("lambda")

   SYSTEM_PROMPT = [{
       "text": (
           "You are the PSB Academy laboratory monitoring assistant. "
           "You answer questions about live sensor telemetry from three "
           "locations: north-lab, south-lab and server-room. "
           "Four metrics are available: temperature_c (degrees Celsius), "
           "humidity_pct (relative humidity), co2_ppm (carbon dioxide in "
           "parts per million) and anomaly_score (an unsupervised Random "
           "Cut Forest score; values above about 1.5 are unusual).\n\n"
           "Rules:\n"
           "1. Always call get_sensor_stats before making any claim about "
           "a number. Never guess or recall a value.\n"
           "2. If the tool returns point_count 0, say plainly that there "
           "is no data in that window. Do not invent a value.\n"
           "3. Quote units. Round to one decimal place.\n"
           "4. Be concise: two or three sentences unless asked for detail.\n"
           "5. If asked about a location or metric that is not in the "
           "lists above, say which ones are available."
       )
   }]

   TOOL_CONFIG = {
       "tools": [{
           "toolSpec": {
               "name": "get_sensor_stats",
               "description": (
                   "Return aggregated statistics and a downsampled time "
                   "series for one sensor metric over a recent time window. "
                   "Use this for every question about sensor values, trends "
                   "or anomalies."
               ),
               "inputSchema": {"json": {
                   "type": "object",
                   "properties": {
                       "metric": {
                           "type": "string",
                           "enum": ["temperature_c", "humidity_pct",
                                    "co2_ppm", "vibration_g",
                                    "anomaly_score"],
                           "description": "Which metric to retrieve.",
                       },
                       "window_minutes": {
                           "type": "integer",
                           "description": (
                               "How far back to look, in minutes. "
                               "Between 1 and 1440."),
                       },
                       "location": {
                           "type": "string",
                           "enum": ["north-lab", "south-lab", "server-room"],
                           "description": (
                               "Optional. Omit to cover all locations."),
                       },
                   },
                   "required": ["metric", "window_minutes"],
               }},
           }
       }]
   }

   def run_tool(name, arguments):
       if name != "get_sensor_stats":
           return {"error": f"unknown tool {name}"}
       response = _lambda.invoke(
           FunctionName=QUERY_FUNCTION,
           InvocationType="RequestResponse",
           Payload=json.dumps(arguments).encode("utf-8"),
       )
       result = json.loads(response["Payload"].read())
       # Send the model the summary plus a light sample of the series.
       # Handing it 300 raw points wastes tokens and helps nothing.
       return {
           "summary": result.get("summary", {}),
           "sample": result.get("points", [])[-12:],
       }

   def converse(messages):
       return _bedrock.converse(
           modelId=MODEL_ID,
           system=SYSTEM_PROMPT,
           messages=messages,
           toolConfig=TOOL_CONFIG,
           inferenceConfig={"maxTokens": 600, "temperature": 0.2},
       )

   def ask(question):
       messages = [{"role": "user", "content": [{"text": question}]}]
       trace = []

       for _ in range(MAX_TOOL_TURNS):
           response = converse(messages)
           output = response["output"]["message"]
           messages.append(output)

           if response.get("stopReason") != "tool_use":
               answer = "".join(block.get("text", "")
                                for block in output["content"])
               return {"answer": answer.strip(), "trace": trace,
                       "usage": response.get("usage", {})}

           # The model asked for one or more tools. Run them all.
           tool_results = []
           for block in output["content"]:
               if "toolUse" not in block:
                   continue
               use = block["toolUse"]
               trace.append({"tool": use["name"], "input": use["input"]})
               result = run_tool(use["name"], use["input"])
               tool_results.append({"toolResult": {
                   "toolUseId": use["toolUseId"],
                   "content": [{"json": result}],
               }})
           messages.append({"role": "user", "content": tool_results})

       return {"answer": ("I could not answer that within the allowed "
                          "number of tool calls. Try a narrower question."),
               "trace": trace, "usage": {}}

   def _response(status, body):
       return {
           "statusCode": status,
           "headers": {"Content-Type": "application/json",
                       "Access-Control-Allow-Origin": "*"},
           "body": json.dumps(body),
       }

   def lambda_handler(event, context):
       try:
           body = json.loads(event.get("body") or "{}")
       except json.JSONDecodeError:
           return _response(400, {"error": "body must be valid JSON"})

       question = (body.get("question") or "").strip()
       if not question:
           return _response(400, {"error": "field 'question' is required"})
       if len(question) > 500:
           return _response(400, {"error": "question is too long"})

       try:
           result = ask(question)
       except Exception as err:                      # noqa: BLE001
           print(f"[error] {type(err).__name__}: {err}")
           return _response(502, {"error": "assistant unavailable"})

       print(f"[ok] q={question[:80]!r} tools={len(result['trace'])} "
             f"usage={result.get('usage')}")
       return _response(200, result)
   ```

   The loop in `ask()` is the whole idea, and it is worth reading twice:

   - You send the question plus the tool schema. You do not tell the model to use the tool; you describe what the tool does and let it decide.
   - If `stopReason` is not `tool_use`, the model answered directly and you are done.
   - If it is `tool_use`, the model has emitted a `toolUse` block containing a `toolUseId` and an `input` object matching your JSON schema. You run the tool, wrap the result in a `toolResult` block carrying the same `toolUseId`, append it as a user message, and call the model again.
   - `MAX_TOOL_TURNS` bounds the loop. Without it a confused model can loop until the Lambda times out, and every iteration costs tokens.
   - `run_tool` returns the summary plus the last twelve points, not all of them. Token budget is a real design constraint: a 300-point series would add roughly 4,000 input tokens per turn and would not make the answer better.

1. Click **Deploy**.

1. Open **Configuration** → **General configuration** → **Edit**:

   | Field | Value |
   |---|---|
   | Memory | **512 MB** |
   | Timeout | **1 min 30 sec** |

   Click **Save**.

1. Open **Configuration** → **Environment variables** → **Edit** and add:

   | Key | Value |
   |---|---|
   | MODEL_ID | **amazon.nova-lite-v1:0** |
   | QUERY_FUNCTION_NAME | **psb-query-telemetry** |
   | MAX_TOOL_TURNS | **4** |

   Click **Save**.

1. Open **Configuration** → **Permissions**, click the **Role name** link, and add an inline policy with the following JSON, replacing `<AWS-ACCOUNT-ID>`:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "AllowInvokeNovaLite",
         "Effect": "Allow",
         "Action": ["bedrock:InvokeModel", "bedrock:Converse"],
         "Resource": "arn:aws:bedrock:ap-southeast-1::foundation-model/amazon.nova-lite-v1:0"
       },
       {
         "Sid": "AllowInvokeQueryFunction",
         "Effect": "Allow",
         "Action": "lambda:InvokeFunction",
         "Resource": "arn:aws:lambda:ap-southeast-1:<AWS-ACCOUNT-ID>:function:psb-query-telemetry"
       }
     ]
   }
   ```

1. Click **Next**, name it **psb-lab-assistant-policy**, and click **Create policy**.

   > **Note:** The Bedrock foundation-model ARN has an empty account field: `arn:aws:bedrock:ap-southeast-1::foundation-model/...` with two colons. Foundation models are owned by AWS, not by your account. Writing your account ID there is a common mistake and produces an **AccessDeniedException** that looks like a model-access problem.

1. Return to the function, open the **Test** tab, create an event named **ask-question**, and set the body to:

   ```json
   {
     "body": "{\"question\": \"What is the average temperature in the north lab over the last hour, and was anything unusual?\"}"
   }
   ```

1. Click **Test**. You should get a 200 response whose body contains something like:

   ```json
   {
     "answer": "Over the last hour the north lab averaged 22.9 °C, ranging from 21.9 to 24.1 °C. The anomaly score stayed below 1.2 for the whole window, so nothing unusual was detected.",
     "trace": [
       {"tool": "get_sensor_stats", "input": {"metric": "temperature_c", "window_minutes": 60, "location": "north-lab"}},
       {"tool": "get_sensor_stats", "input": {"metric": "anomaly_score", "window_minutes": 60, "location": "north-lab"}}
     ],
     "usage": {"inputTokens": 2841, "outputTokens": 74, "totalTokens": 2915}
   }
   ```

1. Look carefully at the **trace**. The model made two tool calls without being told to: it worked out that "average temperature" and "anything unusual" are two different metrics. That decision is the thing you built.

1. Try a question that should get a refusal rather than an invention:

   ```json
   { "body": "{\"question\": \"What was the temperature in the east wing last March?\"}" }
   ```

   The assistant should tell you that **east-wing** is not one of the available locations, rather than making up a number.

   > **Troubleshooting:** An **AccessDeniedException** on `bedrock:InvokeModel` means the ARN in the inline policy has your account ID where it should have nothing. A **ValidationException** mentioning `toolConfig` means the model ID does not support tool use; confirm it is `amazon.nova-lite-v1:0`. If the assistant answers without any trace entries, the model decided it did not need data; rephrase the question to ask for a specific number.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 3: Wire It to the API and the Dashboard Chat Panel

1. Return to the API Gateway console and open **psb-lab-api**.

1. In the left-hand navigation pane, under **Develop**, click **Routes**.

1. Click **Create**.

1. Configure:

   | Field | Value |
   |---|---|
   | Method | **POST** |
   | Path | **/assistant** |

   Click **Create**.

1. With **POST /assistant** selected, click **Attach integration**, then **Create and attach an integration**:

   | Field | Value |
   |---|---|
   | Integration type | **Lambda function** |
   | AWS Region | **<inject key="LabRegion" enableCopy="false"/>** |
   | Lambda function | **psb-assistant** |
   | Payload format version | **2.0** |

   Click **Create**.

1. In the left-hand navigation pane, click **Authorization**, select the **Attach authorizers to routes** tab, click **POST /assistant**, choose **psb-lab-cognito-authorizer**, and click **Attach authorizer**.

1. Test it from PowerShell with a fresh token:

   ```powershell
   curl.exe -X POST "<INVOKE-URL>/assistant" `
     -H "Authorization: Bearer <ID-TOKEN>" `
     -H "Content-Type: application/json" `
     -d '{\"question\":\"Which location has the highest CO2 right now?\"}'
   ```

1. Confirm you get a natural-language answer.

1. Now enable the chat panel in the dashboard. On the Lab VM, in VS Code, open **C:\psb-lab-assets\dashboard\src\config.js** and add one line inside the **config** object:

   ```javascript
   assistantEnabled: true,
   ```

1. Save the file, then rebuild and repackage:

   ```powershell
   cd C:\psb-lab-assets\dashboard
   npm run build
   Compress-Archive -Path .\dist\* -DestinationPath .\dashboard-build.zip -Force
   ```

1. Return to the AWS Amplify console, open **psb-lab-dashboard**, and click **Deploy updates**.

1. Drag **dashboard-build.zip** into the upload area and click **Save and deploy**.

1. When the deployment shows **Deployed**, open your Amplify domain and sign in.

1. A chat panel now appears beneath the chart. Try these questions:

   - What is the average CO2 in the server room over the last two hours?
   - Has anything been unusual in the last 30 minutes?
   - Compare temperature between the north lab and the south lab today.
   - What is the highest vibration reading in the last hour?

1. Watch the network tab in your browser developer tools (**F12**) while you ask a question. You will see a single POST to **/assistant** that takes two to six seconds: the model round-trips, the tool runs, the model round-trips again.

   > **Where this goes next: Strands Agents on Bedrock AgentCore.** What you have built is a single-turn, single-tool agent running in a Lambda function. It has no memory between questions, no identity propagation to the tool, and no tracing beyond your own print statements. Strands Agents is an open-source SDK that expresses the same loop declaratively: you register Python functions as tools with a decorator and the SDK runs the cycle. Amazon Bedrock AgentCore then hosts that agent, adding a managed runtime with session isolation, a gateway that turns existing APIs into tools, short- and long-term memory, identity propagation so the tool runs as the end user rather than as the Lambda role, and OpenTelemetry-based observability. Your **SYSTEM_PROMPT** and **TOOL_CONFIG** port across almost verbatim. Build the loop by hand once, as you just have; adopt the runtime when session state, multi-agent coordination or per-user authorisation becomes the problem you are actually solving.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="1bf8d00e-c157-4605-849d-6f74e935a67c" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you have completed the following:

- Verified Amazon Bedrock model access and tested the Converse API.
- Built an assistant Lambda function implementing the Converse tool-use loop from first principles.
- Declared a **get_sensor_stats** tool backed by your existing query function, with a grounded system prompt that forbids guessing.
- Exposed it through a secured API route and enabled the dashboard chat panel.

Phase III is complete. A non-specialist can now ask your solution a question in English and get an answer grounded in real sensor data.

You have successfully completed the lab. Click **Next** to continue to the next lab.

</div>

</div>
