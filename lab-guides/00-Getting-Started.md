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
@keyframes psbHit{0%{transform:scale(1)}35%{transform:scale(1.22)}70%{transform:scale(.95)}100%{transform:scale(1)}}
.psbgs{position:relative}
/* hero */
.psbgs .psb-hero{background-size:300% 300%!important;animation:psbAurora 14s ease infinite,psbDrop .6s ease-out both;box-shadow:0 12px 32px rgba(15,27,45,.30)}
.psbgs .psb-hero::before{content:"";position:absolute;width:280px;height:280px;left:-70px;top:-100px;border-radius:50%;background:radial-gradient(closest-side,rgba(255,153,0,.38),transparent);animation:psbOrb 9s ease-in-out infinite;pointer-events:none}
.psbgs .psb-hero::after{content:"";position:absolute;inset:0;background:linear-gradient(110deg,transparent 35%,rgba(255,255,255,.12) 50%,transparent 65%);background-size:250% 100%;animation:psbSweep 6s ease-in-out infinite;pointer-events:none}
.psbgs .psb-title{font-size:1.9em!important;color:#ffffff!important}
.psbgs .psb-line{animation:psbLine 4s ease-in-out infinite}
.psbgs .psb-chip{transition:transform .2s ease;cursor:default}
.psbgs .psb-chip *{color:#ffffff!important;-webkit-text-fill-color:#ffffff!important}
.psbgs .psb-chip:hover{transform:translateY(-3px);animation:psbRGB 1.6s linear infinite}
.psbgs .psb-chip:active{animation:psbHit .3s ease,psbBurst .5s ease-out}
/* framed cards with a thick animated border */
.psbgs .psb-panel{position:relative;border:3px solid transparent!important;
  background:linear-gradient(#ffffff,#ffffff) padding-box,conic-gradient(from var(--psbA),#ff9900,#232f3e 25%,#0972d3 50%,#232f3e 75%,#ff9900) border-box!important;
  box-shadow:0 6px 20px rgba(15,27,45,.08);animation:psbRise .6s cubic-bezier(.2,.8,.2,1) both,psbSpin 10s linear infinite;transition:transform .25s ease}
.psbgs .psb-panel:nth-of-type(2){animation-delay:.08s,-1.5s}.psbgs .psb-panel:nth-of-type(3){animation-delay:.16s,-3s}.psbgs .psb-panel:nth-of-type(4){animation-delay:.24s,-4.5s}
.psbgs .psb-panel:nth-of-type(5){animation-delay:.32s,-6s}.psbgs .psb-panel:nth-of-type(6){animation-delay:.4s,-7.5s}.psbgs .psb-panel:nth-of-type(7){animation-delay:.48s,-9s}
.psbgs .psb-panel:hover{transform:translateY(-3px);animation:psbRise .6s both,psbSpin 3s linear infinite,psbRGB 2.4s linear infinite}
/* headings */
.psbgs h2{border:0!important;padding-bottom:12px!important;position:relative;color:#16191f!important;font-weight:700!important}
.psbgs h2::after{content:"";position:absolute;left:0;bottom:0;height:3px;width:100%;border-radius:3px;background:linear-gradient(90deg,#ff9900,#ffc266,#232f3e,#0972d3,#ff9900);background-size:200% 100%;animation:psbBar 4s linear infinite}
.psbgs h3{color:#232f3e!important;font-weight:700!important;margin-top:22px!important}
/* framed icons */
.psbgs .psb-ico{border:2px solid transparent!important;background:linear-gradient(#ffffff,#ffffff) padding-box,conic-gradient(from var(--psbA),#ff9900,#232f3e,#0972d3,#ff9900) border-box!important;
  animation:psbSpin 4s linear infinite;transition:transform .2s ease}
.psbgs .psb-ico:hover{transform:scale(1.15) rotate(-4deg);animation:psbSpin 1.2s linear infinite,psbRGB 1.2s linear infinite}
.psbgs .psb-ico:active{animation:psbHit .3s ease,psbBurst .5s ease-out}
/* tables */
.psbgs table{border-radius:10px;overflow:hidden;box-shadow:0 2px 10px rgba(15,27,45,.06)}
.psbgs th{color:#ffffff!important;background:#232f3e!important;border-color:#232f3e!important}
.psbgs tbody tr{transition:background .2s ease,box-shadow .2s ease}
.psbgs tbody tr:hover{background:#fff7eb!important;box-shadow:inset 4px 0 0 #ff9900}
/* tips */
.psbgs blockquote{background:#f2f8fd!important;border-left:4px solid #0972d3!important;border-radius:0 10px 10px 0;transition:transform .2s ease}
.psbgs blockquote:hover{transform:translateX(3px)}
/* screenshots: thick full animated frame, RGB glow on hover, burst on click */
.psbgs .psb-shot{position:relative;margin:16px 2px 22px;padding:4px;border-radius:14px;border:3px solid transparent;
  background:linear-gradient(#ffffff,#ffffff) padding-box,conic-gradient(from var(--psbA),#ff9900,#232f3e 25%,#0972d3 50%,#232f3e 75%,#ff9900) border-box;
  animation:psbSpin 6s linear infinite;transition:transform .25s ease}
.psbgs .psb-shot p{margin:0!important}
.psbgs .psb-shot img{display:block;max-width:100%;height:auto;margin:0 auto;border:0!important;border-radius:9px;box-shadow:none!important}
.psbgs .psb-shot:hover{transform:translateY(-3px);animation:psbSpin 2s linear infinite,psbRGB 1.8s linear infinite}
.psbgs .psb-shot:active{transform:scale(.99);animation:psbSpin 2s linear infinite,psbBurst .55s ease-out}
/* links */
.psbgs a{color:#0972d3!important;font-weight:600;transition:color .2s ease}
.psbgs a:hover{color:#ec7211!important}
.psbgs a:active{display:inline-block;animation:psbHit .3s ease}
/* CloudLabs inject values and copy buttons */
.psbgs td [class]:not([class^=psb]),.psbgs p [class]:not([class^=psb]),.psbgs li [class]:not([class^=psb]){color:#0972d3!important;-webkit-text-fill-color:#0972d3!important;font-weight:600}
.psbgs td img:not([class^=psb]),.psbgs td svg,.psbgs td i,.psbgs td button,.psbgs [class*=copy],.psbgs [class*=Copy],.psbgs [title*=opy]{cursor:pointer;border-radius:6px;transition:transform .15s ease}
.psbgs td img:not([class^=psb]):hover,.psbgs td svg:hover,.psbgs td i:hover,.psbgs td button:hover,.psbgs [class*=copy]:hover,.psbgs [class*=Copy]:hover,.psbgs [title*=opy]:hover{transform:scale(1.2);animation:psbRGB 1.2s linear infinite}
.psbgs td img:not([class^=psb]):active,.psbgs td svg:active,.psbgs td i:active,.psbgs td button:active,.psbgs [class*=copy]:active,.psbgs [class*=Copy]:active,.psbgs [title*=opy]:active{animation:psbHit .3s ease,psbBurst .5s ease-out}
@media (prefers-reduced-motion:reduce){.psbgs *,.psbgs *::before,.psbgs *::after{animation:none!important;transition:none!important}}
</style>

<div class="psbgs" style="background:linear-gradient(180deg,#f7f9fc 0%,#eef3f9 100%);border:1px solid #e3e9f1;border-radius:20px;padding:14px 10px 22px;margin:0 -20px;">

<div class="psb-hero" style="position:relative;overflow:hidden;border-radius:18px;padding:30px 20px 26px;margin:0 0 6px;text-align:center;color:#ffffff;background:linear-gradient(120deg,#161e2d,#232f3e,#1b3a5c,#232f3e);">
<div class="psb-badge" style="display:inline-block;padding:4px 14px;border-radius:999px;background:rgba(255,153,0,.16);border:1px solid rgba(255,153,0,.6);color:#ffb84d;font-weight:700;letter-spacing:.14em;font-size:.76em;">GUIDED LAB</div>
<h1 class="psb-title" style="color:#ffffff;margin:14px 0 6px;border:0;line-height:1.25;">Getting Started</h1>
<div class="psb-sub" style="color:#d5dbe3;font-weight:600;">Your lab environment, navigation and sign-in</div>
<div class="psb-line" style="width:90px;height:3px;margin:14px auto 8px;border-radius:3px;background:#ff9900;"></div>
<div class="psb-chips" style="margin-top:8px;">
<span class="psb-chip" style="display:inline-block;margin:4px;padding:7px 14px;border-radius:999px;background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.30);color:#ffffff;font-weight:600;">🖥️ Lab VM</span>
<span class="psb-chip" style="display:inline-block;margin:4px;padding:7px 14px;border-radius:999px;background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.30);color:#ffffff;font-weight:600;">📑 Lab Guide</span>
<span class="psb-chip" style="display:inline-block;margin:4px;padding:7px 14px;border-radius:999px;background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.30);color:#ffffff;font-weight:600;">✅ Validation</span>
<span class="psb-chip" style="display:inline-block;margin:4px;padding:7px 14px;border-radius:999px;background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.30);color:#ffffff;font-weight:600;">🔐 AWS Console</span>
</div>
</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🖥️</span>Lab Environment

The lab window is split into two parts:

- **Left side:** your lab virtual machine (VM), a Windows Server 2022 workstation.
- **Right side:** the lab guide, with the steps to complete each task.

Your lab window looks like this:

<div class="psb-shot">

![Lab environment](./media/gs-01.png)

</div>

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧭</span>Lab Window Controls

The top bar and the lab guide menu give you these controls:

<div class="psb-shot">

![Lab window controls](./media/gs-topbar.png)

</div>

| # | Control | Use |
|:---:|---|---|
| 1 | **VM name** | Shows the lab VM you are connected to. |
| 2 | **Timer** | Time remaining in your lab session. |
| 3 | **Progress bar** | Your progress through the lab. |
| 4 | **A↕** | Change the text size of the lab guide. |
| 5 | **Refresh** | Reconnect the VM if the screen stops responding. |
| 6 | **More (...)** | Language, Delete and VM Native Clipboard options. |
| 7 | **Lab guide menu** | Guide, Environment, Progress, Resources and Help. |
| 8 | **Split window** | Split the lab guide and the VM into separate windows. |

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">⚙️</span>More Options

Select **More (...)** in the top bar to open these options:

<div class="psb-shot">

![More options](./media/gs-more-menu.png)

</div>

| Option | Use |
|---|---|
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🌍</span>**Language** | Switch the lab language, if multi-language support is enabled. |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🗑️</span>**Delete** | Delete the environment once your lab is complete. |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📋</span>**VM Native Clipboard** | Allows copying files within the VM. While it is on, text copied from your local PC cannot be pasted into the VM using keyboard shortcuts. You can turn it off at any time from **More (...)**. |

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📑</span>Lab Guide Menu

Use the tabs at the top of the lab guide to move between its sections:

<div class="psb-shot">

![Lab guide menu](./media/gs-menu.png)

</div>

| Option | Use |
|---|---|
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📖</span>**Guide** | All tasks and lab information. |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔑</span>**Environment** | Cloud console credentials and lab details. |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📈</span>**Progress** | Your points for validations. |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">⚙️</span>**Resources** | Start, stop or restart the lab VM. |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">❓</span>**Help** | Support information. |

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🧰</span>Working in the Lab

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📈</span>Progress

The **Progress** tab shows your overall points and the status of each validation check:

<div class="psb-shot">

![Progress tab](./media/gs-progress.png)

</div>

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔑</span>Exploring Your Resources

To view your credentials and resource details, navigate to the **Environment** tab:

<div class="psb-shot">

![Environment tab](./media/gs-02.png)

</div>

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🪟</span>Split Window

To open the lab guide in a separate window, select the **Split Window** button in the top-right corner:

<div class="psb-shot">

![Split window](./media/gs-05.png)

</div>

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🖥️</span>Managing Your Virtual Machine

You can start, stop or restart your virtual machine from the **Resources** tab:

<div class="psb-shot">

![Resources tab](./media/gs-06.png)

</div>

### <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📄</span>Page Navigation

Use **Previous**, the page numbers and **Next** at the bottom of the guide to move between pages:

<div class="psb-shot">

![Page navigation](./media/gs-next.png)

</div>

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">✅</span>Validate Your Work

Each lab ends with a **Validation Check**. Complete all tasks in the lab, scroll to the **Validation Check** at the end of the last task, and click **Validate**:

<div class="psb-shot">

![Validate button](./media/gs-validate.png)

</div>

- On success, the status shows **Success** and the points are added to your **Progress**.
- If a check fails, read the message, fix the issue and click **Validate** again.

> <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">💡</span>**Tip:** Validate as often as you like. There is no penalty and no limit.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔐</span>Sign In to the AWS Management Console

**Step 1:** On the lab VM desktop, double-click the **AWS Console** shortcut, or open the sign-in URL below in the browser:

| Detail | Value |
|---|---|
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔗</span>**Sign-in URL** | <inject key="SignInUrl" enableCopy="true"/> |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">👤</span>**IAM username** | <inject key="AWSUserName" enableCopy="true"/> |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔒</span>**Password** | <inject key="AWSPassword" enableCopy="true"/> |

> <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">💡</span>**Tip:** The same credentials are also saved in the **aws credentials.txt** file on the VM desktop.

**Step 2:** Enter the **IAM username (1)** and **Password (2)**, then click **Sign in (3)**:

<div class="psb-shot">

![AWS sign-in](./media/gs-03.png)

</div>

**Step 3:** In the top-right corner of the console, open the **Region** selector and choose **<inject key="LabRegion" enableCopy="false"/>**:

<div class="psb-shot">

![Region selector](./media/gs-04.png)

</div>

> <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">⚠️</span>**Note:** Create **every** resource in **<inject key="LabRegion" enableCopy="false"/>**. The pre-provisioned resources and the validation checks only look in this Region. If a resource seems to be missing, check the Region selector first.

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔌</span>Connect Using RDP (Optional)

To use your own RDP client instead of the browser-based VM, connect with these details:

| Detail | Value |
|---|---|
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">💻</span>**Computer** | <inject key="WindowsVMPublicIP" enableCopy="true"/> |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">👤</span>**Username** | <inject key="windowsvmAdminUsername" enableCopy="true"/> |
| <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🔒</span>**Password** | <inject key="WindowsVMPassword" enableCopy="true"/> |

</div>

<div class="psb-panel" style="background:#ffffff;border:1px solid #d5dbe3;border-radius:16px;padding:18px 16px;margin:24px 0;">

## <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">🆘</span>Support Contact

The CloudLabs support team is available 24/7 via email and live chat.

- <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">📧</span>**Email:** <a href="mailto:cloudlabs-support@spektrasystems.com">cloudlabs-support@spektrasystems.com</a>
- <span class="psb-ico" style="display:inline-flex;align-items:center;justify-content:center;width:1.9em;height:1.9em;border-radius:9px;margin-right:8px;vertical-align:middle;border:1px solid #dfe5ee;background:#ffffff;">💬</span>**Live chat:** <a href="https://support.cloudlabs.ai/isv">https://support.cloudlabs.ai/isv</a>

Click **Next** to view the **Lab Overview**.

</div>

</div>
