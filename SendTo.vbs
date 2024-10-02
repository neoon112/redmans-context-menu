Set objShell = CreateObject("WScript.Shell")
Set objArgs = WScript.Arguments

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set tempFile = objFSO.CreateTextFile("C:\Apps\Redmans-Context-Menu\tempFilePath.txt", True)
tempFile.WriteLine(objArgs(0))
tempFile.Close

objShell.Run "schtasks /run /tn ""SendTo"""
