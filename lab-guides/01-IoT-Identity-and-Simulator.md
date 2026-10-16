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
@media (prefers-reduced-motion:reduce){.psbgs *,.psbgs *::before,.psbgs *::after{animation:none!important;transition:none!important}}
</style>

<div class="psbgs">

<div class="psb-hero" style="position:relative;overflow:hidden;border-radius:16px;padding:28px 20px 24px;margin:0 0 6px;text-align:center;color:#ffffff;background:linear-gradient(120deg,#070b1a,#121a3a,#0d2b36,#16123a);">
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 01: Provision the IoT Device Identity and Connect the Simulated Raspberry Pi</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">45 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;10 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

In this lab you will give your sensor gateway an identity that AWS IoT Core will trust. You will register the device as a Thing, generate an X.509 certificate and private key, attach a least-privilege IoT policy that permits exactly one client ID and one topic, and then start the Raspberry Pi simulator on your Lab VM so that it connects over MQTT with mutual TLS and begins publishing telemetry.

This is the foundation of everything that follows. Certificate-based mutual TLS is how production IoT fleets authenticate: the device proves who it is with a private key it never transmits, and AWS proves who it is with a server certificate the device validates against the Amazon Root CA. By the end of this lab you will be watching live sensor readings arrive in the AWS IoT Core MQTT test client.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Lab Objectives

You will be able to complete the following tasks:

- Task 1: Register the device and generate its certificate
- Task 2: Author and attach a least-privilege IoT policy
- Task 3: Run the Raspberry Pi simulator and verify telemetry

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Register the Device and Generate Its Certificate

In this task you will create an AWS IoT Core Thing to represent your sensor gateway and generate the X.509 key pair it will use to authenticate.

1. In the AWS Management Console search bar, type **IoT Core** and select **AWS IoT Core** from the results.

1. In the left-hand navigation pane, expand **Connect** and click **Connect one device**.

1. On the **Prepare your device** page, click **Next**.

1. On the **Register and secure your device** page, select **Create a new thing**. For **Thing name**, enter the following, then click **Next**:

   - **Thing name:** **psb-lab-sensor-01**

   > **Note:** The Thing name must be exactly **psb-lab-sensor-01**. The simulator, the IoT policy and the validation all refer to it by this name.

1. On the **Choose platform and SDK** page, select **Linux / macOS** as the device platform and **Python** as the AWS IoT Device SDK, then click **Next**.

   > **Note:** You are selecting Linux/Python because that is what a Raspberry Pi runs, and the simulator uses the same Python MQTT client. The certificate AWS generates is platform-independent.

1. On the **Download connection kit** page, click **Download connection kit**. A file named **connect_device_package.zip** will download.

1. Click **Next**, then click **Continue** to leave the wizard. You do not need to run the wizard's own start script; you will use the lab's simulator instead.

1. On the Lab VM, open **File Explorer**, navigate to your **Downloads** folder, right-click **connect_device_package.zip** and select **Extract All**. Extract it to:

   ```text
   C:\psb-lab-assets\simulator\certs
   ```

1. Confirm that the **certs** folder now contains the following four files. The exact filenames begin with your certificate ID, which will differ from the example:

   | File | Purpose |
   |---|---|
   | psb-lab-sensor-01.cert.pem | The device's public certificate |
   | psb-lab-sensor-01.private.key | The device's private key (never leaves the device) |
   | psb-lab-sensor-01.public.key | The device's public key |
   | root-CA.crt | The Amazon Root CA the device uses to verify AWS |

   > **Note:** If the extracted files have long certificate-ID prefixes such as **a1b2c3d4-certificate.pem.crt**, rename them to the names in the table above. The simulator expects those exact names.

1. Return to the AWS IoT Core console. In the left-hand navigation pane, expand **Manage**, expand **All devices**, and click **Things**.

1. Confirm that **psb-lab-sensor-01** appears in the list with a status of **Active**.

1. Click **psb-lab-sensor-01**, then open the **Certificates** tab. Confirm that one certificate is listed and that its status is **Active**. If it shows **Inactive**, select it, click **Actions** and choose **Activate**.

1. You will also need your account's IoT data endpoint. In the left-hand navigation pane, scroll down and click **Settings**.

1. Under **Device data endpoint**, copy the **Endpoint** value. It looks like:

   ```text
   a1b2c3d4e5f6g7-ats.iot.ap-southeast-1.amazonaws.com
   ```

   Paste it into a notepad; you will need it in Task 3 and again in Lab 02.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Author and Attach a Least-Privilege IoT Policy

A certificate proves who the device is. An IoT policy decides what it may do. In this task you will write a policy that permits your device to connect under exactly one client ID and publish to exactly one topic, and nothing else.

1. In the AWS IoT Core console, in the left-hand navigation pane, expand **Security** and click **Policies**.

1. Click **Create policy**.

1. For **Policy name**, enter:

   - **Policy name:** **psb-lab-device-policy**

