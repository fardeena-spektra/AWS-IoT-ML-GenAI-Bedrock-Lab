<h1 align="center">🛰️ Lab 01: IoT Identity and Device Simulator</h1>
<p align="center"><b>AWS Demo || Bedrock with Claude</b> | ⏱️ <b>Estimated Timing: 45 Minutes</b> | 🏆 <b>Points: 10</b></p>

---

## 🎯 Overview

Every IoT solution starts with a trusted device identity. In this lab, you register a sensor in **AWS IoT Core**, download its X.509 certificate, lock it down with a least-privilege IoT policy, and run a Python simulator on the lab VM that publishes telemetry over MQTT (TLS on port 8883).

## 📋 Objectives

- **Task 1:** Register the device with the **Connect one device** wizard and download the connection kit.
- **Task 2:** Create a least-privilege device policy and make it the only policy on the certificate.
- **Task 3:** Run the simulator and watch the messages arrive in the MQTT test client.

## 🏗️ What you build

```text
simulate_pi.py (lab VM) ──MQTT/TLS 8883──> AWS IoT Core ──> topic psb/lab/psb-lab-sensor-01/telemetry
        (X.509 certificate + psb-lab-device-policy)
```

### 📦 Device data contract

| Item | Value |
|---|---|
| Thing / client ID | **psb-lab-sensor-01** |
| Telemetry topic | **psb/lab/psb-lab-sensor-01/telemetry** |
| Command topic | **psb/lab/psb-lab-sensor-01/commands** |
| Locations (cycled) | **north-lab**, **south-lab**, **server-room** |
| Fields | **temperature_c**, **humidity_pct**, **co2_ppm**, **vibration_g**, **injected_anomaly** |

Sample telemetry message:

```json
{"device":"psb-lab-sensor-01","location":"north-lab","timestamp":1760520000000,
 "temperature_c":22.41,"humidity_pct":45.2,"co2_ppm":612.0,"vibration_g":0.021,"injected_anomaly":false}
```

> ℹ️ **Info:** **timestamp** is epoch milliseconds. About 2% of readings are injected anomalies (spikes in one or more fields) with **injected_anomaly** set to **true**. You use these labels in Lab 06 to measure the model.

---

## 🧩 Task 1: Register the Device with "Connect one device"

🎯 **Goal:** Create the thing **psb-lab-sensor-01**, its certificate, and download the connection kit.

1. In the AWS console search bar, type **IoT Core** and open **IoT Core**. Confirm the region is **Asia Pacific (Singapore)**.

1. On the IoT Core home page, under **Connect**, select **Connect one device** (or from the left menu choose **Connect** > **Connect one device**).

1. On **Step 1: Prepare your device**, review the information (the page shows a ping test to your device data endpoint) and click **Next**.

1. On **Step 2: Register and secure your device**, enter:

   | Setting | Value |
   |---|---|
   | Thing | **Create a new thing** |
   | Thing name | **psb-lab-sensor-01** |

   Leave the other options as default and click **Next**.

1. On **Step 3: Choose a platform and SDK**, select:

   | Setting | Value |
   |---|---|
   | Device platform operating system | **Linux / macOS** |
   | AWS IoT Device SDK | **Python** |

   Click **Next**.

1. On **Step 4: Download connection kit**, click **Download connection kit**. The file **connect_device_package.zip** is saved to your **Downloads** folder. Click **Next**.

1. On **Step 5: Run connection kit**, you do not need to run the Linux commands. Click **Continue** (or **View thing**) to finish the wizard.

   > ℹ️ **Info:** The wizard creates the thing, an X.509 certificate (already **Active**) and a broad starter policy named **psb-lab-sensor-01-Policy**. You replace that policy with a least-privilege one in Task 2.

1. On the lab VM, open **File Explorer**, right-click **Downloads\connect_device_package.zip** and select **Extract All**. Extract the files to:

   ```text
   C:\psb-lab-assets\simulator\certs
   ```

