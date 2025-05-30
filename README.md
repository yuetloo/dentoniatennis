# How to Live Stream to Youtube


## Dowload ffmpeg

https://ffmpeg.org/download.html


## Download NSSM (Service Wrapper)

https://nssm.cc/download


## Run FFmpeg Command

stream2youtube.ps1


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
 
