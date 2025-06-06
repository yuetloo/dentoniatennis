# Configuration
$host = "localhost"
$port = 4455
$password = "YourPassword"  # Leave as "" if no password
$obsCmd = "C:\obs\obs-cmd.exe"

function IsStreaming {
    $output = & $obsCmd --host $host --port $port --password $password stream status
    return $output -match '"outputActive":\s*true'
}

# Stop stream
Write-Host "Stopping stream..."
& $obsCmd --host $host --port $port --password $password stream stop

# Wait until the stream is confirmed stopped
Write-Host "Waiting for stream to end..."
$maxWait = 30  # seconds
$elapsed = 0

while (IsStreaming) {
    Start-Sleep -Seconds 2
    $elapsed += 2
    if ($elapsed -ge $maxWait) {
        Write-Warning "Stream did not stop within $maxWait seconds. Aborting."
        exit 1
    }
}

# Start stream
Write-Host "Starting stream..."
& $obsCmd --host $host --port $port --password $password stream start

