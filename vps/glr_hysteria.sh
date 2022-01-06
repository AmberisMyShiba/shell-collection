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
BIN_FILE="hysteria"
BIN_FILE_TUN="hysteria-tun"
PKG_URL=$(curl -s "https://api.github.com/repos/HyNetwork/hysteria/releases/latest" |grep hysteria-linux-amd64 | grep browser_download_url | cut -d : -f 2,3 | tr -d \")
PKG_URL_TUN=$(curl -s "https://api.github.com/repos/HyNetwork/hysteria/releases/latest" |grep hysteria-tun-linux-amd64 | grep browser_download_url | cut -d : -f 2,3 | tr -d \")
PKG_LATEST=$(curl -s "https://api.github.com/repos/HyNetwork/hysteria/releases/latest" |grep hysteria-linux-amd64 | grep browser_download_url | cut -d / -f 8 |sed 's/v/-/')
PKG_UNZIP_NAME=hysteria-linux-amd64$PKG_LATEST
PKG_UNZIP_NAME_TUN=hysteria-tun-linux-amd64$PKG_LATEST
#echo "PKG_UNZIP_NAME:"$PKG_UNZIP_NAME;read -p "Debug Pause"
echo -e "1.The latest $BIN_NAME bin-release Version is:"
colorEcho ${YELLOW} "   ver$PKG_LATEST"
if [ -f "$PKG_UNZIP_NAME" ];then
  colorEcho ${RED} "2.The latest Hysteria Release file is founded in current directory."
  colorEcho ${GREEN} "  Please replace it manually!"
  exit 1
fi
echo -e "3.Downloading the latest version."
wget $PKG_URL -q --show-progress -O $PKG_UNZIP_NAME
wget $PKG_URL_TUN -q --show-progress -O $PKG_UNZIP_NAME_TUN

echo -e "4.copy the hysteria bin file and chmod exec attribute"
if [ ! -f "$PKG_UNZIP_NAME" -o ! -f"$PKG_UNZIP_NAME_TUN" ]; then
  colorEcho ${YELLOW} "Not found the hysteria release bin-file,Please Check Downloading file correct!"
  exit 1
fi
#gzip -d $PKG_LATEST
echo -e "5.stoping hysteria.service in SystemD."
systemctl stop hysteria || kill -9 $(pidof hysteria)
echo -e "6.Copy latest bin files to $BIN_LOCAL_PATH"
chmod +x ./$PKG_UNZIP_NAME
chmod +x ./$PKG_UNZIP_NAME_TUN
cp -f $PKG_UNZIP_NAME $BIN_LOCAL_PATH/$BIN_FILE
cp -f $PKG_UNZIP_NAME_TUN $BIN_LOCAL_PATH/$BIN_FILE_TUN
echo -e "7.restaring hysteria.service."
systemctl start hysteria
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
colorEcho ${GREEN} "9.The Hysteria has been updated to the latest version!"
