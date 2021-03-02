set ws=WScript.CreateObject("WScript.Shell")
dim strname,strconfig
strname="D:\ToolApps\proxy\xray\xray.exe"
strconfig="D:\ToolApps\proxy\xray\config.json"
strfull=strname & " run " & strconfig
rem wscript.echo strfull
ws.Run strfull,0
rem ws.Run "D:\ToolApps\proxy\xray\xray.exe run D:\ToolApps\proxy\xray\config.json",0
