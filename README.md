# 🎥 YouTube Live Stream Automation

Automate YouTube live streaming via OBS and Reolink camera on a Windows machine using PowerShell, OBS WebSocket, and YouTube API.

---

## 📁 What’s Inside?

* **`reboot_stream.ps1`**
  Script triggered at system startup by Task Scheduler. It:

  1. Restarts the Reolink camera client
  2. Launches OBS
  3. Calls `start_stream.ps1` to initiate the stream

* **`start_stream.ps1`**
  Scheduled to run at 12 AM and 12 PM daily. It:

  1. Uses the YouTube API (via OAuth2) to create a broadcast
  2. Invokes `obs-cmd` (over OBS WebSocket) to begin streaming

---

## 🔧 Requirements

1. **Reolink camera client**
2. **OBS Studio** (v28+) with WebSocket plugin enabled
3. **obs-cmd** command-line tool
4. **Google Cloud OAuth credentials** to access YouTube API

---

## 📥 Installing obs-cmd

1. Download the latest Windows `.exe` from the \[obs-cmd releases page] (https://github.com/grigio/obs-cmd/releases)
2. Extract to a folder like `C:\obs\`

---

## ⚙️ Enabling OBS WebSocket

Ensure OBS → **Tools → WebSocket Server Settings** is enabled (OBS 28+ includes it by default) ([hubp.de][1]).

---

## ⏰ Task Scheduler Setup

### Create Task “Restart OBS Stream”

* **General**

  * Run whether user is logged on or not
  * Run with highest privileges

* **Triggers**

  1. Daily at 12:00 AM
  2. Daily at 12:00 PM

* **Actions**

  * Program: `powershell.exe`
  * Arguments: `-ExecutionPolicy Bypass -File "C:\obs\start_stream.ps1"`

* **Settings**

  * Allow on-demand runs
  * If fails, restart every minute (max 3 retries)

---

## 🛠️ Running It Manually

Open Task Scheduler → find "Restart OBS Stream" → right-click → **Run**.

Make sure the Reolink client and OBS are started before running the "Restart OBS Stream".

---

## 🧭 How It Works

* On **startup**, `reboot_stream.ps1` ensures services (Reolink, OBS) start cleanly, then hands off to `start_stream.ps1`.
* `start_stream.ps1`:

  1. Authenticates using your Google OAuth client
  2. Creates a YouTube live broadcast
  3. Uses `obs-cmd` to configure and start streaming to the new broadcast

---

## 🔐 YouTube OAuth Setup

1. Visit [Google Cloud Console](https://console.cloud.google.com)
2. Create OAuth 2.0 Client Credentials
3. Assign scopes for `YouTube` live streaming, e.g. YouTube Data API
4. Download `client_secret.json` and store securely

---

## ✅ Summary

* **`reboot_stream.ps1`** — startup initialization
* **`start_stream.ps1`** — scheduled live stream job
* **OBS + obs-cmd + Reolink + Google OAuth** — orchestrated automation

---

## 🛠️ Troubleshooting

### OBS prompts with **"Manage Broadcast"** after running `start_stream.ps1`

If OBS pops up the **"Manage Broadcast"** dialog instead of starting the stream automatically, check the following:

1. **Verify stream settings** in OBS:

   * Go to **Settings → Stream**
   * Ensure **Service** is set to `Custom...`
   * Confirm that the correct **Server** and **Stream Key** are filled in

2. Even if everything *looks* correct:

   * Click **OK** to save the settings again
   * Then **restart the script** (`start_stream.ps1`)

This issue sometimes occurs when OBS resets or does not load the custom stream settings correctly on first boot or after updates.

