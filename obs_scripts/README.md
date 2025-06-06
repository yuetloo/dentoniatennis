# Autostart YouTube live stream using obs-cmd

---

## ✅ Download `obs-cmd`:

### Option 1: **Precompiled Binary (Recommended if available)**

1. Go to:
   👉 [https://github.com/HiBoPC/obs-cmd/releases](https://github.com/HiBoPC/obs-cmd/releases)

2. Download the latest `.zip` for **Windows** under the **Assets** section.

3. Extract it somewhere like:

   ```
   C:\tools\obs-cmd\
   ```

4. Add that path to your system `PATH` environment variable (optional).

---

## 🔧 Install/Enable obs-websocket

Before `obs-cmd` will work:

* OBS 28+ and later includes it **by default**, just enable it:

  * OBS → `Tools` → `WebSocket Server Settings`

Make sure:

* The port (default: `4455`) is open
* You’ve set a password (or disabled authentication)

---


## ✅ Use Task Scheduler to start script

### 1. **Open Task Scheduler**

* Press `Win + R`, type `taskschd.msc`, hit Enter

### 2. **Create a New Task**

* Click **"Create Task..."** (not "Basic Task")

### 3. **General Tab**

* Name: `Restart OBS Stream`
* Check: ✅ “Run whether user is logged on or not”
* Check: ✅ “Run with highest privileges”

---

### 4. **Triggers Tab**

Click “New\...” three times to add:

* **Trigger 1: At system startup**

  * Begin the task: `At startup`

* **Trigger 2: At 12:00 AM**

  * Begin the task: `On a schedule`
  * Daily at 12:00 AM

* **Trigger 3: At 12:00 PM**

  * Same as above, but at 12:00 PM

Each trigger should have:

* ✅ Enabled
* Repeat task = No (unless you want)

---

### 5. **Actions Tab**

* Action: **Start a program**
* Program/script:

  ```powershell
  powershell.exe
  ```
* Add arguments:

  ```
  -ExecutionPolicy Bypass -File "C:\obs\start_stream.ps1"
  ```

---

### 6. **Conditions and Settings Tab**

* You can leave Conditions unchecked for full control
* Under **Settings** tab:

  * ✅ Allow task to be run on demand
  * ✅ Stop the task if it runs longer than: 1 hour (optional)
  * ✅ If the task fails, restart every 1 min, up to 3 times (optional)

---

## ✅ To Run Manually

You or any admin can:

* Go to Task Scheduler
* Right-click the task name → **Run**

