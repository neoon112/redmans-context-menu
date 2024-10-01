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
