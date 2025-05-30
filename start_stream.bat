@echo off
:loop
echo Starting FFmpeg stream...
ffmpeg -f dshow -i video="USB2.0 Camera":audio="Microphone (Realtek Audio)" ^
-vcodec libx264 -preset veryfast -tune zerolatency -b:v 2500k -s 1280x720 ^
-acodec aac -ar 44100 -b:a 128k -f flv ^
rtmp://a.rtmp.youtube.com/live2/YOUR_STREAM_KEY

echo FFmpeg crashed or stopped. Restarting in 5 seconds...
timeout /t 5
goto loop
