# Log deployment metadata
$deploymentLog = @{
    BuildNumber = $env:bamboo_buildNumber
    Package     = $packageName
    Version     = "1.0.$env:bamboo_buildNumber"
    Environment = "Staging"
    Timestamp   = (Get-Date).ToString("s")
} | ConvertTo-Json

# Save log to artifacts directory
$logFile = Join-Path $artifactsDir "deployment-log.json"
$deploymentLog | Out-File $logFile

Write-Host "=== Deployment metadata logged ==="
Write-Host "Log file: $logFile"

# Optionally push to Confluence via REST API
Invoke-RestMethod -Uri "https://confluence.company.com/rest/api/content/12345" `
    -Method POST `
    -Headers @{Authorization="Bearer $env:CONF_TOKEN"} `
    -Body $deploymentLog
