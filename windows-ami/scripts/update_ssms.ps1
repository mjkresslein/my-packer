
# Access environment variables
$ssmsPath = $Env:ssmsPath
$latestVersionUrl = $Env:latestVersionUrl
$downloadPath = $Env:downloadPath

if (Test-Path $ssmsPath) {
    $versionInfo = (Get-Item $ssmsPath).VersionInfo
    Write-Host "Current SSMS Version: $($versionInfo.ProductVersion)"
} else {
    Write-Host "SSMS is not installed."
}

Invoke-WebRequest -Uri $latestVersionUrl -OutFile $downloadPath

Start-Process -FilePath $downloadPath -ArgumentList "/quiet" -Wait

Write-Host "SSMS has been updated to the latest version."
