Set WshShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

strPath = Wscript.ScriptFullName
Set objFile = objFSO.GetFile(strPath)
strFolder = objFSO.GetParentFolderName(objFile) 

app =  chr(34) & "gvim.exe" & Chr(34)
options = "-p -u " & objFSO.BuildPath(strFolder,WScript.Arguments(0))
If WScript.Arguments.Count>2 Then
options = options & " " &WScript.Arguments(2)
End If

file = chr(34) & Wscript.Arguments(1) & chr(34)

cmd = app & " " & options & " " & file 
WshShell.Run cmd, 0
Set WshShell = Nothing
