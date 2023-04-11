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
BIN_FILE="shadow-tls"
REPO_NAME="ihciah/shadow-tls"
ARCH_KEYWORD="x86_64-unknown-linux"
PKG_URL=$(curl -s "https://api.github.com/repos/$REPO_NAME/releases/latest" |grep $ARCH_KEYWORD | grep browser_download_url | cut -d : -f 2,3 | tr -d \")
VER_LATEST=$(curl -s "https://api.github.com/repos/$REPO_NAME/releases/latest" | grep tag_name | cut -d ":" -f 2- | tr -d \" | tr -d \, | tr -d '[:space:]')
PKG_LATEST=$BIN_FILE-$VER_LATEST
#PKG_DIR=$(echo $PKG_LATEST | sed 's/\.tar.\xz//g')
echo -e "1.The latest $BIN_FILE release Version is:"
colorEcho ${YELLOW} "   $PKG_LATEST"
if [ -f "$PKG_LATEST" ];then
  colorEcho ${RED} "2.The latest $BIN_FILE Release is founded in current directory."
  colorEcho ${GREEN} "Please Replace it manually!"
  exit 1
fi
echo -e "3.Downloading the latest version."
wget -q --show-progress $PKG_URL -O $PKG_LATEST
echo -e "4.replace $BIN_FILE to latest version"
if [ ! -f "$PKG_LATEST" ]; then
  colorEcho ${YELLOW} "Not found $BIN_FILE latest version release,Please Check Downloading file correct!"
  exit 1
fi
#tar -xf $PKG_LATEST
chmod +x $PKG_LATEST
echo -e "5.stoping $BIN_FILE.service in SystemD."
#systemctl stop {$BIN_FILE.service} >/dev/null 2>&1 || sudo kill $(pidof $BIN_FILE ) >/dev/null 2>&1
#sudo ss-tproxy stop
#sleep 2
## terminate naive thread start
BIN_FILE_PID=$(ps -ef|grep $BIN_FILE|grep -v grep|grep -v $0|awk '{print $2}')
#echo $BIN_FILE_PID=$BIN_FILE_PID
#echo '$0='$0
if [[ ! -n $BIN_FILE_PID ]]; then 
        echo $BIN_FILE thread is not exist
 else
        echo thread PID=$BIN_FILE_PID
        kill -9 $BIN_FILE_PID
fi
## terminate $BIN_FILE thread end
echo -e "6.Copy latest $BIN_FILE bin files to $INSTALL_PATH"
cp ./$PKG_LATEST $BIN_LOCAL_PATH/$BIN_FILE
setcap cap_net_bind_service,cap_net_admin+ep $BIN_LOCAL_PATH/$BIN_FILE
echo -e "7.restaring $BIN_FILE.service."
#systemctl start $BIN_FILE 2>/dev/null
#sudo ss-tproxy start
colorEcho ${GREEN} "8.Cleaning Downloaded files..."
colorEcho ${YELLOW} "Do you want to DEL(default option)dowloaded files?(y/n)"
  read mychoice leftover
    case $mychoice in
        y|Y)
        colorEcho ${RED} "Delete confirmed!"
        rm -rf $PKG_LATEST;;
        n|N)
        colorEcho ${GREEN} "Files will be Saved.";;
        *)
        colorEcho ${GREEN} "Files will be Saved as default!";;
    esac
colorEcho ${GREEN} "9.$BIN_FILE has been updated to the latest version!"
