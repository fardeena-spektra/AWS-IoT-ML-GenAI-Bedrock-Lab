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
<div class="psb-sub" style="color:#f2cc6b;font-weight:700;letter-spacing:.08em;text-align:center;">Lab 05: AWS Amplify Dashboard</div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">45 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;9 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

Your telemetry API is now protected by Amazon Cognito. In this lab, you give operators a friendly way to see the data: a small **React** dashboard that signs users in through the Cognito Hosted UI, calls your API with the user's token, and draws live charts. You build it on the lab VM and host it on **AWS Amplify Hosting** using **Deploy without Git**.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Objectives

In this lab, you will complete the following tasks:

1. 🛠️ **Task 1:** Configure and build the dashboard.
1. 🚀 **Task 2:** Deploy the dashboard to Amplify and connect it to Cognito.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🏗️</span>What you build

```text
Browser ──► Amplify (https://main.<appid>.amplifyapp.com/)
   │            │
   │            └─► Cognito Hosted UI (sign in, id_token)
   │
   └─► API Gateway psb-lab-api (Authorization: Bearer <id_token>) ──► psb-query-telemetry ──► InfluxDB
```

> ⚠️ **Note:** Keep the simulator from Lab 01 running so the charts have fresh data. Work in the **Asia Pacific (Singapore) ap-southeast-1** region throughout.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Configure and Build the Dashboard

🎯 **Goal:** Point the dashboard at your Cognito user pool and API, then produce a deployable zip file.

1. Gather the values you recorded in Lab 03 and Lab 04:

   | Value | Where to find it | Example format |
   |---|---|---|
   | **User pool ID** | Cognito > User pools > **psb-lab-users** > Overview | ap-southeast-1_AbCdEf123 |
   | **Client ID** | Cognito > **psb-lab-users** > App clients > **psb-lab-dashboard** | 1a2b3c4d5e6f7g8h9i0j |
   | **Cognito domain** | Cognito > **psb-lab-users** > Branding > Domain | https://psb-lab-<inject key="DeploymentID" enableCopy="false"/>.auth.ap-southeast-1.amazoncognito.com |
   | **API URL** | API Gateway > **psb-lab-api** > Stages > **$default** > Invoke URL | https://abc123.execute-api.ap-southeast-1.amazonaws.com |

1. On the lab VM, open **VS Code** and open the file **C:\psb-lab-assets\dashboard\src\config.js**.

1. The file looks like this. Replace only the placeholder values inside the quotes and keep the rest of the file (including **export default config;**) unchanged:

   ```javascript
   const config = {
     region: 'ap-southeast-1',
     userPoolId: '<USER-POOL-ID>',
     userPoolClientId: '<CLIENT-ID>',
     cognitoDomain: 'https://<COGNITO-DOMAIN>',
     apiBaseUrl: 'https://<API-ID>.execute-api.ap-southeast-1.amazonaws.com',
     assistantEnabled: false,
   };

   export default config;
   ```

   | Setting | Rule |
   |---|---|
   | **region** | ap-southeast-1 |
   | **userPoolId** | Your user pool ID |
   | **userPoolClientId** | Your app client ID |
   | **cognitoDomain** | Starts with **https://**, **no trailing slash** |
   | **apiBaseUrl** | Your full Invoke URL (**API-URL**), **no trailing slash** |
   | **assistantEnabled** | **false** for now |

   > ⚠️ **Note:** A trailing slash on **cognitoDomain** or **apiBaseUrl** produces URLs with a double slash and the sign-in or API calls fail.

1. Save the file (**Ctrl+S**).

1. Open **C:\psb-lab-assets\dashboard\src\App.jsx** and review how sign-in works:

   > ℹ️ **Info:** The **useAuth** hook in App.jsx:
   > - Reads the **id_token** from the URL hash after Cognito redirects back to the app.
   > - Stores it in **sessionStorage** under the key **psb_id_token**.
   > - Redirects the user to the Cognito **Hosted UI** when the token is missing or expired.
   > - Sends the token as **Authorization: Bearer** on every API call (see **src/api.js**).
   >
   > Charts are drawn with inline SVG, so no chart library is needed.

1. Open **Windows PowerShell** and build the app:

   ```powershell
   cd C:\psb-lab-assets\dashboard
   npm install
   npm run build
   Compress-Archive -Path dist\* -DestinationPath dashboard-build.zip -Force
   ```

   > 💡 **Tip:** Zip the **contents** of the **dist** folder (dist\*), not the folder itself. Amplify needs **index.html** at the root of the zip.

