@echo off
REM Replace with the path to the cloned repository
set "REPO_PATH=sing-box"

REM Move to the repository directory
cd /d %REPO_PATH% || (
  echo Failed to change directory to %REPO_PATH%
  exit /b 1
)

rem 设置max_count变量和count变量
set max_count=3
set count=0

rem 延迟环境变量扩展
setlocal EnableDelayedExpansion

for /F "tokens=*" %%a in ('git rev-list --tags --max-count=%max_count%') do (
  set /A count+=1
  set tag!count!=%%a
)

REM List available tags
for /L %%i in (1,1,%count%) do (
  rem echo !tag%%i!
  git describe --tags !tag%%i!
  rem 定义一个变量，储存tag
)

REM Set default if no input
:input
set /p selected_tag="Which tag (by number or full name) do you want to checkout? "
if not defined selected_tag set "selected_tag=1"

:check
REM Check if selected tag is a number and within range
if %selected_tag% gtr 0 (
  rem 检查输入的 %selected_tag% 是否小于等于 count
  if %selected_tag% leq %count% (
    echo You selected tag %selected_tag%.
    set tag_name=!tags[%selected_tag%]!
    echo tag_name=!tag_name!
    rem 跳转到编译代码行
    goto :compile
  ) else (
    echo "Invalid input. Please enter a number between 1 and %count%."
    set  selected_tag=
    goto :input
  )
) else (
  echo "Invalid input. Please enter a number between 1 and  %count%."
  set  selected_tag=
  goto :input
)

:compile
REM Ask if user wants to continue compiling
set /p choice="Do you want to continue compiling? [y/n] "
if not defined choice set "choice=y"
if /i "%choice%"~="y" (
  rem 开始编译
  for /F "tokens=*" %%c in ('go run ./cmd/internal/read_tag') do (
    set VERSION=%%c
  )
  echo sing-box VERSION is !VERSION!
  go install -v -trimpath -ldflags "-X \"github.com/sagernet/sing-box/constant.Version=$VERSION\"-s -w -buildid=" -tags with_gvisor,with_clash_api,with_grpc,with_utls,with_ech,with_reality_server,with_quic,with_wireguard,with_acme .\cmd\sing-box
  %GOBIN%\sing-box version
) else (
  echo Aborted.
)