1. Under **Policy document**, click the **JSON** tab.

1. Replace the entire contents of the editor with the policy below. Replace `<AWS-REGION>` with **<inject key="LabRegion" enableCopy="false"/>** and `<AWS-ACCOUNT-ID>` with your account ID from the **Environment** tab (**<inject key="AWSAccountId" enableCopy="true"/>**).

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

   > **Note:** This policy is the opposite of the `"Resource": "*"` policy the quick-start wizard suggests. Notice that Subscribe uses a `topicfilter/` ARN while Receive uses a `topic/` ARN: this is a genuine and frequently-missed distinction in AWS IoT policy authoring. A compromised device holding this certificate cannot read another device's data, cannot publish to another device's topic, and cannot impersonate a different client ID.

1. Click **Create**.

1. In the left-hand navigation pane, expand **Security** and click **Certificates**.

1. Click the certificate ID of the certificate you created in Task 1.

1. On the certificate detail page, open the **Policies** tab. If a policy from the connection-kit wizard is already attached, select it, click **Actions** and choose **Detach**, then confirm.

1. Click **Attach policies**.

1. Select the checkbox next to **psb-lab-device-policy** and click **Attach policies**.

1. Confirm that the **Policies** tab now lists **psb-lab-device-policy** and nothing else.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 3: Run the Raspberry Pi Simulator and Verify Telemetry

In this task you will start the device simulator, watch it establish a mutual-TLS MQTT connection, and confirm in the AWS IoT Core MQTT test client that readings are arriving.

1. On the Lab VM, open the **Start** menu, type **PowerShell**, and select **Windows PowerShell**.

1. Navigate to the simulator folder and install its one dependency:

   ```powershell
   cd C:\psb-lab-assets\simulator
   pip install -r requirements.txt
   ```

   > **Note:** **requirements.txt** contains a single line, **paho-mqtt**. This is the same MQTT client library a Raspberry Pi deployment would use.

1. Open **simulate_pi.py** in VS Code to see what it does. The core of the file is reproduced below; you do not need to change it, but read the highlighted parts:

   ```python
   #!/usr/bin/env python3
   """
   PSB Academy CloudLab - Raspberry Pi sensor gateway simulator.

   Publishes JSON telemetry to AWS IoT Core over MQTT with mutual TLS,
   using the same X.509 certificate a physical Raspberry Pi would use.
   """
   import argparse, json, math, random, signal, ssl, sys, time
   import paho.mqtt.client as mqtt

   TOPIC_TEMPLATE = "psb/lab/{device_id}/telemetry"
   SENSORS = ["north-lab", "south-lab", "server-room"]

   def build_client(device_id, endpoint, certs_dir):
       client = mqtt.Client(client_id=device_id, protocol=mqtt.MQTTv311)
       client.tls_set(
           ca_certs=f"{certs_dir}/root-CA.crt",
           certfile=f"{certs_dir}/{device_id}.cert.pem",
           keyfile=f"{certs_dir}/{device_id}.private.key",
           tls_version=ssl.PROTOCOL_TLSv1_2,
       )
       client.on_connect = lambda c, u, f, rc: print(
           f"[mqtt] connect rc={rc} ({mqtt.connack_string(rc)})"
       )
       client.connect(endpoint, 8883, keepalive=60)
       return client

   def reading(location, t, anomaly_rate):
       """Diurnal baseline + noise, with occasional injected anomalies."""
       phase = (t % 86400) / 86400 * 2 * math.pi
       temp = 22.0 + 3.0 * math.sin(phase) + random.gauss(0, 0.35)
       hum = 55.0 - 6.0 * math.sin(phase) + random.gauss(0, 1.2)
       co2 = 480.0 + 120.0 * max(0.0, math.sin(phase)) + random.gauss(0, 25)
       vib = abs(random.gauss(0.02, 0.006))

       is_anomaly = random.random() < anomaly_rate
       if is_anomaly:
           kind = random.choice(["heat", "co2", "vibration"])
           if kind == "heat":
               temp += random.uniform(8, 14)
           elif kind == "co2":
               co2 += random.uniform(600, 1200)
           else:
               vib += random.uniform(0.12, 0.30)

       return {
           "device_id": "psb-lab-sensor-01",
           "location": location,
           "ts": int(t),
           "temperature_c": round(temp, 2),
           "humidity_pct": round(hum, 2),
           "co2_ppm": round(co2, 1),
           "vibration_g": round(vib, 4),
           "injected_anomaly": is_anomaly,
       }

   def main():
       p = argparse.ArgumentParser()
       p.add_argument("--endpoint", required=True)
       p.add_argument("--device-id", default="psb-lab-sensor-01")
       p.add_argument("--certs-dir", default="certs")
       p.add_argument("--interval", type=float, default=10.0)
       p.add_argument("--anomaly-rate", type=float, default=0.02)
       p.add_argument("--backfill-hours", type=float, default=0.0,
                      help="Publish this many hours of synthetic history, then stop.")
       a = p.parse_args()

       client = build_client(a.device_id, a.endpoint, a.certs_dir)
       topic = TOPIC_TEMPLATE.format(device_id=a.device_id)
       client.loop_start()

       running = {"go": True}
       signal.signal(signal.SIGINT, lambda *_: running.update(go=False))

       if a.backfill_hours > 0:
           now, step = time.time(), a.interval
           n = int(a.backfill_hours * 3600 / step)
           print(f"[sim] back-filling {n} readings over {a.backfill_hours} h ...")
           for i in range(n):
               t = now - (n - i) * step
               msg = reading(SENSORS[i % len(SENSORS)], t, a.anomaly_rate)
               client.publish(topic, json.dumps(msg), qos=1)
               if i % 100 == 0:
                   print(f"[sim] {i}/{n}")
               time.sleep(0.02)
           print("[sim] back-fill complete.")
           client.loop_stop(); client.disconnect(); return

       print(f"[sim] publishing to {topic} every {a.interval}s. Ctrl+C to stop.")
       i = 0
       while running["go"]:
           msg = reading(SENSORS[i % len(SENSORS)], time.time(), a.anomaly_rate)
           client.publish(topic, json.dumps(msg), qos=1)
           print(f"[sim] {msg['location']:>12}  "
                 f"{msg['temperature_c']:>6.2f} C  {msg['co2_ppm']:>7.1f} ppm"
                 f"{'   <-- ANOMALY' if msg['injected_anomaly'] else ''}")
           i += 1
           time.sleep(a.interval)

       client.loop_stop(); client.disconnect()

   if __name__ == "__main__":
       main()
   ```

   The three things to notice:

   - `client.tls_set(...)` is the mutual-TLS handshake. The device presents `certfile` and proves possession of `keyfile`; it validates AWS against `ca_certs`.
   - `client_id=device_id` must match the `client/psb-lab-sensor-01` ARN in your policy, or the broker will refuse the connection.
   - `injected_anomaly` is present only so you can sanity-check Phase II later. Your model never sees this field; it is stripped before training.

