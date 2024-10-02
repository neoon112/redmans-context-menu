$logFile = "C:\Apps\Redmans-Context-Menu\script-log.txt"

"Script started at $(Get-Date)" | Out-File $logFile -Append

$filePath = Get-Content "C:\Apps\Redmans-Context-Menu\tempFilePath.txt"

"File path: $filePath" | Out-File $logFile -Append

$url = "" #URL FOR DATABASE

try {
    $response = Invoke-RestMethod -Uri $url -Method Post -InFile $filePath -ContentType "application/octet-stream"
    
    if ($response -eq "") {
        "Successfully uploaded at $(Get-Date)" | Out-File $logFile -Append
    } else {
        "Response: $response" | Out-File $logFile -Append
    }
}
catch {
    "Error occurred during upload: $($_.Exception.Message)" | Out-File $logFile -Append
}

"Script finished at $(Get-Date)" | Out-File $logFile -Append
