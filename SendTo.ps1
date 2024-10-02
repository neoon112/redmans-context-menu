param (
    [string]$filePath
)

$debug = "false" # CREATES A LOG FILE IN 'C:\Apps\Redmans-Context-Menu\'
$logFile = "C:\Apps\Redmans-Context-Menu\script-log.txt"

if ($debug -eq "true") {
    if (-Not (Test-Path $logFile)) {
        New-Item -Path $logFile -ItemType File
    }
    "Script started at $(Get-Date)" | Out-File $logFile -Append
    "Received file path: $filePath" | Out-File $logFile -Append
}

if (-Not (Test-Path $filePath)) {
    "Error: The file path does not exist: $filePath" | Out-File $logFile -Append
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show("Error: The file path does not exist: $filePath", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit
}

$url = "" #URL FOR DATABASE

$fileContent = Get-Content -Path $filePath -Raw

$body = @{
    "fileName" = [System.IO.Path]::GetFileName($filePath)
    "fileContent" = $fileContent
}

try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Body ($body | ConvertTo-Json) -ContentType "application/json"
    
    if ($response -eq "") {
        if ($debug -eq "true") {
            "Successfully uploaded at $(Get-Date)" | Out-File $logFile -Append
        }
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show("Upload successful!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } else {
        "Response: $response" | Out-File $logFile -Append
    }
} catch {
    $errorMessage = $_.Exception.Message
    "Error occurred during upload: $errorMessage" | Out-File $logFile -Append
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show("Error occurred during upload: $errorMessage", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}


if ($debug -eq "true") {
    "Script finished at $(Get-Date)" | Out-File $logFile -Append
    "" | Out-File $logFile -Append
}
