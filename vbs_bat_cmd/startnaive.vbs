dim strProcess,strFilename,strConfig,strCommand
strProcess="naive.exe"
strFilename="D:\Tools\proxy\Naive\naive.exe"
strConfig="D:\Tools\proxy\Naive\config.json"
strCommand="taskkill /f /im" &" "& strProcess
set ws=WScript.CreateObject("WScript.Shell")
'wscript.echo strCommand
ws.run strCommand,0
strCommand=strFilename &" "& strConfig
WScript.Sleep(500)
'wscript.echo strCommand
ws.run strCommand,0
