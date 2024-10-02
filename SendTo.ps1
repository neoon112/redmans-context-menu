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

$fileExtension = [System.IO.Path]::GetExtension($filePath).ToLower()

$contentType = switch ($fileExtension) {
    ".txt" { "text/plain" }
    ".json" { "application/json" }
    ".xml" { "application/xml" }
    ".csv" { "text/csv" }
    ".jpg" { "image/jpeg" }
    ".jpeg" { "image/jpeg" }
    ".png" { "image/png" }
    ".gif" { "image/gif" }
    ".bmp" { "image/bmp" }
    ".tiff" { "image/tiff" }
    ".pdf" { "application/pdf" }
    ".doc" { "application/msword" }
    ".docx" { "application/vnd.openxmlformats-officedocument.wordprocessingml.document" }
    ".xls" { "application/vnd.ms-excel" }
    ".xlsx" { "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
    ".xlsm" { "application/vnd.ms-excel.sheet.macroEnabled.12" }
    ".html" { "text/html" }
    ".htm" { "text/html" }
    ".hthml" { "text/html" }
    ".msg" { "application/vnd.ms-outlook" }
    ".zip" { "application/zip" }
    ".dat" { "application/octet-stream" }
    ".myo" { "application/octet-stream" }
    ".myox" { "application/octet-stream" }
    ".mmap" { "application/octet-stream" }
    ".jng" { "image/x-jng" }
    ".webp" { "image/webp" }
    ".raw" { "image/x-raw" }
    ".cur" { "image/x-win-bitmap" }
    ".psb" { "application/octet-stream" }
    ".xcf" { "image/x-xcf" }
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
