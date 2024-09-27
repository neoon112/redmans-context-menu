$filePath = $args[0]
$suffix = $args[1]

# Everything that says #uncomment you can uncomment for a log file to debug if this does not work

#$logFile = "C:\Apps\RenameTo\script_log.txt" # uncomment
#Start-Transcript -Path $logFile # uncomment

try {
    if (-not [string]::IsNullOrWhiteSpace($filePath) -and -not [string]::IsNullOrWhiteSpace($suffix)) {
        
        $filePath = $filePath.Trim()

        $directory = Split-Path -Parent $filePath
        $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
        $extension = [System.IO.Path]::GetExtension($filePath)

        Write-Host "Directory: $directory"
        Write-Host "File Name without Extension: $fileNameWithoutExtension"
        Write-Host "File Extension: $extension"

        $newFileName = "$fileNameWithoutExtension$suffix$extension"
        $newFilePath = Join-Path $directory $newFileName

        Write-Host "New file path: $newFilePath"

        Rename-Item -Path $filePath -NewName $newFilePath
    } else {
        Write-Host "Invalid file path or suffix received."
    }
} catch {
    Write-Error $_
}

#Stop-Transcript #uncomment
