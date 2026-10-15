<h1 align="center">🔭 Lab 09: Observability, Security Review and Teardown</h1>
<p align="center"><b>AWS Demo || Bedrock with Claude</b> | ⏱️ <b>Estimated Timing: 40 Minutes</b></p>

---

## 🎯 Overview

Your platform is complete: devices, ingestion, API, dashboard, machine learning and a generative AI assistant. In this final lab, you make it operable and safe: set log retention, search logs, alert when the scoring pipeline stalls, review security choices, review cost drivers, and tear down the expensive resources.

## 📋 Objectives

In this lab, you will complete the following tasks:

1. 📈 **Task 1:** Configure log retention, search logs, and create a metric filter and alarm.
1. 🛡️ **Task 2:** Review the security posture.
1. 💰 **Task 3:** Review costs and tear down.

---

## 🧩 Task 1: Configure log retention, search logs, and create a metric filter and alarm

🎯 **Goal:** Keep logs for a sensible period and get alerted when scoring stops.

### 🗂️ Set log retention

1. Open **CloudWatch** > **Logs** > **Log groups** and filter on **/aws/lambda/psb-**.

1. For each log group below, select it, select **Actions** > **Edit retention setting(s)**, choose **1 week (7 days)**, and select **Save**:

   | Log group | Retention |
   |---|---|
   | /aws/lambda/psb-ingest-telemetry | 1 week |
   | /aws/lambda/psb-query-telemetry | 1 week |
   | /aws/lambda/psb-score-telemetry | 1 week |
   | /aws/lambda/psb-assistant | 1 week |

   > 💡 **Tip:** Lambda log groups default to **Never expire**, which slowly grows storage cost.

### 🔎 Search the logs

1. Select **Logs** > **Logs Insights**, choose the log group **/aws/lambda/psb-ingest-telemetry**, set the time range to **1h**, enter this query, and select **Run query**:

   ```text
   fields @timestamp, @message
   | filter @message like /ERROR|Error|Traceback|Task timed out/
   | sort @timestamp desc
   | limit 20
   ```

1. Change the filter line to `| filter @message like /\[ok\] wrote/` and run it again to see successful writes.

   > ℹ️ **Info:** You can also open the log group and use **Search all log streams** with a filter pattern such as **"[ok] wrote"** or **ERROR**.

### 🧮 Create the metric filter

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

### 🚨 Create the alarm

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

---

## 🧩 Task 2: Review the security posture

🎯 **Goal:** Understand which demo shortcuts you took and how you would harden them for production.

1. Open **Secrets Manager** > **psb/influxdb/admin-token** and note that **Rotation** is **Disabled**.

1. Open **Timestream** > **InfluxDB databases** > **psb-lab-influx** and note **Publicly accessible: Yes**.

1. Open **IAM** > **Roles**, search for **psb**, and review the inline policy of each of the 5 roles below.

