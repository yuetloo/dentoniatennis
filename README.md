# How to Live Stream to Youtube


## Dowload ffmpeg

https://ffmpeg.org/download.html


## Download NSSM (Service Wrapper)

https://nssm.cc/download


## Run FFmpeg Command

Run script: stream2youtube.ps1

*Note: update the script with your IP, credentials and youtube stream key*
- YouTube stream key can be found on https://studio.youtube.com


## Create windows service to start on restart and crash

Run as Administrator
C:\nssm\win64\nssm.exe install stream2youtube


## Start the Service

net start stream2youtube


## How to Update Stream Key Later
```
nssm edit ffmpeg-stream
```


## Get the Youtube stream key

https://studio.youtube.com/
 
