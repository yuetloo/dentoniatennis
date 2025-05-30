# How to Live Stream to Youtube Live Continuously

## Using bat and task scheduler
🎬 How it works:
*	Streams your webcam to YouTube using FFmpeg
*	Automatically restarts if FFmpeg fails or exits
*	Includes a short 5-second delay between retries

⸻

✅ Instructions

🔧 Step 1: Download ffmpeg

```
https://ffmpeg.org/download.html

# on windows
winget install ffmpeg
```


2. Open start-stream.bat, and replace:
*	USB2.0 Camera with your actual webcam device name
*	Microphone (Realtek Audio) with your actual microphone device name
*	YOUR_STREAM_KEY with your YouTube stream key

```
# Identify your webcam on Windows
ffmpeg -list_devices true -f dshow -i dummy
```

```
# Look for webcam name under*
DirectShow video devices
```
3. Save start-stream.bat as `C:\ffmpeg-stream\start_stream.bat`

⸻

📌 Notes:
*	This will keep retrying forever if FFmpeg fails.
*	Make sure ffmpeg.exe is in your system PATH or use its full path in the command:

"C:\ffmpeg\bin\ffmpeg.exe" -f dshow -i ...



⸻

✅ Optional: Hide the Window at Startup

Use Task Scheduler to run wscript.exe with launch_hidden.vbs file at system startup.

1. Press Win + S and search "Task Scheduler"
2. Click `Create Basic Task...` or `Create Task`
4. (Optional): Run with highest privileges
5. Run whether user is logged on or not
6. Triggers Tab: click new to create trigger
7. Actions Tab: click new to set Action to Start a program
  - In Program/script: wscript.exe
  - In Add arguments: "C:\ffmpeg-stream\launch_hidden.vbs"


## Using NSSM (Service Wrapper)

```
# download nssm
https://nssm.cc/download
```

### Run script remotely: stream2youtube.ps1

*Note: update the script with your IP, credentials and youtube stream key*
- YouTube stream key can be found on https://studio.youtube.com



### Create windows service to start on restart and crash

Run as Administrator
C:\nssm\win64\nssm.exe install stream2youtube


### Start the Service

net start stream2youtube


### How to Update Stream Key Later
```
nssm edit ffmpeg-stream
```


