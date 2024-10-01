$appsFolder = "C:\Apps"
$storedFolder = "C:\Apps\Redmans-Context-Menu"

if (-Not (Test-Path -Path $appsFolder)) {
    New-Item -ItemType Directory -Path $appsFolder
    Write-Host "Created folder: $appsFolder"
}

if (-Not (Test-Path -Path $storedFolder)) {
    New-Item -ItemType Directory -Path $storedFolder
    Write-Host "Created folder: $storedFolder"
}

$fileUrl1 = "https://raw.githubusercontent.com/neoon112/$storedFolder/refs/heads/main/Tagfileas.ps1"
$fileUrl2 = "https://raw.githubusercontent.com/neoon112/$storedFolder/refs/heads/main/Tagfileas.vbs"
$fileUrl3 = "https://raw.githubusercontent.com/neoon112/$storedFolder/refs/heads/main/RenameToUninstaller.ps1"
$fileUrl4 = "https://raw.githubusercontent.com/neoon112/$storedFolder/refs/heads/main/Redmans.ico"

$destination1 = "$renameToFolder\Renameto.ps1"
$destination2 = "$renameToFolder\RunRenameFile.vbs"
$destination3 = "$renameToFolder\RenameToUninstaller.ps1"
$destination4 = "$renameToFolder\Redmans.ico"

Invoke-WebRequest -Uri $fileUrl1 -OutFile $destination1
Invoke-WebRequest -Uri $fileUrl2 -OutFile $destination2
Invoke-WebRequest -Uri $fileUrl3 -OutFile $destination3
Invoke-WebRequest -Uri $fileUrl4 -OutFile $destination4

Write-Host "Files downloaded to $storedFolder"

$basePath = "Registry::HKEY_CLASSES_ROOT\*\shell\$storedFolder"

New-Item -Path $basePath -Force

Set-ItemProperty -LiteralPath $basePath -Name "MUIVerb" -Value "Redmans" -Force

Set-ItemProperty -LiteralPath $basePath -Name "SubCommands" -Value "TAFILEAS; SENDTO;" -Force

Set-ItemProperty -LiteralPath $basePath -Name "Icon" -Value "C:\Apps\$storedFolder\Redmans.ico" -Force

$basePath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell"

if (-Not (Test-Path -Path $basePath)) {
    Write-Host "Base path does not exist: $basePath"
    return
}

New-Item -Path "$basePath\SENDTO" -Force
New-Item -Path "$basePath\TAGFILEAS" -Force
Set-ItemProperty -Path "$basePath\SENDTO" -Name "MUIVerb" -Value "Send to" -Force
Set-ItemProperty -Path "$basePath\TAGFILEAS" -Name "MUIVerb" -Value "Tag file as" -Force
Set-ItemProperty -Path "$basePath\SENDTO" -Name "SubCommands" -Value "QB;" -Force
Set-ItemProperty -Path "$basePath\TAGFILEAS" -Name "SubCommands" -Value "INC; VAL; OWN; ISSUE;" -Force

New-Item -Path "$basePath\OWN" -Force
New-Item -Path "$basePath\VAL" -Force
New-Item -Path "$basePath\INC" -Force
New-Item -Path "$basePath\ISSUE" -Force
New-Item -Path "$basePath\OWN\Command" -Force
New-Item -Path "$basePath\VAL\Command" -Force
New-Item -Path "$basePath\INC\Command" -Force
New-Item -Path "$basePath\ISSUE\Command" -Force

Set-ItemProperty -Path "$basePath\OWN\Command" -Name "(default)" -Value 'wscript "C:\Apps\$storedFolder\Tagfileas.vbs" "%1" "OWN"' -Force
Set-ItemProperty -Path "$basePath\VAL\Command" -Name "(default)" -Value 'wscript "C:\Apps\$storedFolder\Tagfileas.vbs" "%1" "VAL"' -Force
Set-ItemProperty -Path "$basePath\INC\Command" -Name "(default)" -Value 'wscript "C:\Apps\$storedFolder\Tagfileas.vbs" "%1" "INC"' -Force
Set-ItemProperty -Path "$basePath\ISSUE\Command" -Name "(default)" -Value 'wscript "C:\Apps\$storedFolder\Tagfileas.vbs" "%1" "ISSUE"' -Force

New-Item -Path "$basePath\QB" -Force
New-Item -Path "$basePath\QB\Command" -Force
Set-ItemProperty -Path "$basePath\QB\Command" -Name "(default)" -Value 'wscript "C:\Apps\$storedFolder\SendTo.vbs" "%1"' -Force

Write-Host "Registry keys created successfully."
