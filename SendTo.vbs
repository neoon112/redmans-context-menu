Set objShell = CreateObject("WScript.Shell")
Set objArgs = WScript.Arguments

powershellCommand = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File ""C:\Apps\Redmans-Context-Menu\SendTo.ps1"" -filePath """ & objArgs(0) & """"

objShell.Run powershellCommand, 0, True
