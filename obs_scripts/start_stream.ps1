# Configuration
$port = 4455
$password = "YourPassword"  # Leave as "" if no password
$obsCmd = "C:\obs\obs-cmd.exe"
$url = "obsws://localhost:${port}/${password}"

# for creating YouTube broadcasts
$clientId = 'YOUR_CLIENT_ID'
$clientSecret = 'YOUR_CLIENT_SECRET'
$refreshToken = 'YOUR_REFRESH_TOKEN'
$streamId = 'YOUR_STREAM_ID'

function IsStreaming {
    $output = & $obsCmd --websocket ${url} streaming status
    return $output -match '"outputActive":\s*true'
}

function Get-LiveStreamTitle {
    $now = Get-Date
    $datePart = $now.ToString('yyyy-MM-dd')
    $timePart = $now.ToString('hh:mm tt')
    return "Dentonia Tennis Live, $datePart $timePart"
}

function New-YouTubeBroadcast {
    try {
        Write-Output "Requesting new access token..."
        $tokenResponse = Invoke-RestMethod `
          -Method POST `
          -Uri "https://oauth2.googleapis.com/token" `
          -Body @{
            client_id     = $clientId
            client_secret = $clientSecret
            refresh_token = $refreshToken
            grant_type    = 'refresh_token'
          } `
          -ErrorAction Stop

        $accessToken = $tokenResponse.access_token
        Write-Output "Access token retrieved."

        $startTime = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        $endTime   = (Get-Date).ToUniversalTime().AddHours(1).ToString("yyyy-MM-ddTHH:mm:ssZ")
        $title = Get-LiveStreamTitle

        $broadcastBody = @{
            snippet = @{
                title = $title
                scheduledStartTime = $startTime
                scheduledEndTime   = $endTime
            }
            status = @{
                privacyStatus = "public"
                selfDeclaredMadeForKids = $false
            }
            contentDetails = @{
                enableAutoStart = $true
                enableAutoStop  = $true
                enableLiveChat  = $false
            }
        } | ConvertTo-Json -Depth 10

        $response = Invoke-RestMethod `
          -Method POST `
          -Uri "https://www.googleapis.com/youtube/v3/liveBroadcasts?part=snippet,status,contentDetails" `
          -Headers @{ Authorization = "Bearer $accessToken" } `
          -ContentType "application/json" `
          -Body $broadcastBody `
          -ErrorAction Stop

        Write-Output "Broadcast created successfully!"
        $response | Format-List

        $broadcastId = $response.id
        $bindUri = "https://www.googleapis.com/youtube/v3/liveBroadcasts/bind?id=$broadcastId&part=id,contentDetails&streamId=$streamId"

        $bindResponse = Invoke-RestMethod `
          -Method POST `
          -Uri $bindUri `
          -Headers @{ Authorization = "Bearer $accessToken" }

        Write-Output "Broadcast bound to stream."
        return $true
    }
    catch {
        Write-Warning "An error occurred while creating broadcast: $_"
        return $false
    }
}

# Stop stream
Write-Host "Stopping stream..."
& $obsCmd --websocket ${url} streaming stop

# Wait for stream to end
Write-Host "Waiting for stream to end..."
$maxWait = 30
$elapsed = 0
while (IsStreaming) {
    Start-Sleep -Seconds 2
    $elapsed += 2
    if ($elapsed -ge $maxWait) {
        Write-Warning "Stream did not stop within $maxWait seconds. Aborting."
        exit 1
    }
}

Write-Host "Wait for YouTube to end current broadcast..."
Start-Sleep -Seconds 30

# Create and bind new broadcast
if (New-YouTubeBroadcast) {
    Write-Host "Starting stream..."
    & $obsCmd --websocket ${url} streaming start
} else {
    Write-Warning "Broadcast creation failed. Stream not started."
}

