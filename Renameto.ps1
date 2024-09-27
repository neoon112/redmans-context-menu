$filePath = $args[0]
$suffix = $args[1]  # Get the second argument for custom suffix

# Set a log file path for debugging
$logFile = "C:\Users\TomasStather\script_log.txt"
Start-Transcript -Path $logFile

try {
    # First, check if the file path is valid and not empty
    if (-not [string]::IsNullOrWhiteSpace($filePath) -and -not [string]::IsNullOrWhiteSpace($suffix)) {
        
        # Trim and sanitize the file path
        $filePath = $filePath.Trim()

        # Split the directory and the filename
        $directory = Split-Path -Parent $filePath
        $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
        $extension = [System.IO.Path]::GetExtension($filePath)

        # Log the individual parts
        Write-Host "Directory: $directory"
        Write-Host "File Name without Extension: $fileNameWithoutExtension"
        Write-Host "File Extension: $extension"

        # Construct the new file name with the custom suffix
        $newFileName = "$fileNameWithoutExtension$suffix$extension"
        $newFilePath = Join-Path $directory $newFileName

        # Log the new file path
        Write-Host "New file path: $newFilePath"

        # Rename the file
        Rename-Item -Path $filePath -NewName $newFilePath
    } else {
        Write-Host "Invalid file path or suffix received."
    }
} catch {
    Write-Error $_
}

Stop-Transcript
