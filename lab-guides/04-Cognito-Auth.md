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
@media (prefers-reduced-motion:reduce){.psbgs *,.psbgs *::before,.psbgs *::after{animation:none!important;transition:none!important}}
</style>

<div class="psbgs">

<div class="psb-hero" style="position:relative;overflow:hidden;border-radius:16px;padding:28px 20px 24px;margin:0 0 6px;text-align:center;color:#ffffff;background:linear-gradient(120deg,#070b1a,#121a3a,#0d2b36,#16123a);">
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 04: Amazon Cognito Authentication</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">40 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;10 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

Your API is currently open to anyone with the URL. In this lab, you add user sign-in with **Amazon Cognito** and protect the API with a **JWT authorizer** in API Gateway. Only requests carrying a valid Cognito ID token are allowed through.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Objectives

- **Task 1:** Create the Cognito user pool, app client, domain and a test user, then sign in to get an ID token.
- **Task 2:** Add a JWT authorizer to **psb-lab-api** and test it with and without a token.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🏗️</span>What you build

```text
User ──sign in──> Cognito managed login (psb-lab-users) ──id_token──> Client
Client ──Authorization: Bearer <id_token>──> API Gateway (psb-lab-cognito-authorizer) ──> psb-query-telemetry
```

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Create the User Pool and Get an ID Token

🎯 **Goal:** Set up Cognito for the single-page dashboard and sign in as a test user.

1. Open **Amazon Cognito** and click **Get started for free in less than five minutes** (or **User pools** > **Create user pool**). The **Set up resources for your application** page opens.

1. Enter the following settings:

   | Setting | Value |
   |---|---|
   | Application type | **Single-page application (SPA)** |
   | Name your application | **psb-lab-dashboard** |
   | Options for sign-in identifiers | **Email** |
   | Return URL | **http://localhost:5173/** |

   Leave the other options as default and click **Create user directory**.

1. On the next page, click **Go to overview**. Record these values in Notepad (from the **User pool overview** and **Applications** > **App clients** > **psb-lab-dashboard**):

   | Value | Notepad name | Example |
   |---|---|---|
   | User pool ID | **USER-POOL-ID** | **ap-southeast-1_AbCdEfGhI** |
   | Client ID | **CLIENT-ID** | **1a2b3c4d5e6f7g8h9i0j** |
   | Cognito domain | **COGNITO-DOMAIN** | set in step 5 |

1. On the **User pool overview** page, click **Rename**, enter **psb-lab-users** and click **Save changes**.

   > ℹ️ **Info:** The wizard gives the pool an automatic name. Renaming it makes it easy to find and is checked by the validation.

