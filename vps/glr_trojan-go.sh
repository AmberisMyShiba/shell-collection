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
BIN_FILE="trojan-go"
BIN_FILE_TUN="trojan-go-tun"
PKG_URL=$(curl -s "https://api.github.com/repos/p4gefau1t/trojan-go/releases/latest" |grep trojan-go-linux-amd64 | grep browser_download_url | cut -d : -f 2,3 | tr -d \")
PKG_LATEST=$(curl -s "https://api.github.com/repos/p4gefau1t/trojan-go/releases/latest" |grep trojan-go-linux-amd64 | grep browser_download_url | cut -d / -f 8 |sed 's/v/-/')
PKG_UNZIP_NAME=trojan-go-linux-amd64$PKG_LATEST.zip
#echo "PKG_UNZIP_NAME:"$PKG_UNZIP_NAME;read -p "Debug Pause"
echo -e "1.The latest $BIN_NAME bin-release Version is:"
colorEcho ${YELLOW} "   ver$PKG_LATEST"
if [ -f "$PKG_UNZIP_NAME" ];then
  colorEcho ${RED} "2.The latest $BIN_FILE Release file is founded in current directory."
  colorEcho ${GREEN} "  Please replace it manually!"
  exit 1
fi
echo -e "3.Downloading the latest version."
wget $PKG_URL -q --show-progress -O $PKG_UNZIP_NAME

echo -e "4.copy the hysteria bin $BIN_FILE file and chmod exec attribute"
if [ ! -f "$PKG_UNZIP_NAME" -o ! -f"$PKG_UNZIP_NAME_TUN" ]; then
  colorEcho ${YELLOW} "Not found the $BIN_FILE release bin-file,Please Check Downloading file correct!"
  exit 1
fi
unzip -o $PKG_UNZIP_NAME
echo -e "5.stoping $BIN_FILE.service in SystemD."
systemctl stop trojan-go || kill -9 $(pidof trojan-go)
echo -e "6.Copy latest bin files to $BIN_LOCAL_PATH"

#install trojan-go
cp -f $BIN_FILE $BIN_LOCAL_PATH/$BIN_FILE
mkdir -p /usr/local/etc/trojan-go
cp -f geo*.* /usr/local/etc/trojan-go/
setcap cap_net_bind_service,cap_net_admin+ep $BIN_LOCAL_PATH/$BIN_FILE
echo -e "7.restaring $BIN_FILE.service."
systemctl start trojan-go
colorEcho ${GREEN} "8.Cleaning Downloaded files..."
colorEcho ${YELLOW} "Do you want to DEL(default option)dowloaded files?(y/n)"
  read mychoice leftover
    case $mychoice in
        y|Y)
        colorEcho ${RED} "Delete confirmed!"
        rm -rf $PKG_UNZIP_NAME && rm -rf $PKG_LATEST;;
        n|N)
        colorEcho ${GREEN} "Files will be Saved.";;
        *)
        colorEcho ${RED} "Files will be Deleted!"
        rm -rf $PKG_UNZIP_NAME && rm -rf $PKG_LATEST;;
    esac
colorEcho ${GREEN} "9.The $BIN_FILE has been updated to the latest version!"