1. Confirm the **certs** folder contains these files:

   | File | Purpose |
   |---|---|
   | **psb-lab-sensor-01.cert.pem** | Device certificate |
   | **psb-lab-sensor-01.private.key** | Device private key (keep secret) |
   | **psb-lab-sensor-01.public.key** | Device public key |
   | **root-CA.crt** | Amazon Root CA 1 |

   > ⚠️ **Note:** If **root-CA.crt** is missing (the Linux start script normally downloads it), open this URL in the browser and save the file as **root-CA.crt** in the **certs** folder:
   >
   > https://www.amazontrust.com/repository/AmazonRootCA1.pem
   >
   > Make sure Windows does not add **.pem** or **.txt** to the file name.

1. Back in IoT Core, in the left menu select **Settings**. Under **Device data endpoint**, copy the **Endpoint** value and save it in Notepad as **IOT-ENDPOINT**. It looks like:

   ```text
   xxxxxxxxxxxxxx-ats.iot.ap-southeast-1.amazonaws.com
   ```

✅ **Expected result:** The thing **psb-lab-sensor-01** exists, the certificate files are in **C:\psb-lab-assets\simulator\certs**, and you have the device data endpoint ending with **-ats.iot.ap-southeast-1.amazonaws.com**.

---

## 🧩 Task 2: Create a Least-Privilege Device Policy

🎯 **Goal:** Allow the device to connect only as itself, publish only to its own telemetry topic, and subscribe/receive only on its own command topic.

1. Find your **AWS account ID**: click your user name in the top-right corner of the console and copy the 12-digit **Account ID**.

1. In IoT Core, from the left menu select **Security** > **Policies**, then click **Create policy**.

1. Enter the policy name:

   | Setting | Value |
   |---|---|
   | Policy name | **psb-lab-device-policy** |

