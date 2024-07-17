dim strProcess,strFilename,strConfig,strCommand
strProcess="sing-box-windows-amd64.exe"
strFilename="D:\Tools\proxy\sing-box\" & strProcess
strConfig="D:\Tools\proxy\sing-box\multiple.json"
strCommand="taskkill /f /im" &" "& strProcess
set ws=WScript.CreateObject("WScript.Shell")

set fso=CreateObject("Scripting.FileSystemObject")
tFile = "C:\Windows\System32\drivers\etc\test.txt"
ws.run("%comspec% /c echo 123> " & tFile), 0, True
if not fso.FileExists(tFile) then
    CreateObject("Shell.Application").ShellExecute WScript.FullName, Chr(34) & WScript.ScriptFullName & Chr(34), "", "runas", 1
    WScript.Quit
else
    fso.DeleteFile(tFile)
end if

'wscript.echo strCommand
ws.run strCommand,0
strCommand=strFilename &" run -c "& strConfig
WScript.Sleep(500)
'wscript.echo strCommand
ws.run strCommand,0