<h1 align="center">📊 Lab 05: Host the Dashboard on AWS Amplify</h1>
<p align="center"><b>AWS Demo || Bedrock with Claude</b> | ⏱️ <b>Estimated Timing: 45 Minutes</b> | 🏆 <b>Points: 9</b></p>

---

## 🎯 Overview

Your telemetry API is now protected by Amazon Cognito. In this lab, you give operators a friendly way to see the data: a small **React** dashboard that signs users in through the Cognito Hosted UI, calls your API with the user's token, and draws live charts. You build it on the lab VM and host it on **AWS Amplify Hosting** using **Deploy without Git**.

## 📋 Objectives

In this lab, you will complete the following tasks:

1. 🛠️ **Task 1:** Configure and build the dashboard.
1. 🚀 **Task 2:** Deploy the dashboard to Amplify and connect it to Cognito.

## 🏗️ What you build

```text
Browser ──► Amplify (https://main.<appid>.amplifyapp.com/)
   │            │
   │            └─► Cognito Hosted UI (sign in, id_token)
   │
   └─► API Gateway psb-lab-api (Authorization: Bearer <id_token>) ──► psb-query-telemetry ──► InfluxDB
```

> ⚠️ **Note:** Keep the simulator from Lab 01 running so the charts have fresh data. Work in the **Asia Pacific (Singapore) ap-southeast-1** region throughout.

---

## 🧩 Task 1: Configure and build the dashboard

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

---

## 🧩 Task 2: Deploy the dashboard to Amplify and connect it to Cognito

🎯 **Goal:** Host the build on Amplify, add an SPA rewrite rule, and allow the Amplify URL in Cognito so sign-in returns to your dashboard.

### 🚀 Deploy without Git

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

### 🔁 Add the SPA rewrite rule

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

### 🔐 Allow the Amplify URL in Cognito

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

### 🌐 Open the dashboard

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

   <validation step="385a58e4-0c21-49a6-8b28-97567e7c1d96" />

## 📝 Summary

In this lab, you:

- Configured the React dashboard with your Cognito user pool, app client, domain and API URL.
- Built the app with **npm** and packaged it as a zip.
- Hosted it on **AWS Amplify** (Deploy without Git, branch **main**) with an SPA rewrite rule.
- Added the Amplify URL to the Cognito callback and sign-out URLs and signed in to live charts.

Click **Next** to continue.
