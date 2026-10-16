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
<div class="psb-title" style="color:#ffffff;font-size:1.6em;font-weight:700;line-height:1.3;text-align:center;">Lab 04: Secure the API with Amazon Cognito</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 12px;border-radius:3px;background:linear-gradient(90deg,#e9b949,#14b8a6);"></div>
<div class="psb-meta" style="color:#d5dbe3;margin-top:6px;text-align:center;">40 Minutes&nbsp;&nbsp;|&nbsp;&nbsp;10 Points</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🎯</span>Overview

Your API currently answers anyone who knows the URL. In this lab you will fix that.

You will create an Amazon Cognito user pool to hold your application's users, add an app client and a hosted sign-in UI, and attach a JWT authorizer to your API Gateway routes so that every request must carry a valid, unexpired, correctly-audienced token. You will then prove the boundary works by calling the API with and without a token.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>Lab Objectives

You will be able to complete the following tasks:

- Task 1: Create the Cognito user pool, app client and hosted UI
- Task 2: Attach a JWT authorizer to the API and verify enforcement

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 1: Create the Cognito User Pool, App Client and Hosted UI

1. In the AWS Management Console search bar, type **Cognito** and select **Amazon Cognito**.

1. Click **Create user pool**.

1. On the **Define your application** page:

   | Field | Value |
   |---|---|
   | Application type | **Single-page application (SPA)** |
   | Name your application | **psb-lab-dashboard** |
   | Options for sign-in identifiers | Select **Email** only |
   | Required attributes for sign-up | Select **email** |

1. Under **Add a return URL**, enter the following placeholder. You will replace it in Lab 05 once you know your Amplify domain:

   ```text
   http://localhost:5173/
   ```

1. Click **Create user directory**.

1. Once the pool is created, you land on the application overview. Copy the following three values into your notepad; you will need all of them:

   | Value | Where it appears |
   |---|---|
   | User pool ID | Format ap-southeast-1_XXXXXXXXX |
   | Client ID | A 26-character alphanumeric string |
   | Cognito domain | Format https://&lt;prefix&gt;.auth.ap-southeast-1.amazoncognito.com |

   > **Note:** If a Cognito domain was not created automatically, go to **Branding** → **Domain** in the left-hand navigation, click **Actions** → **Create Cognito domain**, enter a globally unique prefix such as **psb-lab-<inject key="DeploymentID" enableCopy="false"/>**, and click **Create**.

1. Now rename the pool for clarity. In the left-hand navigation pane, click **Overview**, then **Edit** next to the pool name, set it to **psb-lab-users**, and save.

1. Enable the OAuth flow this lab uses. In the left-hand navigation pane, under **Applications**, click **App clients**, then click **psb-lab-dashboard**.

1. Scroll to **Login pages** and click **Edit**.

1. Set the following, then click **Save changes**:

   | Field | Value |
   |---|---|
   | Allowed callback URLs | **http://localhost:5173/** |
   | Allowed sign-out URLs | **http://localhost:5173/** |
   | Identity providers | **Cognito user pool** |
   | OAuth 2.0 grant types | Select **Implicit grant** (leave **Authorization code grant** selected as well) |
   | OpenID Connect scopes | **email**, **openid**, **profile** |

   > **Important:** The SPA quick-setup flow enables **Authorization code grant** only. The next few steps sign you in with `response_type=token`, which is the implicit grant, so it must be enabled here or the hosted UI will reject the request with `unauthorized_client`. You will add your Amplify domain to these same lists in Lab 05.

1. Create a test user. In the left-hand navigation pane, under **User management**, click **Users**, then click **Create user**.

1. On the **Create user** page, provide the following:

   | Field | Value |
   |---|---|
   | Invitation message | **Don't send an invitation** |
   | Email address | **student@psb.lab** |
   | Mark email address as verified | **Checked** |
   | Password | **Set a password** |
   | Password value | **PsbLab#2026!** |

1. Click **Create user**.

1. Confirm the user appears in the list with status **Force change password**.

1. Sign in once through the hosted UI to clear the forced password change. Open a new browser tab and navigate to the following URL, replacing `<COGNITO-DOMAIN>` and `<CLIENT-ID>`:

   ```text
   <COGNITO-DOMAIN>/login?client_id=<CLIENT-ID>&response_type=token&scope=email+openid&redirect_uri=http://localhost:5173/
   ```

1. Sign in as **student@psb.lab** with **PsbLab#2026!**. You will be prompted to set a new password; set it to:

   ```text
   PsbLab#2026!New
   ```

1. After sign-in, the browser will redirect to **http://localhost:5173/** and show a connection error. That is expected: nothing is listening on that port yet. What matters is the URL bar, which now contains a fragment like:

   ```text
   http://localhost:5173/#id_token=eyJraWQiOiJ...&access_token=eyJra...&expires_in=3600&token_type=Bearer
   ```

1. Copy the value of **id_token**: everything between `id_token=` and the following `&`. Paste it into your notepad. It is a long JWT beginning `eyJ`.

   > **Note:** This is an OAuth 2.0 implicit-flow response. The token is delivered in the URL fragment (after `#`) rather than the query string, so it is never sent to a server in a request line or written to a server access log. Modern SPAs use Authorization Code with PKCE instead, which Amplify's auth library does for you in Lab 05; implicit flow is used here only because it hands you a token you can paste into curl.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧩</span>Task 2: Attach a JWT Authorizer to the API and Verify Enforcement

1. Return to the API Gateway console and open **psb-lab-api**.

1. In the left-hand navigation pane, under **Develop**, click **Authorization**.

1. Select the **Manage authorizers** tab and click **Create**.

1. Configure the authorizer:

   | Field | Value |
   |---|---|
   | Authorizer type | **JWT** |
   | Name | **psb-lab-cognito-authorizer** |
   | Identity source | **$request.header.Authorization** |
   | Issuer URL | **https://cognito-idp.ap-southeast-1.amazonaws.com/&lt;USER-POOL-ID&gt;** |
   | Audience | **&lt;CLIENT-ID&gt;** |

   > **Note:** The Issuer URL is not your Cognito hosted-UI domain; it is the identity-provider endpoint, built from the region and the user pool ID. Getting these two confused is the most common cause of a 401 at this step. The Audience must be the app client ID, because that is the `aud` claim Cognito puts in the ID token.

1. Click **Create**.

1. Select the **Attach authorizers to routes** tab.

1. Click **GET /telemetry**, select **psb-lab-cognito-authorizer** from the dropdown, and click **Attach authorizer**.

1. Repeat for **GET /anomalies**.

1. Confirm both routes now show **psb-lab-cognito-authorizer** in the **Attached authorizer** column.

1. Now verify enforcement. In PowerShell, call the API without a token:

   ```powershell
   curl.exe -i "<INVOKE-URL>/telemetry?metric=temperature_c"
   ```

   You should receive:

   ```text
   HTTP/2 401
   {"message":"Unauthorized"}
   ```

1. Now call it with the token you copied in Task 1 step 18:

   ```powershell
   curl.exe -i -H "Authorization: Bearer <ID-TOKEN>" "<INVOKE-URL>/telemetry?metric=temperature_c&window_minutes=30"
   ```

   You should receive **HTTP/2 200** and your telemetry JSON.

   > **Troubleshooting:** A 401 with a valid-looking token usually means one of three things: the token has expired (they last one hour; repeat Task 1 steps 15 to 18 to get a fresh one); you pasted the `access_token` instead of the `id_token` (the audience claim differs); or the Issuer URL in the authorizer has a trailing slash, which it must not have.

1. Finally, understand what the authorizer is not doing. Paste your token into a JWT decoder to inspect its claims; you can do this offline in PowerShell:

   ```powershell
   $t = "<ID-TOKEN>".Split(".")[1]
   $t = $t.PadRight($t.Length + (4 - $t.Length % 4) % 4, "=")
   [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($t))
   ```

   You will see claims including `sub`, `aud`, `iss`, `exp` and `email`. API Gateway verifies the signature, the issuer, the audience and the expiry; it does not decide what this particular user is allowed to see. That is authorization, and it belongs in your Lambda function. In a multi-tenant version of this solution, **psb-query-telemetry** would read the `sub` or a custom `custom:site_id` claim from `event.requestContext.authorizer.jwt.claims` and add it to the Flux filter.

   > **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   >
   > - Select the **Validate** button for the corresponding task. If you receive a success message, you can proceed to the next task.
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

   <validation step="82ec5de0-5dd0-40ef-962b-db3d389c3679" />

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📝</span>Summary

In this lab, you have completed the following:

- Created an Amazon Cognito user pool, app client and hosted sign-in UI.
- Created a test user and obtained a JWT through the hosted UI.
- Attached a JWT authorizer to both API Gateway routes.
- Verified that unauthenticated requests are rejected and authenticated requests succeed, and inspected the token's claims.

You have successfully completed the lab. Click **Next** to continue to the next lab.

</div>

</div>
