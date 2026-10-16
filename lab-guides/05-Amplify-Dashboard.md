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
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 05: Deploy the React Dashboard on AWS Amplify Hosting</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">45 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;9 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

You now have a secured API over live sensor data. In this lab you will give it a face.

You will configure a provided React single-page application with your own Cognito and API values, build it on the Lab VM, and publish it to AWS Amplify Hosting using a manual deployment. Amplify will serve it over HTTPS from a CDN with an atomic, versioned deploy: no server, no certificate management, no build pipeline to maintain.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Lab Objectives

You will be able to complete the following tasks:

- Task 1: Configure and build the React dashboard
- Task 2: Publish to AWS Amplify Hosting and sign in

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Configure and Build the React Dashboard

1. On the Lab VM, open **VS Code** and use **File** → **Open Folder** to open:

   ```text
   C:\psb-lab-assets\dashboard
   ```

1. In the **Explorer** pane, open the file **src/config.js**. It contains placeholders you must replace with your own values:

   ```javascript
   // PSB Academy CloudLab - dashboard configuration.
   // Replace every <PLACEHOLDER> with the value from your own lab environment.

   export const config = {
     region: "ap-southeast-1",

     // From Lab 04, Task 1
     userPoolId:        "<USER-POOL-ID>",
     userPoolClientId:  "<CLIENT-ID>",
     cognitoDomain:     "<COGNITO-DOMAIN>",

     // From Lab 03, Task 2
     apiBaseUrl:        "<INVOKE-URL>",

     // Leave as-is
     redirectUri:       window.location.origin + "/",
     defaultMetric:     "temperature_c",
     defaultWindowMins: 60,
     refreshSeconds:    30,
   };
   ```

1. Replace the four placeholders with the values from your notepad, then save the file with **Ctrl + S**.

   > **Note:** **cognitoDomain** must include the `https://` scheme and must not have a trailing slash. **apiBaseUrl** must not have a trailing slash either.

1. Take a moment to look at **src/App.jsx**. The parts worth understanding:

   ```javascript
   // 1. Auth: exchange the Cognito redirect for a token, or send the user to sign in.
   function useAuth() {
     const [idToken, setIdToken] = useState(
       () => sessionStorage.getItem("psb_id_token") || "");

     useEffect(() => {
       const hash = new URLSearchParams(window.location.hash.slice(1));
       const token = hash.get("id_token");
       if (token) {
         sessionStorage.setItem("psb_id_token", token);
         setIdToken(token);
         window.history.replaceState({}, "", window.location.pathname);
       }
     }, []);

     const signIn = () => {
       const u = new URL(config.cognitoDomain + "/login");
       u.searchParams.set("client_id", config.userPoolClientId);
       u.searchParams.set("response_type", "token");
       u.searchParams.set("scope", "email openid");
       u.searchParams.set("redirect_uri", config.redirectUri);
       window.location.href = u.toString();
     };

     return { idToken, signIn };
   }

   // 2. Data: every API call carries the bearer token.
   async function fetchSeries(idToken, path, params) {
     const url = new URL(config.apiBaseUrl + path);
     Object.entries(params).forEach(([k, v]) =>
       v != null && url.searchParams.set(k, v));
     const res = await fetch(url, {
       headers: { Authorization: `Bearer ${idToken}` },
     });
     if (res.status === 401) throw new Error("Session expired - sign in again.");
     if (!res.ok) throw new Error(`API returned ${res.status}`);
     return res.json();
   }

   // 3. Render: a metric selector, a summary strip, a chart, and (from Lab 08)
   //    the assistant chat panel.
   ```

   > **Note:** The token is held in `sessionStorage`, not `localStorage`. `sessionStorage` is cleared when the tab closes, which limits the window in which a stolen token is useful. Neither is ideal: a production SPA would use the Authorization Code flow with PKCE and keep the refresh token in an HttpOnly cookie.

1. Open a PowerShell terminal inside VS Code with **Terminal** → **New Terminal** and install the dependencies:

   ```powershell
   cd C:\psb-lab-assets\dashboard
   npm install
   ```

   This takes about a minute.

1. Build the production bundle:

   ```powershell
   npm run build
   ```

1. Confirm the build succeeded. You should see output ending with something like:

   ```text
   vite v5.4.8 building for production...
   ✓ 214 modules transformed.
   dist/index.html                   0.48 kB
   dist/assets/index-a1b2c3d4.css    3.17 kB
   dist/assets/index-e5f6g7h8.js   183.42 kB
   ✓ built in 4.21s
   ```

1. Package the build output as a ZIP that Amplify can accept:

   ```powershell
   Compress-Archive -Path .\dist\* -DestinationPath .\dashboard-build.zip -Force
   ```

