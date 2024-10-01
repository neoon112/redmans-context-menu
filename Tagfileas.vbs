Set objShell = CreateObject("WScript.Shell")
filePath = WScript.Arguments(0) ' this is the "%1" argument in regedit

customSuffix = WScript.Arguments(1) ' this is what appends to the file name (also from regedit)

command = "powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File ""C:\Apps\Redmans-Context-Menu\Tagfileas.ps1"" """ & filePath & """ """ & customSuffix & """" ' this calls on the powershell script to rename with the arguments defined before
objShell.Run command, 0, True

' why this vbs file is used instead of just the powershell one is to hide the terminal that powershell opens when directly called upon from regedit
