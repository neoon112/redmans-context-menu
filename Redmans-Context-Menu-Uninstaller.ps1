Remove-Item -LiteralPath "Registry::HKEY_CLASSES_ROOT\*\shell\Redmans-Context-Menu" -Recurse -Force

$basePath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell"
Remove-Item -LiteralPath "$basePath\INC" -Recurse -Force
Remove-Item -LiteralPath "$basePath\ISSUE" -Recurse -Force
Remove-Item -LiteralPath "$basePath\OWN" -Recurse -Force
Remove-Item -LiteralPath "$basePath\QB" -Recurse -Force
Remove-Item -LiteralPath "$basePath\SENDTO" -Recurse -Force
Remove-Item -LiteralPath "$basePath\TAGFILEAS" -Recurse -Force
Remove-Item -LiteralPath "$basePath\VAL" -Recurse -Force

$nameOfProgram = "Redmans-Context-Menu"
$folderPath = "C:\Apps\$nameOfProgram"
$excludeFile = "$nameOfProgram-Uninstaller.ps1"

Get-ChildItem -Path $folderPath -File | Where-Object { $_.Name -ne $excludeFile } | Remove-Item -Force
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show("Successfully uninstalled!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
Get-ChildItem -Path $folderPath -Directory | Remove-Item -Recurse -Force
Remove-Item -Path "C:\Apps\$nameOfProgram" -Recurse -Force
