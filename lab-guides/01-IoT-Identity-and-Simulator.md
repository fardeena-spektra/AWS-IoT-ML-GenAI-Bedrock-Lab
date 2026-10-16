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
<div class="psb-sub" style="color:#f2cc6b;font-weight:700;letter-spacing:.08em;text-align:center;">Lab 01: IoT Identity and Device Simulator</div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">45 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;10 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

Every IoT solution starts with a trusted device identity. In this lab, you register a sensor in **AWS IoT Core**, download its X.509 certificate, lock it down with a least-privilege IoT policy, and run a Python simulator on the lab VM that publishes telemetry over MQTT (TLS on port 8883).

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Objectives

- **Task 1:** Register the device with the **Connect one device** wizard and download the connection kit.
- **Task 2:** Create a least-privilege device policy and make it the only policy on the certificate.
- **Task 3:** Run the simulator and watch the messages arrive in the MQTT test client.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🏗️</span>What you build

```text
simulate_pi.py (lab VM) ──MQTT/TLS 8883──> AWS IoT Core ──> topic psb/lab/psb-lab-sensor-01/telemetry
        (X.509 certificate + psb-lab-device-policy)
```

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📦</span>Device data contract

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

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Register the Device with "Connect one device"

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

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Create a Least-Privilege Device Policy

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

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 3: Run the Simulator and Watch the Telemetry

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

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you:

- Registered the thing **psb-lab-sensor-01** with an active X.509 certificate.
- Created **psb-lab-device-policy**, a least-privilege policy scoped to the device's own client ID and topics, and made it the only policy on the certificate.
- Ran the Python simulator from the lab VM and watched live telemetry in the MQTT test client.
- Generated **PublishIn.Success** metrics in IoT Core.

Click **Next** to continue.

</div>

</div>
