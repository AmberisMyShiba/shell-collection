#!/bin/bash

#######color code########
RED="31m"      # Error message
YELLOW="33m"   # Warning message
GREEN="32m"
colorEcho(){
    echo -e "\033[${1}${@:2}\033[0m" 1>& 2
}

# Make sure only root can run our script
[ `whoami` != "root" ] && colorEcho ${RED} "This script must be run as root."  && exit 1

BIN_LOCAL_PATH="/usr/local/bin"
BIN_FILE="naive"
PKG_URL=$(curl -s "https://api.github.com/repos/klzgrad/naiveproxy/releases/latest" |grep linux-x64 | grep browser_download_url | cut -d : -f 2,3 | tr -d \")
PKG_LATEST=$(curl -s "https://api.github.com/repos/klzgrad/naiveproxy/releases/latest" |grep linux-x64 | grep browser_download_url | cut -d / -f 9 |tr -d \")
PKG_DIR=$(echo $PKG_LATEST | sed 's/\.tar.\xz//g')
echo -e "1.The latest naive bin-release Version is:"
colorEcho ${YELLOW} "   $PKG_LATEST"
if [ -f "$PKG_LATEST" ];then
  colorEcho ${RED} "2.The latest naive Release file is founded in current directory."
  colorEcho ${GREEN} "  Please run [tar -xf $PKG_LATEST] unzip files,and Replace naive manually!"
  exit 1
fi
echo -e "3.Downloading the latest version."
#curl -s "https://api.github.com/repos/klzgrad/naiveproxy/releases/latest" |grep linux-x64 | grep browser_download_url | cut -d : -f 2,3 | tr -d \"|wget -qi -
wget -q --show-progress $PKG_URL
echo -e "4.unzip and replace naive bin file"
if [ ! -f "$PKG_LATEST" ]; then
  colorEcho ${YELLOW} "Not found the naive release,Please Check Downloading file correct!"
  exit 1
fi
tar -xf $PKG_LATEST
echo -e "5.stoping naiveproxy.service in SystemD."
systemctl stop {naiveproxy,naive-redir,naive} >/dev/null 2>&1 || sudo kill $(pidof naive ) >/dev/null 2>&1
sudo ss-tproxy stop
sleep 2
echo -e "6.Copy latest naive bin files to $NAIVE_PATH"
cp $PKG_DIR/$BIN_FILE $BIN_LOCAL_PATH/
setcap cap_net_bind_service,cap_net_admin+ep $BIN_LOCAL_PATH/$BIN_FILE
echo -e "7.restaring naiveproxy.service."
#systemctl start {naiveproxy,naive-redir,naive} 2>/dev/null
sudo ss-tproxy start
colorEcho ${GREEN} "8.Cleaning Downloaded files..."
colorEcho ${YELLOW} "Do you want to DEL(default option)dowloaded files?(y/n)"
  read mychoice leftover
    case $mychoice in
        y|Y)
        colorEcho ${RED} "Delete confirmed!"
        rm -rf $PKG_DIR && rm -rf $PKG_LATEST;;
        n|N)
        colorEcho ${GREEN} "Files will be Saved.";;
        *)
        colorEcho ${GREEN} "Files will be Saved as default!";;
#        rm -rf $PKG_DIR && rm -rf $PKG_LATEST;;
    esac
colorEcho ${GREEN} "9.naive has been updated to the latest version!"
