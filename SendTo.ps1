param (
    [string]$filePath
)

$url = "" #URL FOR DATABASE

$fileContent = Get-Content -Path $filePath -Raw

$body = @{
    "fileName" = [System.IO.Path]::GetFileName($filePath)
    "fileContent" = $fileContent
}

$response = Invoke-RestMethod -Uri $url -Method Post -Body ($body | ConvertTo-Json) -ContentType "application/json"

$response

Add-Type -AssemblyName System.Windows.Forms

if ($response -eq "")
{
    [System.Windows.Forms.MessageBox]::Show("Successfully uploaded!", "Result", 'OK', 'Information')
}
else
{
    [System.Windows.Forms.MessageBox]::Show("$response", "Error", 'OK', 'Error')   
}
