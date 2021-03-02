@echo off
title V2ray客户端配置切换程序
mode con cols=85 lines=25
color 20

:Start
rem 下面一行定义v2ray可执行文件全路径名
set v2ray_path="D:\ToolApps\proxy\v2ray\wv2ray.exe"
set naive_path="D:\ToolApps\proxy\Naive\naive.exe"
set xray_path="D:\ToolApps\proxy\Xray\xray.exe"
rem 下面两行定义v2ray配置文件的全路径名
set confTLS="D:\ToolApps\proxy\v2ray\Client_config_wstls_caddy_tefiszx.json"
set confVLESS="D:\ToolApps\proxy\v2ray\Client_config_VLESS_h2_caddy.json"
set confHTTP2="D:\ToolApps\proxy\v2ray\Client_config_http2_caddy.json"
set confNaive="D:\ToolApps\proxy\Naive\config.json"
set confXray="D:\ToolApps\proxy\Xray\config.json"
set tle=V2ray客户端配置切换


:Menu
cls
echo.
echo.
echo 「 %tle% 」
echo.
echo   [1] 启动V2ray WS+TLS加密服务端Caddy反代配置CloundFlare中继
echo.
echo   [2] 启动V2ray VLESS协议H2+tls+caddy反代配置Vultr SiliconValley[45.63.93.11]
echo.
echo   [3] 启动V2ray HTTP2+TLS加密服务端Caddy反代配置Banwagong GIA CN2[173.242.112.62]
echo.
echo   [4] 启动NaiveProxy@tefiszx.ga(NoCDN)
echo.
echo   [5] 启动Xray Vless+TLS+Cloudeve私有云
echo.
echo   [0] 退出
echo.
echo.

rem choice /t 5 /c 1234 /d 4

set choice=
set /p choice=选择V2ray客户端运行模式，按[0]键退出：

if %choice% EQU 1 (
	goto TLS
) else if %choice% EQU 2 (
	goto VLESS
) else if %choice% EQU 3 (
	goto HTTP2
) else if %choice% EQU 4 (
	goto NAIVE
) else if %choice% EQU 5 (
	goto XRAY
) else if %choice% EQU 0 (
	goto AllQuit
) else (
	echo.
	echo.无效的输入！按任意键继续...
	echo.
	pause>nul
)
goto Menu

:TLS
    echo.
    echo 正在重新启动wV2ray进程
    echo.
    taskkill /f /im wv2ray.exe >nul 2>nul
    taskkill /f /im v2ray.exe >nul 2>nul
    taskkill /f /im naive.exe >nul 2>nul
    echo.
    start "V2ray" %v2ray_path% -config %confTLS%
    rem if not errorlevel 0 goto err
    echo.
    echo V2ray已经重新启动，当前的模式为TLS服务端Caddy反代：
    rem echo.
    rem echo %confTLS%
    goto End

:VLESS
    echo.
    echo 正在重新启动wV2ray进程
    echo.
    taskkill /f /im wv2ray.exe >nul 2>nul
    taskkill /f /im v2ray.exe >nul 2>nul
    taskkill /f /im naive.exe >nul 2>nul
    echo.
    start "V2ray" %v2ray_path% -config %confVLESS%
    rem if not %errorlevel% equ 0 goto err
    echo.
    echo V2ray已经重新启动，当前模式为VLESS+h2+caddy反代：
    goto End

:HTTP2
echo.
    echo 正在重新启动wV2ray进程
    echo.
    taskkill /f /im wv2ray.exe >nul 2>nul
    taskkill /f /im v2ray.exe >nul 2>nul
    taskkill /f /im naive.exe >nul 2>nul
    echo.
    start "V2ray" %v2ray_path% -config %confHTTP2%
    rem f not %errorlevel% equ 0 goto err
    echo.
    echo V2ray已经重新启动，当前模式为Http2 TLS加密Caddy反代：
    goto End

:NAIVE
    echo.
    echo 正在关闭V2ray和naive进程
    echo.
    taskkill /f /im wv2ray.exe >nul 2>nul
    taskkill /f /im v2ray.exe >nul 2>nul
    taskkill /f /im naive.exe >nul 2>nul
    echo.
    echo 正在启动Naive进程
    start "NaiveProxy" %naive_path% %confNaive%
    rem if not errorlevel 0 goto err
    echo.
    echo 已经切换到Naive代理模式：
    echo.
    goto End

:XRAY
    echo.
    echo 正在关闭Xray进程
    echo.
    taskkill /f /im xray.exe >nul 2>nul
    taskkill /f /im v2ray.exe >nul 2>nul
    taskkill /f /im naive.exe >nul 2>nul
    echo.
    echo 正在启动Xray进程
    start "XrayProxy" %xray_path% %confxray%
    rem if not errorlevel 0 goto err
    echo.
    echo 已经切换到Xray代理模式：
    echo.
    goto End

:err
    echo.
    echo 运行程序出错，请检查代理的程序路径与配置文件
    echo.
    pause
    exit
:End
    echo.
    echo 操作完成 !!!
    echo.
    rem pause>nul
    set /p option=是否退出(Y/N)：
    if %option% EQU y (
	popd&exit
	) else if %option% EQU Y (
	popd&exit
    ) else (
	echo.
	echo
	echo.
	goto Menu
)

:AllQuit
  set /p quitoption=是否同时退出rayCore核心与Naive核心(y/n)：
   if %quitoption% EQU y (
      taskkill /f /im wv2ray.exe >nul 2>nul
      taskkill /f /im v2ray.exe >nul 2>nul
      taskkill /f /im naive.exe >nul 2>nul
      taskkill /f /im xray.exe >nul 2>nul
      popd&exit
  ) else if %quitoption% EQU Y (
      taskkill /f /im wv2ray.exe >nul 2>nul
      taskkill /f /im v2ray.exe >nul 2>nul
      taskkill /f /im naive.exe >nul 2>nul
      taskkill /f /im xray.exe >nul 2>nul
      popd&exit
  ) else (
  echo 已关闭v2ray与Naive进程并退出
  Popd&Exit
  )
    goto Start
