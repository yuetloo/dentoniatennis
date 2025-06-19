# start the camera client
Start-Process "C:\Program Files (x86)\Reolink\Reolink Client\Reolink Client.exe"

# wait for Reolink to start and then start OBS
Start-Sleep -Seconds 20
$obsPath = "C:\Program Files\obs-studio\bin\64bit"
Start-Process -FilePath "$obsPath\obs64.exe" -WorkingDirectory $obsPath

# wait for OBS to start and then start streaming
Start-Sleep -Seconds 60
Start-Process powershell -WindowStyle Hidden -ArgumentList "-ExecutionPolicy Bypass -File `\".\start_stream.ps1`\""
