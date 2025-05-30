ffmpeg -rtsp_transport tcp \
-i "rtsp://admin:yourpassword@your-ip:554/h264Preview_01_main" \
-f lavfi -i anullsrc \
-shortest \
-c:v libx264 -preset veryfast -maxrate 3000k -bufsize 6000k \
-c:a aac -b:a 128k -f flv "rtmp://a.rtmp.youtube.com/live2/abcd-1234-xyz"