1. Compare your findings with this table:

   | Area | Lab setting | Risk | Production recommendation |
   |---|---|---|---|
   | 🔑 **Secret psb/influxdb/admin-token** | Rotation off, admin (operator) token | Long-lived, all-powerful token | Enable rotation; use a scoped write token for ingest and a read token for query. |
   | 🗄️ **InfluxDB psb-lab-influx** | Publicly accessible, port 8086 open in psb-lab-influx-sg | Internet exposure | Private subnets only; run Lambdas in the VPC; restrict the security group to the Lambda security group. |
   | 🛰️ **psb-lab-iot-rule-role** | Inline **psb-lab-iot-rule-s3-write**: s3:PutObject on raw/* only | Low | ✅ Least privilege. Trust only iot.amazonaws.com. |
   | 📥 **psb-ingest-telemetry role** | Basic Lambda execution + **psb-lab-read-influx-token** (GetSecretValue on one secret) | Low | ✅ Least privilege. Use a write-only Influx token. |
   | 📤 **psb-query-telemetry role** | Basic Lambda execution + **psb-lab-read-influx-token** | Low | ✅ Least privilege. Use a read-only Influx token. Allow-listed metrics and locations prevent Flux injection. |
   | 🧮 **psb-score-telemetry role** | Basic Lambda execution + **psb-lab-score-telemetry-policy** (secret, endpoint/psb-anomaly-endpoint, curated/*) | Low | ✅ Least privilege. Scope S3 further to curated/scored/*. |
   | 🤖 **psb-assistant role** | Basic Lambda execution + **psb-lab-assistant-policy** (one model ARN, one function ARN) | Low | ✅ Least privilege. Add Bedrock Guardrails and rate limits on the API. |
   | 🔐 **Device psb-lab-sensor-01** | Only **psb-lab-device-policy** on its certificate | Low | ✅ Own client ID and topics only. Rotate certificates. |
   | 🌐 **API and dashboard** | JWT authorizer on all routes, CORS origin * | Medium (CORS) | Restrict CORS origin to the Amplify domain. |

   > 💡 **Tip:** The 4 Lambda execution roles were created by the console with names like **psb-score-telemetry-role-xxxxxxxx**.

✅ **Expected result:** You can explain each finding and the production fix.

---

## 🧩 Task 3: Review costs and tear down

🎯 **Goal:** Know what drives cost and stop or delete the hourly billed resources.

1. Review the main cost drivers in this lab:

   | Resource | Billing basis | Relative cost | Teardown action |
   |---|---|---|---|
   | 🗄️ **Timestream for InfluxDB psb-lab-influx** (db.influx.medium, 20 GiB, 3000 IOPS) | Per instance hour + storage | 🔴 High | Delete |
   | 🧪 **SageMaker space psb-lab-space** (ml.t3.medium) | Per hour while running | 🟠 Medium | Stop |
   | 🚀 **Serverless endpoint psb-anomaly-endpoint** (2048 MB) | Per inference duration + data processed | 🟡 Low (idle) | Delete |
   | 🏋️ **RCF training job** (ml.m5.large) | Per second of training (already finished) | 🟢 One time | None |
   | 🖥️ **Lab VM** (t3.medium) | Per hour | 🟠 Medium | Managed by CloudLabs |
   | 🛰️ **IoT Core, Lambda, API Gateway, EventBridge** | Per message / request | 🟢 Very low | Stop simulator, disable rule |
   | 🤖 **Bedrock Nova Lite** | Per input/output token | 🟢 Very low | None |
   | 📦 **S3, CloudWatch Logs, Amplify** | Per GB stored / served | 🟢 Very low | Retention set in Task 1 |

1. **Stop the simulator:** in the PowerShell window running **simulate_pi.py**, press **Ctrl+C**.

1. **Stop the space:** open **SageMaker AI** > **Studio** > **Open Studio** > **JupyterLab**, and select **Stop** on **psb-lab-space**. This deletes the running JupyterLab app; the space and its files remain.

1. **Delete the endpoint:** in the SageMaker AI console, select **Inference** > **Endpoints**, select **psb-anomaly-endpoint**, then **Actions** > **Delete** and confirm. Then select **Inference** > **Endpoint configurations**, select the configuration used by the endpoint, and delete it too.

1. **Disable the IoT rule:** open **AWS IoT Core** > **Message routing** > **Rules**, select **psb_telemetry_rule**, then select **Deactivate** (shown as **Disable** in some console versions) and confirm. The rule status changes to **Inactive**.

1. **Delete InfluxDB:** open **Timestream** > **InfluxDB databases**, select **psb-lab-influx**, and select **Delete**. If asked, do not create a final snapshot, type **delete me** to confirm, and select **Delete**.

   > ⚠️ **Note:** Deleting the InfluxDB instance is permanent. The dashboard and API stop returning data after this step. That is expected.

1. Tick off your teardown checklist:

   | | Teardown item |
   |---|---|
   | ⬜ | Simulator stopped (Ctrl+C) |
   | ⬜ | Space **psb-lab-space** stopped (JupyterLab app deleted) |
   | ⬜ | Endpoint **psb-anomaly-endpoint** deleted |
   | ⬜ | Endpoint configuration deleted |
   | ⬜ | Rule **psb_telemetry_rule** disabled |
   | ⬜ | InfluxDB **psb-lab-influx** deleted (status **Deleting** is fine) |

   ✅ **Expected result:** Observability is configured from Task 1 and every item in the teardown checklist is done.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="027c2deb-6e02-4002-a48b-92c92d1dcb95" />

## 📝 Summary

In this lab, you:

- Set 1 week retention on the 4 Lambda log groups and searched logs with Logs Insights.
- Created the metric filter **psb-lab-anomaly-batches** and the alarm **psb-lab-scoring-pipeline-stalled**.
- Reviewed the secret, InfluxDB exposure and the 5 IAM roles for least privilege.
- Reviewed cost drivers and tore down the hourly billed resources.

## 🏁 You Did It!

Across 9 labs you built an end to end AWS platform in ap-southeast-1:

| Phase | What you built |
|---|---|
| **I. Connect, ingest, serve** | IoT Core device identity, Rules Engine to InfluxDB and S3, query API, Cognito sign-in, Amplify dashboard |
| **II. Machine learning** | SageMaker Random Cut Forest model, serverless endpoint, scheduled scoring pipeline |
| **III. Generative AI and operations** | Bedrock tool use assistant, CloudWatch observability, security and cost review |

Need help? Contact cloudlabs-support@spektrasystems.com. We are available 24/7.

## 🎉 Happy Learning!
