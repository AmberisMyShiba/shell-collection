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

GOST_LOCAL_PATH="/usr/local/bin"
PKG_URL=$(curl -s "https://api.github.com/repos/ginuerzh/gost/releases/latest" |grep linux-amd64 | grep browser_download_url | cut -d : -f 2,3 | tr -d \")
PKG_LATEST=$(curl -s "https://api.github.com/repos/ginuerzh/gost/releases/latest" |grep linux-amd64 | grep browser_download_url | cut -d / -f 9 |tr -d \")
PKG_UNZIP_NAME=$(echo $PKG_LATEST | sed 's/\.gz//g')
echo -e "1.The latest gost bin-release Version is:"
colorEcho ${YELLOW} "	$PKG_LATEST"
if [ -f "$PKG_LATEST" ];then
  colorEcho ${RED} "2.The latest gost Release file is founded in current directory."
  colorEcho ${GREEN} "	Please run [gzip -d $PKG_LATEST] unzip files,and Replace gost manually!"
  exit 1
fi
echo -e "3.Downloading the latest version."
wget $PKG_URL -q --show-progress
echo -e "4.unzip and replace gost bin file"
if [ ! -f "$PKG_LATEST" ]; then
  colorEcho ${YELLOW} "Not found the gost release,Please Check Downloading file correct!"
  exit 1
fi
gzip -d $PKG_LATEST
echo -e "5.stoping gost.service in SystemD."
systemctl stop gost
kill -9 $(pidof gost)
echo -e "6.Copy latest gost bin files to $GOST_LOCAL_PATH"
chmod +x ./$PKG_UNZIP_NAME
cp -f $PKG_UNZIP_NAME $GOST_LOCAL_PATH/gost
echo -e "7.restaring gost.service."
systemctl start gost
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
colorEcho ${GREEN} "9.The gost has been updated to the latest version!"
