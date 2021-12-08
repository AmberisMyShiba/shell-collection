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

BIN_NAME="gost"
BIN_LOCAL_PATH="/usr/local/bin"
PKG_URL=$(curl -s "https://api.github.com/repos/ginuerzh/gost/releases/latest" |grep linux-amd64 | grep browser_download_url | cut -d : -f 2,3 | tr -d \")
PKG_LATEST=$(curl -s "https://api.github.com/repos/ginuerzh/gost/releases/latest" |grep linux-amd64 | grep browser_download_url | cut -d / -f 9 |tr -d \")
PKG_UNZIP_NAME=$(echo $PKG_LATEST | sed 's/\.gz//g')
echo -e "1.The latest $BIN_NAME bin-release Version is:"
colorEcho ${YELLOW} "   $PKG_LATEST"
if [ -f "$PKG_LATEST" ];then
  colorEcho ${RED} "2.The latest $BIN_NAME Release file is founded in current directory."
  colorEcho ${GREEN} "  Please run [gzip -d $PKG_LATEST] unzip files,and Replace manually!"
  exit 1
fi
echo -e "3.Downloading the latest version."
wget $PKG_URL -q --show-progress
echo -e "4.unzip and replace $BIN_NAME bin file"
if [ ! -f "$PKG_LATEST" ]; then
  colorEcho ${YELLOW} "Not found the $BIN_NAME release,Please Check Downloading file correct!"
  exit 1
fi
gzip -d $PKG_LATEST
echo -e "5.stoping $BIN_NAME.service in SystemD."
#read -p "Debug Pause"
systemctl stop $BIN_NAME||kill -9 $(pidof $BIN_NAME)||colorEcho ${YELLOW} "Not found the $BIN_NAME process,Can't stop or kill $BIN_NAME daemon"
echo -e "6.Copy latest $BIN_NAME bin files to $BIN_LOCAL_PATH"
chmod +x ./$PKG_UNZIP_NAME
cp -f $PKG_UNZIP_NAME $BIN_LOCAL_PATH/$BIN_NAME
echo -e "7.restaring $BIN_NAME.service."
systemctl start $BIN_NAME||colorEcho ${RED} "Not found the $BIN_NAME systemD daemon,Please start manually!"
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
colorEcho ${GREEN} "9.The $BIN_NAME has been updated to the latest version!"