1. Confirm **dashboard-build.zip** now exists in **C:\psb-lab-assets\dashboard**.

   > **Troubleshooting:** If `npm run build` fails, a pre-built fallback is provided at **C:\psb-lab-assets\dashboard\dist.zip**. It reads its configuration from a **config.json** file at the site root, which you can edit after deploying. Use it only if the build will not complete; building it yourself is part of the exercise.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Publish to AWS Amplify Hosting and Sign In

1. In the AWS Management Console search bar, type **Amplify** and select **AWS Amplify**.

1. Click **Create new app**.

1. On the **Start building with Amplify** page, select **Deploy without Git** and click **Next**.

   > **Note:** Amplify's usual flow connects to GitHub, GitLab or Bitbucket and rebuilds on every push. That is the right choice for a real project. Here you are using manual deploy because it removes an OAuth authorisation against a personal Git account from the lab, and because it is the fastest path to a running site. The "what you would do next" section at the end of this lab covers the Git flow.

1. On the **Manual deployment** page:

   | Field | Value |
   |---|---|
   | App name | **psb-lab-dashboard** |
   | Branch name | **main** |
   | Method | **Drag and drop** |

1. Click **Choose files** and select **C:\psb-lab-assets\dashboard\dashboard-build.zip**.

1. Click **Save and deploy**.

1. The deployment takes about 30 seconds. Wait for the status to show **Deployed**.

1. Copy the **Domain** URL shown on the app page. It looks like:

   ```text
   https://main.d1a2b3c4e5f6g7.amplifyapp.com
   ```

   Paste it into your notepad.

1. Configure SPA routing. Amplify serves static files, so a deep link such as `/dashboard` would return a 404 unless you tell it to fall back to `index.html`. In the left-hand navigation pane, under **Hosting**, click **Rewrites and redirects**, then click **Manage redirects** and **Add rewrite**:

   | Field | Value |
   |---|---|
   | Source address | **/&lt;\*&gt;** |
   | Target address | **/index.html** |
   | Type | **404 (Rewrite)** |

   Click **Save**.

1. Now add your Amplify domain to Cognito's allowed callback URLs. Return to the Amazon Cognito console and open **psb-lab-users**.

1. In the left-hand navigation pane, under **Applications**, click **App clients**, then click **psb-lab-dashboard**.

1. Scroll to **Login pages** and click **Edit**.

1. Under **Allowed callback URLs**, click **Add another URL** and enter your Amplify domain with a trailing slash (keep the **http://localhost:5173/** entry from Lab 04):

   ```text
   https://main.d1a2b3c4e5f6g7.amplifyapp.com/
   ```

1. Under **Allowed sign-out URLs**, add the same URL.

1. Confirm that **Implicit grant** is still selected under **OAuth 2.0 grant types**, and that **email**, **openid** and **profile** are still selected under **OpenID Connect scopes**; you enabled these in Lab 04.

1. Click **Save changes**.

1. Open your Amplify domain in a new browser tab.

1. Click **Sign in**. You will be redirected to the Cognito hosted UI.

1. Sign in as **student@psb.lab** with the password you set in Lab 04 (**PsbLab#2026!New**).

1. You will be redirected back to the dashboard, which should now show:

   - a summary strip with the latest, minimum, maximum and mean values;
   - a line chart of temperature over the last 60 minutes, one line per location;
   - a metric selector letting you switch between temperature, humidity, CO₂ and vibration;
   - a window selector for 15 minutes, 1 hour, 6 hours or 24 hours.

1. Switch the metric to **co2_ppm** and the window to **6 hours**. You should see the injected anomaly spikes clearly.

   > **Troubleshooting:** A blank chart with a 401 in the browser console means the callback URL in Cognito does not exactly match your Amplify domain, including the trailing slash. A CORS error means the API Gateway CORS configuration from Lab 03 Task 2 was not saved. Open the browser developer tools with **F12** and check the **Console** and **Network** tabs; the error message is almost always specific enough to act on.

   > **What you would do next: Git-based CI/CD.** In a real project you would push this dashboard to a Git repository and connect it to Amplify with **Create new app** → **GitHub**. Amplify would then detect the framework, generate an `amplify.yml` build spec, and rebuild and redeploy automatically on every push to `main`, with preview deployments for pull requests. The trade-off you accepted here is that manual deploys are not reproducible: nobody can tell from the Amplify console which commit produced the running site.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="82bd0de8-3c01-41d1-9851-9caa8732cf60" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you have completed the following:

- Configured a React single-page application with your own Cognito and API endpoints.
- Built a production bundle on the Lab VM.
- Published it to AWS Amplify Hosting with a manual deployment and configured SPA rewrite rules.
- Registered the Amplify domain as a Cognito callback URL and signed in end to end.

Phase I is complete. You have a working IoT pipeline: a device with a cryptographic identity, secure ingestion, a time-series store, an object store, a serverless API, managed authentication, and a hosted dashboard.

You have successfully completed the lab. Click **Next** to continue to the next lab.

</div>

</div>
