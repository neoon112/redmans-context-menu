Set objShell = CreateObject("WScript.Shell")
filePath = WScript.Arguments(0)

' Define the custom suffix directly here
customSuffix = WScript.Arguments(1)

' Command to run the PowerShell script with the file path and custom suffix
command = "powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File ""C:\Apps\RenameTo\Renameto.ps1"" """ & filePath & """ """ & customSuffix & """"
objShell.Run command, 0, True
