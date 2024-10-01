Set objShell = CreateObject("WScript.Shell")
Set objArgs = WScript.Arguments

' Construct the PowerShell command
powershellCommand = "powershell.exe -ExecutionPolicy Bypass -File ""C:\Apps\Redmans-Context-Menu\SendTo.ps1"" """ & objArgs(0) & """"

' Run the PowerShell script
objShell.Run powershellCommand, 0, True
