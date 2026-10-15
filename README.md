# 🛰️ AWS Demo || Bedrock with Claude

CloudLabs guided lab package: **IoT sensors → time-series → ML anomaly detection → generative AI assistant** on AWS, in **ap-southeast-1 (Singapore)**. 9 labs, about 8 h 10 min.

| Phase | Labs | Services |
|---|---|---|
| I. Connect, ingest, serve | 01 to 05 | IoT Core, Timestream for InfluxDB, S3, Lambda, Secrets Manager, API Gateway (HTTP API), Cognito, Amplify |
| II. Machine learning | 06 to 07 | SageMaker Studio, Random Cut Forest, serverless endpoint, EventBridge |
| III. GenAI + operations | 08 to 09 | Bedrock Converse API with tool use (Amazon Nova Lite), CloudWatch |

## 📁 Package layout

| Path | What it is |
|---|---|
| `deployment/cloudlabs-cft.json` | CloudLabs CloudFormation template (VM + pre-seeding) |
| `deployment/cloudlabs-cft-parameters.json` | CloudLabs parameters file |
| `deployment/learner-iam-policy.json` | Suggested policy for the learner IAM user (scoped to ap-southeast-1) |
| `lab-guides/masterdoc.json` | Master document (10 pages) |
| `lab-guides/*.md` | Getting Started + Labs 01 to 09 |
| `validation/LAB01..LAB09-*.ps1` | One validator per lab (CloudLabs Function App, PowerShell) + `validation/README.md` |
| `solution-guide/Solution-Guide.md` | Fast completion path per lab (AWS CLI + console fallbacks) |
| `assets/psb-lab-assets/` | Simulator, 4 Lambda functions, dashboard, notebook, policies, test events |
| `assets/psb-lab-assets.zip` | Same assets zipped; the VM downloads and extracts it to `C:\psb-lab-assets` |

## 🔗 URLs for CloudLabs

- **Master doc:** `https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/lab-guides/masterdoc.json`
- **Assets zip (used by the VM bootstrap):** `https://raw.githubusercontent.com/fardeena-spektra/AWS-IoT-ML-GenAI-Bedrock-Lab/main/assets/psb-lab-assets.zip`

## 🏗️ What the CFT pre-seeds

| Resource | Name | Why |
|---|---|---|
| VPC, 2 subnets (AZs picked automatically), IGW, routes, SGs, key pair, TaskExecutionRole | `clgvpc-<id>`, `clgSg-<id>`, `labkeypair-<id>` | Standard CloudLabs wrapper (web-based RDP) |
| Windows Server 2022 VM, **t3.medium**, 60 GB gp3, SSM instance profile | `windowsvm-<id>` | Learner workstation |
| VM tooling | Chrome, Edge, VS Code, AWS CLI v2 (psscript.ps1) + **Python 3.12, paho-mqtt 1.6.1, Node.js LTS, Git** | Simulator, dashboard build |
| `C:\psb-lab-assets` + desktop shortcut, `aws credentials.txt` on the desktop | | Lab files and sign-in details |
| S3 bucket | `psb-lab-<id>` | Raw/curated/model data |
| SageMaker Studio domain + user profile + execution role | `psb-lab-domain`, `psb-lab-user`, `psb-lab-sagemaker-exec-<id>` | Lab 06 (domain takes about 10 min to create, done during deployment) |

Every resource carries the tag `aws-apn-id = pc:7finjv2fdluw3t9gvedjkgubj`, except IAM roles/profiles, routes, route-table associations and the gateway attachment. UserData restarts the SSM agent at the end. Bootstrap log: `C:\cloudlabs-bootstrap.log`.

**CFT outputs (map in CloudLabs, used as inject keys):** `AWSUserName`, `AWSPassword`, `SignInUrl`, `LabRegion`, `LabBucketName`, `SageMakerDomainName`, `SageMakerDomainId`, `SageMakerUserProfile`, `WindowsVMPublicIP`, `WindowsVMPrivateIP`, `VMPublicDNSName`, `windowsvmAdminUsername`, `WindowsVMPassword`, `clusterSubnetId`, `clusterSecurityGroupId`, `TaskExecutionRole`, `CloudLabsDeploymentID`.

## ✅ Setup checklist

1. Deploy the stack in **ap-southeast-1**.
1. Attach `deployment/learner-iam-policy.json` (or equivalent) to the learner IAM user.
1. Make sure the lab accounts have:
   - **Bedrock:** Amazon Nova Lite through the APAC inference profile `apac.amazon.nova-lite-v1:0`. Nova Lite has no in-Region endpoint in Singapore, so the lab uses the `apac.` profile everywhere.
   - **SageMaker quotas:** `ml.m5.large` for training job usage (1), Studio JupyterLab `ml.t3.medium` (1), serverless endpoint concurrency (at least 5).
   - **InfluxDB:** a **default VPC** in ap-southeast-1 (Lab 02 creates the InfluxDB instance there).
1. Create one validation per lab in CloudLabs using `validation/*.ps1`. Replace the placeholder `<validation step="..."/>` GUIDs in the guides with the CloudLabs step IDs (table in `validation/README.md`).
1. Map the validator parameters: `DeploymentId = GET-DEPLOYMENT-ID`, `AccessKey` / `SecretKey` = the lab account keys, `Region = ap-southeast-1`.

## ℹ️ Notes

- The lab title says Claude. The assistant uses **Amazon Nova Lite** through the Bedrock Converse API, as in the original. A Claude model can be swapped in by changing `MODEL_ID` and the model ARNs in `psb-lab-assistant-policy`.
- The guide content follows the original pages. The code (simulator, Lambdas, dashboard, notebook) was written fresh to match the behaviour the original guide describes, because the original source files could not be retrieved.
- The IoT rule SQL keeps `injected_anomaly` so the notebook can measure precision and recall. The ingest Lambda does not write it to InfluxDB.
- No screenshots are included in the guides yet.
