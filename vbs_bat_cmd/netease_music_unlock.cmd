@echo off
title 网易云音乐版权解锁本地代理开启脚本
mode con cols=90 lines=30

rem 检测是否运行在管理员模式
net session >nul 2>nul
if not %ERRORLEVEL% equ 0 goto msg

cd /d d:\ToolApps\UnblockNeteaseMusic\UnblockNeteaseMusic-master

rem 检测代理是否已经运行

netstat -aon|findstr 18080 >nul 2>nul

if %ERRORLEVEL% EQU 0 goto err1
pm2 start app.js -- -p 18080
pause
rem node app.js -p 18080
netstat -aon|findstr 18080 >NUL 2>NUL
if not %ERRORLEVEL% equ 0 goto err2
echo.
echo 网易云音乐node.js解锁版权http代理已运行
echo 代理主机：localhost 127.0.0.1
echo 代理端口：18080
echo.
pause
exit


:msg
echo.
echo 本脚本需要以【管理员】模式运行。按任意键退出。
echo.
pause >nul
exit

:err1
echo.
echo 代理已经运行或端口号18080被其他程序占用
echo 请运行netstat -aon|fintstr 18080 查看占用端口情况
echo 按任意键退出
echo.
pause
exit


:err2 
echo.
echo 运行程序出错，未检测到正确的代理端口
echo.
pause
exit