1. Under **Policy document**, select the **JSON** tab, delete the existing content and paste the policy below (also available in **C:\psb-lab-assets\policies\psb-lab-device-policy.json**). Replace **&lt;AWS-REGION&gt;** with **ap-southeast-1** and **&lt;AWS-ACCOUNT-ID&gt;** with your account ID.

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "AllowConnectAsThisDeviceOnly",
         "Effect": "Allow",
         "Action": "iot:Connect",
         "Resource": "arn:aws:iot:<AWS-REGION>:<AWS-ACCOUNT-ID>:client/psb-lab-sensor-01"
       },
       {
         "Sid": "AllowPublishToOwnTelemetryTopicOnly",
         "Effect": "Allow",
         "Action": "iot:Publish",
         "Resource": "arn:aws:iot:<AWS-REGION>:<AWS-ACCOUNT-ID>:topic/psb/lab/psb-lab-sensor-01/telemetry"
       },
       {
         "Sid": "AllowSubscribeToOwnCommandTopicOnly",
         "Effect": "Allow",
         "Action": "iot:Subscribe",
         "Resource": "arn:aws:iot:<AWS-REGION>:<AWS-ACCOUNT-ID>:topicfilter/psb/lab/psb-lab-sensor-01/commands"
       },
       {
         "Sid": "AllowReceiveOnOwnCommandTopicOnly",
         "Effect": "Allow",
         "Action": "iot:Receive",
         "Resource": "arn:aws:iot:<AWS-REGION>:<AWS-ACCOUNT-ID>:topic/psb/lab/psb-lab-sensor-01/commands"
       }
     ]
   }
   ```

   **What this policy does:**

   | Statement | Effect |
   |---|---|
   | **iot:Connect** on **client/psb-lab-sensor-01** | The certificate can only connect with client ID **psb-lab-sensor-01**. |
   | **iot:Publish** on **topic/.../telemetry** | The device can publish only to its own telemetry topic. |
   | **iot:Subscribe** on **topicfilter/.../commands** | The device can subscribe only to its own command topic. |
   | **iot:Receive** on **topic/.../commands** | The device can receive messages only from its own command topic. |

1. Click **Create**.

1. From the left menu select **Security** > **Certificates**, and open the certificate attached to **psb-lab-sensor-01** (you can also open **All devices** > **Things** > **psb-lab-sensor-01** > **Certificates** tab). Confirm **Status** is **Active**.

1. On the certificate page, open the **Policies** tab and click **Attach policies**. Select **psb-lab-device-policy** and click **Attach policies**.

1. Still on the **Policies** tab, select the wizard-created policy **psb-lab-sensor-01-Policy** and click **Detach**, then confirm **Detach**.

   > ⚠️ **Note:** **psb-lab-device-policy** must be the **only** policy attached to the certificate. The validation fails if the broad wizard policy is still attached.

✅ **Expected result:** The certificate is **Active** and has exactly one policy attached: **psb-lab-device-policy**.

---

## 🧩 Task 3: Run the Simulator and Watch the Telemetry

🎯 **Goal:** Publish live telemetry from the lab VM and see it in the MQTT test client.

1. On the lab VM, open **PowerShell** and install the simulator dependency (**paho-mqtt**):

   ```powershell
   cd C:\psb-lab-assets\simulator
   pip install -r requirements.txt
   ```

1. Start the simulator. Replace **&lt;IOT-ENDPOINT&gt;** with the device data endpoint from Task 1:

   ```powershell
   python simulate_pi.py --endpoint <IOT-ENDPOINT> --certs-dir certs --interval 10
   ```

   **What this script does:** it finds the **\*.cert.pem**, **\*.private.key** and **root-CA.crt** files in the **certs** folder, connects to AWS IoT Core over MQTT/TLS with client ID **psb-lab-sensor-01**, and publishes one reading every 10 seconds, cycling through **north-lab**, **south-lab** and **server-room**. About 2% of readings are injected anomalies.

1. Confirm the output shows a successful connection:

   ```text
   rc=0 (Connection Accepted.)
   ```

   | Return code | Meaning / fix |
   |---|---|
   | **rc=0** | Connection accepted. All good. |
   | **rc=5** | Not authorised: the certificate is **inactive** or the **policy is missing** from the certificate. Recheck Task 2. |

1. Leave the PowerShell window running. In the IoT Core console, from the left menu select **Test** > **MQTT test client**.

1. On the **Subscribe to a topic** tab, enter the topic filter below and click **Subscribe**:

   | Setting | Value |
   |---|---|
   | Topic filter | **psb/lab/+/telemetry** |

1. Confirm new JSON messages appear every 10 seconds under **Subscriptions**.

   > 💡 **Tip:** The **+** wildcard matches a single topic level, so this filter would match every sensor that follows the **psb/lab/&lt;device&gt;/telemetry** pattern.

1. Keep the simulator running for **at least 2 minutes** so the IoT metric **PublishIn.Success** has data. You can view it from the left menu under **Monitor**.

   > ℹ️ **Info:** **Concept note: AWS IoT Greengrass.** In production, a gateway at the edge can run **AWS IoT Greengrass** to filter, buffer and process data locally before sending it to the cloud. This lab uses a direct MQTT connection instead (concept only, no Greengrass setup).

   > ⚠️ **Note:** Keep the simulator running for the rest of the lab. If you close PowerShell, rerun the two commands above.

   ✅ **Expected result:** The simulator shows **rc=0 (Connection Accepted.)**, messages appear in the MQTT test client, and **PublishIn.Success** has data points.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="4a7868a3-a363-44f0-990c-e45b7e2c1324" />

## 📝 Summary

In this lab, you:

- Registered the thing **psb-lab-sensor-01** with an active X.509 certificate.
- Created **psb-lab-device-policy**, a least-privilege policy scoped to the device's own client ID and topics, and made it the only policy on the certificate.
- Ran the Python simulator from the lab VM and watched live telemetry in the MQTT test client.
- Generated **PublishIn.Success** metrics in IoT Core.

Click **Next** to continue.