1. In the left menu select **Branding** > **Domain**. Set a Cognito domain with the prefix **psb-lab-<inject key="DeploymentID" enableCopy="false"/>**:

   - If a Cognito domain with a random prefix already exists, select **Actions** > **Delete Cognito domain** and confirm.
   - Select **Actions** > **Create Cognito domain**, enter the prefix **psb-lab-<inject key="DeploymentID" enableCopy="false"/>**, keep **Branding version** as **Managed login**, and click **Create Cognito domain**.

   Save the domain in Notepad as **COGNITO-DOMAIN** (without **https://**):

   ```text
   psb-lab-<inject key="DeploymentID" enableCopy="false"/>.auth.ap-southeast-1.amazoncognito.com
   ```

1. Select **Applications** > **App clients** > **psb-lab-dashboard**, open the **Login pages** tab, and under **Managed login pages configuration** click **Edit**:

   | Setting | Value |
   |---|---|
   | Allowed callback URLs | **http://localhost:5173/** |
   | OAuth 2.0 grant types | **Implicit grant** and **Authorization code grant** |
   | OpenID Connect scopes | **Email**, **OpenID**, **Profile** |

   Click **Save changes**.

1. Select **User management** > **Users** > **Create user**:

   | Setting | Value |
   |---|---|
   | Invitation message | **Don't send an invitation** |
   | Email address | **student@psb.lab** |
   | Mark email address as verified | **Selected** |
   | Temporary password | **Set a password**: **PsbLab#2026!** |

   Click **Create user**.

1. Build the managed login (Hosted UI) URL. In Notepad, replace **&lt;COGNITO-DOMAIN&gt;** and **&lt;CLIENT-ID&gt;**:

   ```text
   https://<COGNITO-DOMAIN>/login?client_id=<CLIENT-ID>&response_type=token&scope=email+openid+profile&redirect_uri=http://localhost:5173/
   ```

1. Open the URL in the browser. Sign in with **student@psb.lab** and **PsbLab#2026!**. When asked, set the new password:

   | Setting | Value |
   |---|---|
   | New password | **PsbLab#2026!New** |

1. The browser redirects to **http://localhost:5173/** and the page **does not load**. This is expected, because nothing runs on localhost yet. Copy the full address bar, find the value between **id_token=** and the next **&**, and copy it.

1. In **PowerShell**, store the token in an environment variable (paste your token):

   ```powershell
   $env:ID_TOKEN = "<PASTE-ID-TOKEN-HERE>"
   ```

   > ⚠️ **Note:** The ID token expires after **1 hour**. If later calls return **401**, repeat steps 9 to 11 (you sign in with **PsbLab#2026!New** from now on).

✅ **Expected result:** The user pool **psb-lab-users** exists with app client **psb-lab-dashboard** and domain **psb-lab-<inject key="DeploymentID" enableCopy="false"/>**, the user **student@psb.lab** is **Confirmed**, and you have an ID token in **$env:ID_TOKEN**.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Protect the API with a JWT Authorizer

🎯 **Goal:** Allow only signed-in users to call **GET /telemetry** and **GET /anomalies**.

1. Open **API Gateway** > **psb-lab-api**. In the left menu, under **Develop**, select **Authorization**.

1. Open the **Manage authorizers** tab and click **Create**:

   | Setting | Value |
   |---|---|
   | Authorizer type | **JWT** |
   | Name | **psb-lab-cognito-authorizer** |
   | Identity source | **$request.header.Authorization** |
   | Issuer URL | **https://cognito-idp.ap-southeast-1.amazonaws.com/&lt;USER-POOL-ID&gt;** |
   | Audience | **&lt;CLIENT-ID&gt;** (click **Add audience**) |

   Click **Create**.

1. Open the **Attach authorizers to routes** tab. Select **GET** under **/telemetry**, choose **psb-lab-cognito-authorizer** and click **Attach authorizer**. Repeat for **GET** under **/anomalies**.

   > ℹ️ **Info:** The **$default** stage auto-deploys, so the change is live within a few seconds.

1. In **PowerShell**, call the API **without** a token:

   ```powershell
   curl.exe -i "<API-URL>/telemetry?metric=temperature_c&window_minutes=30"
   ```

   Confirm the response is **401** with **{"message":"Unauthorized"}**.

1. Call the API **with** the token:

   ```powershell
   curl.exe -i -H "Authorization: Bearer $env:ID_TOKEN" "<API-URL>/telemetry?metric=temperature_c&window_minutes=30"
   ```

   Confirm the response is **200** with telemetry data.

1. Decode the token claims to see what the authorizer checks. Paste the token on **https://jwt.io**, or run this in PowerShell:

   ```powershell
   $p = $env:ID_TOKEN.Split('.')[1].Replace('-','+').Replace('_','/')
   switch ($p.Length % 4) { 2 { $p += '==' } 3 { $p += '=' } }
   [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($p)) | ConvertFrom-Json | Select-Object email, aud, iss, exp
   ```

   | Claim | Meaning |
   |---|---|
   | **email** | The signed-in user (**student@psb.lab**) |
   | **aud** | Audience, must equal your **Client ID** |
   | **iss** | Issuer, must equal your user pool URL |
   | **exp** | Expiry time (epoch seconds) |

   ✅ **Expected result:** Without a token the API returns **401 Unauthorized**; with a valid token it returns **200**. Both routes use **psb-lab-cognito-authorizer**.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="82ec5de0-5dd0-40ef-962b-db3d389c3679" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you:

- Created the Cognito user pool **psb-lab-users** with the SPA app client **psb-lab-dashboard** and the domain **psb-lab-<inject key="DeploymentID" enableCopy="false"/>**.
- Enabled implicit and authorization code grants with **email**, **openid** and **profile** scopes.
- Created and signed in as **student@psb.lab** to obtain an ID token.
- Protected **GET /telemetry** and **GET /anomalies** with the JWT authorizer **psb-lab-cognito-authorizer**.

Click **Next** to continue.

</div>

</div>