1. Start the simulator. Replace `<IOT-ENDPOINT>` with the device data endpoint you copied in Task 1:

   ```powershell
   python simulate_pi.py --endpoint <IOT-ENDPOINT> --certs-dir certs --interval 10
   ```

1. Within a few seconds you should see:

   ```text
   [mqtt] connect rc=0 (Connection Accepted.)
   [sim] publishing to psb/lab/psb-lab-sensor-01/telemetry every 10.0s. Ctrl+C to stop.
   [sim]    north-lab   22.84 C   531.2 ppm
   [sim]    south-lab   23.11 C   548.9 ppm
   ```

   > **Troubleshooting:** If you see **rc=5 (Connection Refused: not authorised)**, the certificate is inactive or the policy is not attached; revisit Task 2. If the connection hangs, check that you used the device data endpoint (ending `-ats.iot.ap-southeast-1.amazonaws.com`) and not the credentials endpoint.

1. Leave this PowerShell window running. Open a second PowerShell window for the rest of the lab.

1. Return to the AWS IoT Core console. In the left-hand navigation pane, click **MQTT test client**.

1. On the **Subscribe to a topic** tab, in the **Topic filter** box, enter the following and click **Subscribe**:

   - **Topic filter:** **psb/lab/+/telemetry**

   > **Note:** The `+` is a single-level MQTT wildcard. It matches any device ID at that position, which is how a real fleet subscription is written.

1. Within ten seconds you should see messages appearing, each expandable to show a JSON payload like:

   ```json
   {
     "device_id": "psb-lab-sensor-01",
     "location": "north-lab",
     "ts": 1789012345,
     "temperature_c": 22.84,
     "humidity_pct": 53.11,
     "co2_ppm": 531.2,
     "vibration_g": 0.0213,
     "injected_anomaly": false
   }
   ```

1. Let the simulator run for at least two minutes before validating, so that the AWS IoT Core **PublishIn.Success** metric has data points.

   > **Concept note: where AWS IoT Greengrass would fit.** If this device needed to keep working during a network outage, run local inference, or aggregate several downstream sensors before publishing, you would install AWS IoT Greengrass on the Raspberry Pi. Greengrass gives the device a local Lambda runtime, a local message broker and a local ML inference engine, then syncs with AWS IoT Core when connectivity returns. It is out of scope for this lab because it requires managed edge hardware, but the certificate and policy you just created are exactly what a Greengrass core device uses to register.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="4a7868a3-a363-44f0-990c-e45b7e2c1324" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you have completed the following:

- Registered an AWS IoT Core Thing and generated an X.509 device certificate.
- Authored a least-privilege IoT policy scoped to a single client ID and a single topic, and attached it to the certificate.
- Connected the Raspberry Pi simulator over MQTT with mutual TLS and verified live telemetry in the MQTT test client.

You have successfully completed the lab. Click **Next** to continue to the next lab.

</div>

</div>
