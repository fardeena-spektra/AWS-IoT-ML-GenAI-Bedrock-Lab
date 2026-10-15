<h1 align="center">🔐 Lab 04: Cognito Authentication</h1>
<p align="center"><b>AWS Demo || Bedrock with Claude</b> | ⏱️ <b>Estimated Timing: 40 Minutes</b> | 🏆 <b>Points: 10</b></p>

---

## 🎯 Overview

Your API is currently open to anyone with the URL. In this lab, you add user sign-in with **Amazon Cognito** and protect the API with a **JWT authorizer** in API Gateway. Only requests carrying a valid Cognito ID token are allowed through.

## 📋 Objectives

- **Task 1:** Create the Cognito user pool, app client, domain and a test user, then sign in to get an ID token.
- **Task 2:** Add a JWT authorizer to **psb-lab-api** and test it with and without a token.

## 🏗️ What you build

```text
User ──sign in──> Cognito managed login (psb-lab-users) ──id_token──> Client
Client ──Authorization: Bearer <id_token>──> API Gateway (psb-lab-cognito-authorizer) ──> psb-query-telemetry
```

---

## 🧩 Task 1: Create the User Pool and Get an ID Token

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

---

## 🧩 Task 2: Protect the API with a JWT Authorizer

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

   <validation step="e7c33a7a-0ce1-4bf3-8625-fe61aca5a505" />

## 📝 Summary

In this lab, you:

- Created the Cognito user pool **psb-lab-users** with the SPA app client **psb-lab-dashboard** and the domain **psb-lab-<inject key="DeploymentID" enableCopy="false"/>**.
- Enabled implicit and authorization code grants with **email**, **openid** and **profile** scopes.
- Created and signed in as **student@psb.lab** to obtain an ID token.
- Protected **GET /telemetry** and **GET /anomalies** with the JWT authorizer **psb-lab-cognito-authorizer**.

Click **Next** to continue.
