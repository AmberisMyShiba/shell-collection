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
BIN_NAME="snell-server"
PKG_URL=$(curl -s "https://api.github.com/repos/surge-networks/snell/releases/latest" |grep linux-amd64 | grep browser_download_url | cut -d : -f 2,3 | tr -d \")
PKG_LATEST=$(curl -s "https://api.github.com/repos/surge-networks/snell/releases/latest" |grep linux-amd64 | grep browser_download_url | cut -d / -f 8 |sed 's/v/-/')
PKG_UNZIP_NAME=$(echo $PKG_URL|awk -F / '{print $NF}')
#echo "PKG_UNZIP_NAME:"$PKG_UNZIP_NAME;read -p "Debug Pause"
echo -e "1.The latest $BIN_NAME bin-release Version is:"
colorEcho ${YELLOW} "   ver$PKG_LATEST"
if [ -f "$PKG_UNZIP_NAME" ];then
  colorEcho ${RED} "2.The latest $BIN_NAME Release file is founded in current directory."
  colorEcho ${GREEN} "  Please replace it manually!"
  exit 1
fi
echo -e "3.Downloading the latest version."
rm -rf $PKG_UNZIP_NAME
wget $PKG_URL -q --show-progress # -O $PKG_UNZIP_NAME
echo -e "4.copy the $NIN_NAME bin file and chmod exec attribute"
if [ ! -f "$PKG_UNZIP_NAME" ]; then
  colorEcho ${YELLOW} "Not found the $BIN_NAME release bin-file,Please Check Downloading file correct!"
  exit 1
fi
unzip -o $PKG_UNZIP_NAME
echo -e "5.stoping $BIN_NAME.service in SystemD."
systemctl stop $BIN_NAME || kill -9 $(pidof $BIN_NAME)
echo -e "6.Copy latest bin files to $BIN_LOCAL_PATH"
#chmod +x ./$PKG_UNZIP_NAME
cp -f $BIN_NAME $BIN_LOCAL_PATH/$BIN_NAME
echo -e "7.restaring $BIN_NAME.service."
systemctl start $BIN_NAME
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
