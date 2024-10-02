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

$url = "https://prod-09.australiasoutheast.logic.azure.com/workflows/fb85df8287ff4666839ef6bcaf575eba/triggers/manual/paths/invoke/type/property/id/id/pass/123?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=MarU2y6QFL52zLdm9jauPVFH9k3MtbvrlkpU6IvbfjU" #URL FOR DATABASE

$fileExtension = [System.IO.Path]::GetExtension($filePath)

$contentType = switch ($fileExtension) {
    ".txt" { "text/plain" }
    ".json" { "application/json" }
    ".xml" { "application/xml" }
    ".csv" { "text/csv" }
    ".jpg" { "image/jpeg" }
    ".jpeg" { "image/jpeg" }
    ".png" { "image/png" }
    ".pdf" { "application/pdf" }
    ".docx" { "application/vnd.openxmlformats-officedocument.wordprocessingml.document" }
    ".xlsx" { "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
    ".xlsm" { "application/vnd.ms-excel.sheet.macroEnabled.12" }
    default { "application/octet-stream" } # Fallback for unsupported types
}

$fileContent = Get-Content -Path $filePath -Raw

$body = @{
    "fileName" = [System.IO.Path]::GetFileName($filePath)
    "fileContent" = $fileContent
}

try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Body ($body | ConvertTo-Json) -ContentType $contentType
    
    if ($response -eq "") {
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
