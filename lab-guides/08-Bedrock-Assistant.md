<h1 align="center">🤖 Lab 08: Build a Generative AI Assistant with Amazon Bedrock</h1>
<p align="center"><b>AWS Demo || Bedrock with Claude</b> | ⏱️ <b>Estimated Timing: 60 Minutes</b> | 🏆 <b>Points: 13</b></p>

---

## 🎯 Overview

Phase III begins. Operators want to ask questions in plain English, such as "How warm was the server room in the last hour?". In this lab, you build an assistant Lambda that uses the **Amazon Bedrock Converse API** with **tool use**: the model calls a **get_sensor_stats** tool, which invokes your **psb-query-telemetry** function for real numbers, then writes the answer. You expose it as **POST /assistant** and turn on the chat panel in the dashboard.

> ℹ️ **Info:** The lab title says Claude. The assistant uses **Amazon Nova Lite** through the same Converse API. You can swap in an Anthropic Claude model later by changing **MODEL_ID** (and the model ARNs in the IAM policy).

> ⚠️ **Note:** In Asia Pacific (Singapore), Nova Lite is served through the **APAC cross-Region inference profile** **apac.amazon.nova-lite-v1:0**. Requests start in ap-southeast-1 and Bedrock routes them to an APAC Region with capacity. Always use the **apac.** prefix in this lab.

## 📋 Objectives

In this lab, you will complete the following tasks:

1. 🔓 **Task 1:** Enable and test the model in Amazon Bedrock.
1. 🧰 **Task 2:** Create the psb-assistant Lambda function with tool use.
1. 💬 **Task 3:** Add the POST /assistant route and enable the dashboard chat.

## 🏗️ What you build

```text
Dashboard chat ──► POST /assistant (JWT authorizer) ──► psb-assistant
                                                         │  Converse API (apac.amazon.nova-lite-v1:0)
                                                         │  toolUse: get_sensor_stats
                                                         └─► invoke psb-query-telemetry ──► InfluxDB
```

---

## 🧩 Task 1: Enable and test the model in Amazon Bedrock

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

---

## 🧩 Task 2: Create the psb-assistant Lambda function with tool use

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
   | What was the average temperature in the server-room over the last hour? | ✅ In scope | Calls **get_sensor_stats** and answers with a real number. **tool_calls** ≥ 1. |
   | Which location had the highest CO₂ in the last 30 minutes? | ✅ In scope | Calls the tool for each location and compares. |
   | Were there any anomalies in north-lab in the last hour? | ✅ In scope | Uses **anomaly_score** and reports flagged readings. |
   | What is the temperature in the east wing? | ❌ Out of scope | Politely refuses: only north-lab, south-lab and server-room are monitored. |
   | Write me a poem about the weather in Paris. | ❌ Out of scope | Politely refuses and explains what it can answer. |

   | Problem | Likely cause and fix |
   |---|---|
   | AccessDeniedException on Converse | Model ARN or region in **psb-lab-assistant-policy** is wrong, or model access is not granted. |
   | AccessDenied on lambda:InvokeFunction | Wrong account ID in the query function ARN. |
   | Task timed out | Timeout is not 1 min 30 sec. |

✅ **Expected result:** The in scope test returns an **answer** with **tool_calls** of 1 or more, and the east wing question is politely refused.

---

## 🧩 Task 3: Add the POST /assistant route and enable the dashboard chat

🎯 **Goal:** Expose the assistant through your protected API and use it from the dashboard.

### 🔗 Create the route

1. Open **API Gateway** > **APIs** > **psb-lab-api** > **Routes** and select **Create**.

1. Set the method to **POST**, the path to **/assistant**, and select **Create**.

### 🔌 Attach the integration

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

### 🔐 Attach the authorizer

1. In the left menu, select **Authorization**, select the **POST /assistant** route, choose **psb-lab-cognito-authorizer** from the list, and select **Attach authorizer**.

   > ℹ️ **Info:** The **$default** stage has automatic deployment turned on, so the new route is live straight away.

### 💬 Enable the chat panel

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

   <validation step="e1a21ce3-4651-45b5-9ae9-cd24b2830886" />

## 📝 Summary

In this lab, you:

- Enabled **Amazon Nova Lite** and tested it in the playground and with the Converse API.
- Built **psb-assistant**, which uses Bedrock tool use (**get_sensor_stats**) to fetch real data from **psb-query-telemetry**.
- Restricted it with **psb-lab-assistant-policy** to one model and one function.
- Published **POST /assistant** behind the Cognito JWT authorizer and enabled the dashboard chat panel.

Click **Next** to continue.
