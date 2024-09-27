$appsFolder = "C:\Apps"
$renameToFolder = "C:\Apps\RenameTo"

if (-Not (Test-Path -Path $appsFolder)) {
    New-Item -ItemType Directory -Path $appsFolder
    Write-Host "Created folder: $appsFolder"
}

if (-Not (Test-Path -Path $renameToFolder)) {
    New-Item -ItemType Directory -Path $renameToFolder
    Write-Host "Created folder: $renameToFolder"
}

$fileUrl1 = "https://raw.githubusercontent.com/neoon112/renameto/refs/heads/main/Renameto.ps1"
$fileUrl2 = "https://raw.githubusercontent.com/neoon112/renameto/refs/heads/main/RunRenameFile.vbs"

$destination1 = "$renameToFolder\Renameto.ps1"
$destination2 = "$renameToFolder\RunRenameFile.vbs"

Invoke-WebRequest -Uri $fileUrl1 -OutFile $destination1
Invoke-WebRequest -Uri $fileUrl2 -OutFile $destination2

Write-Host "Files downloaded to $renameToFolder"

$basePath = "Registry::HKEY_CLASSES_ROOT\*\shell\RenameTo"

New-Item -Path $basePath -Force

Set-ItemProperty -LiteralPath $basePath -Name "MUIVerb" -Value "Rename To" -Force

Set-ItemProperty -LiteralPath $basePath -Name "SubCommands" -Value "OWN; VAL; INC; ISSUE" -Force

$basePath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell"

if (-Not (Test-Path -Path $basePath)) {
    Write-Host "Base path does not exist: $basePath"
    return
}

New-Item -Path "$basePath\OWN" -Force
New-Item -Path "$basePath\VAL" -Force
New-Item -Path "$basePath\INC" -Force
New-Item -Path "$basePath\ISSUE" -Force
New-Item -Path "$basePath\OWN\Command" -Force
New-Item -Path "$basePath\VAL\Command" -Force
New-Item -Path "$basePath\INC\Command" -Force
New-Item -Path "$basePath\ISSUE\Command" -Force

Set-ItemProperty -Path "$basePath\OWN\Command" -Name "(default)" -Value 'wscript "C:\Apps\RenameTo\RunRenameFile.vbs" "%1" "OWN"' -Force
Set-ItemProperty -Path "$basePath\VAL\Command" -Name "(default)" -Value 'wscript "C:\Apps\RenameTo\RunRenameFile.vbs" "%1" "VAL"' -Force
Set-ItemProperty -Path "$basePath\INC\Command" -Name "(default)" -Value 'wscript "C:\Apps\RenameTo\RunRenameFile.vbs" "%1" "INC"' -Force
Set-ItemProperty -Path "$basePath\ISSUE\Command" -Name "(default)" -Value 'wscript "C:\Apps\RenameTo\RunRenameFile.vbs" "%1" "ISSUE"' -Force

Write-Host "Registry keys created successfully."