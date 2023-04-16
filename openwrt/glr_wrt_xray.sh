#!/bin/bash

#######color code########
RED="31m"      # Error message
YELLOW="33m"   # Warning message
GREEN="32m"
colorEcho(){
    echo -e "\033[${1}${@:2}\033[0m" 1>& 2
}

# Make sure only root can run our script
#[ `whoami` != "root" ] && colorEcho ${RED} "This script must be run as root."  && exit 1

BIN_NAME="xray"
BIN_LOCAL_PATH="/usr/bin"
ARCH_KEYWORD="linux-64"
REPO_NAME="XTLS/Xray-core"

while true; do
  PKG_URL=$(curl -s "https://api.github.com/repos/$REPO_NAME/releases/latest" | grep $ARCH_KEYWORD | grep browser_download_url | sed -n 1p | cut -d : -f 2,3)
  # 判断PKG_URL是否为空或者对应的文件是否可下载  if [[ -n "$PKG_URL" && "$(curl -s --head $PKG_URL | head -n 1 | grep 200)" != "" ]]; then
    echo "Successfully obtained the download link: $PKG_URL"
    break
  fi
  echo "Failed to obtain the download link. Retrying in 3 seconds..."
  sleep 3
done


#VER_LATEST=$(curl -s "https://api.github.com/repos/$REPO_NAME/releases/latest" | grep tag_name | cut -d ":" -f 2- | tr -d \" | tr -d \, | tr -d '[:space:]')
VER_LATEST=$(echo $PKG_URL|cut -d / -f8)
PKG_LATEST=$(echo $BIN_NAME-$VER_LATEST|tr -d ' ')
PKG_CURR_VER="$($BIN_LOCAL_PATH/$BIN_NAME -version | awk 'NR==1 {print $2}')"
PKG_DIR=$(echo $PKG_LATEST|sed s/\.tar.\xz//g)
#PKG_UNZIP_NAME="Xray-linux-64.zip"
#PKG_TAR=$(echo $PKG_LATEST|sed s/\.xz\//g)
#debug point
colorEcho {RED} "debug:PKG_LATEST=$PKG_LATEST"
colorEcho {RED} "debug:PKG_DIR=$PKG_DIR"

echo -e "1.The latest $BIN_NAME bin-release version for linux-64 is:"
colorEcho ${YELLOW} "   $PKG_LATEST"
if [ -f "$PKG_LATEST" ];then
  colorEcho ${RED} "2.The latest $BIN_NAME Release file is founded in current directory."
  colorEcho ${GREEN} "  Please run [unzip $PKG_LATEST] unzip files,and Replace $BIN_NAME manually!"
  exit 1
fi
echo -e "3.Downloading the latest version."
wget $PKG_URL -q --show-progress
echo -e "4.unzip and replace $BIN_NAME bin file"
if [ ! -f "$PKG_LATEST" ]; then
  colorEcho ${YELLOW} "Not found the $BIN_NAME release,Please Check Downloading file correct!"
  exit 1
fi
echo -e PKG_LATEST=$PKG_LATEST
echo -e PKG_DIR=$PKG_DIR
#colorEcho ${YELLOW} "file and dir is showed above!"

#xz -d $PKG_LATEST
#tar -xvf `echo $PKG_LATEST|cut -d . -f 1-5`
#tar -xvf `echo $PKG_LATEST|sed s/\.xz\//g`
unzip $PKG_LATEST
colorEcho ${YELLOW} "5.Please asure $BIN_NAME has been stopped!"
#echo -e "Or you should run:#ps -w|grep $BIN_NAME and kill -9 PID"

#kill -9 `pgrep naive` >/dev/null 2>&1
#/etc/init.d/shadowsocksr restart

sleep 2
echo -e $PKG_DIR
echo -e $PKG_TAR
#echo -e "the files above will be deleted!"
colorEcho ${GREEN} "6.Copy latest $BIN_NAME bin files to $BIN_LOCAL_PATH"
cp -f $PKG_DIR/$BIN_NAME $BIN_LOCAL_PATH/
echo -e "7.Tring restaring $BIN_NAME.service.May be you should restart it by manual"
###default="n"
###read -e -p "Do you want to DEL dowloaded files?" mychoice
###mychoice="${ac:-${default}}" 
colorEcho ${GREEN} "8.Cleaning Downloaded files..."
colorEcho ${YELLOW} "Do you want to DEL(default option)dowloaded files?(y/n)"
  read mychoice leftover
    case $mychoice in
        y|Y)
        colorEcho ${RED} "Delete confirmed!"
        rm -rf $PKG_DIR && rm -rf $PKG_TAR
        ;;
        n|N)
        colorEcho ${GREEN} "Files will be Saved."
        ;;
        *)
        colorEcho ${GREEN} "Files will be Saved as default!"
        ;;
    esac
colorEcho ${GREEN} "9.$BIN_NAME has been updated to the latest version!"
