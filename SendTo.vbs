Set objShell = CreateObject("WScript.Shell")
Set objArgs = WScript.Arguments

objShell.Run "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File ""C:\Apps\Redmans-Context-Menu\SendTo.ps1"" -filePath """ & objArgs(0) & """ -url """ & objArgs(1) & """", 0, True