1. Confirm that **C:\psb-lab-assets\dashboard\dashboard-build.zip** exists.

   > ⚠️ **Fallback if the build fails:** Use the prebuilt **C:\psb-lab-assets\dashboard\dist.zip** instead.
   > 1. Extract **dist.zip** to a folder.
   > 1. Open **config.json** at the root of the extracted folder and enter the same values as above (it overrides src/config.js at runtime).
   > 1. Zip the folder **contents** again (index.html and config.json at the zip root) and use that zip in Task 2.

✅ **Expected result:** You have **dashboard-build.zip** (or a re-zipped **dist.zip**) containing **index.html** at its root, configured with your Cognito and API values.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Deploy the Dashboard to Amplify and Connect It to Cognito

🎯 **Goal:** Host the build on Amplify, add an SPA rewrite rule, and allow the Amplify URL in Cognito so sign-in returns to your dashboard.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🚀</span>Deploy without Git

1. In the AWS console search bar, type **Amplify** and open **AWS Amplify**.

1. Select **Create new app**.

1. Under **Start building with Amplify**, choose **Deploy without Git**, then select **Next**.

1. Enter the following settings:

   | Setting | Value |
   |---|---|
   | **App name** | psb-lab-dashboard |
   | **Branch name** | main |
   | **Method** | Drag and drop |

1. Drag **dashboard-build.zip** into the drop area (or select **Choose .zip folder** and browse to it).

1. Select **Save and deploy**. Wait until the deployment status shows **Deployed** (about 1 minute).

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔁</span>Add the SPA rewrite rule

1. In the app's left menu, select **Hosting** > **Rewrites and redirects**.

1. Select **Manage redirects** (or **Add rewrite**) and add this rule:

   | Setting | Value |
   |---|---|
   | **Source address** | `/<*>` |
   | **Target address** | /index.html |
   | **Type** | 404 (Rewrite) |

1. Select **Save**.

   > ℹ️ **Info:** This rule (stored as **404-200**) serves **index.html** for any path, so the single-page app loads correctly after the Cognito redirect.

1. Go to the app **Overview** and copy the **Domain** of the **main** branch. It looks like **https://main.&lt;appid&gt;.amplifyapp.com**.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔐</span>Allow the Amplify URL in Cognito

1. Open **Amazon Cognito** > **User pools** > **psb-lab-users**.

1. In the left menu, select **Applications** > **App clients** > **psb-lab-dashboard**.

1. Open the **Login pages** tab and, under **Managed login pages configuration**, select **Edit**.

1. Add your Amplify domain **with a trailing slash**:

   | Setting | Values (keep the existing localhost entry) |
   |---|---|
   | **Allowed callback URLs** | http://localhost:5173/ and https://main.&lt;appid&gt;.amplifyapp.com/ |
   | **Allowed sign-out URLs** | https://main.&lt;appid&gt;.amplifyapp.com/ |

   > ⚠️ **Note:** Leave **Implicit grant**, **Authorization code grant** and the scopes **email**, **openid**, **profile** as configured in Lab 04.

1. Select **Save changes**.

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🌐</span>Open the dashboard

1. Open your Amplify URL in a new browser tab. You are redirected to the Cognito sign-in page.

1. Sign in with:

   | Detail | Value |
   |---|---|
   | **Email** | student@psb.lab |
   | **Password** | PsbLab#2026!New |

1. Explore the dashboard:

   | Element | What you see |
   |---|---|
   | **Chart** | Time series per location (north-lab, south-lab, server-room) |
   | **Summary strip** | latest, min, max, mean |
   | **Metric selector** | Temperature, Humidity, CO₂, Vibration |
   | **Window selector** | 15m / 1h / 6h / 24h |

   | Problem | Likely cause and fix |
   |---|---|
   | **redirect_mismatch** on sign-in | The Amplify URL with trailing slash is missing from **Allowed callback URLs**. |
   | Blank page after sign-in | The rewrite rule `/<*>` to **/index.html** (404-200) is missing. |
   | **401** errors / empty charts | Wrong **userPoolClientId** or the authorizer audience does not match the client ID. |
   | CORS or network error | **apiBaseUrl** has a trailing slash or the wrong Invoke URL. |

   ✅ **Expected result:** The dashboard loads from Amplify, signs you in as **student@psb.lab**, and shows live charts with the summary strip.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="82bd0de8-3c01-41d1-9851-9caa8732cf60" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you:

- Configured the React dashboard with your Cognito user pool, app client, domain and API URL.
- Built the app with **npm** and packaged it as a zip.
- Hosted it on **AWS Amplify** (Deploy without Git, branch **main**) with an SPA rewrite rule.
- Added the Amplify URL to the Cognito callback and sign-out URLs and signed in to live charts.

Click **Next** to continue.

</div>

</div>
