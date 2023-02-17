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

NAIVE_LOCAL_PATH="/usr/bin"
PKG_URL=$(curl -s "https://api.github.com/repos/klzgrad/naiveproxy/releases/latest" |grep openwrt-x86_64 | grep browser_download_url | cut -d : -f 2,3 | tr -d \")
PKG_LATEST=$(curl -s "https://api.github.com/repos/klzgrad/naiveproxy/releases/latest" |grep openwrt-x86_64 | grep browser_download_url | cut -d / -f 9 |tr -d \")
PKG_DIR=$(echo $PKG_LATEST|sed s/\.tar.\xz//g)
PKG_TAR=$(echo $PKG_LATEST|sed s/\.xz\//g)
echo -e "1.The latest naive bin-release version for openwrt-x86_64 is:"
colorEcho ${YELLOW} "	$PKG_LATEST"
if [ -f "$PKG_LATEST" ];then
  colorEcho ${RED} "2.The latest naive Release file is founded in current directory."
  colorEcho ${GREEN} "	Please run [tar -xf $PKG_LATEST] unzip files,and Replace naive manually!"
  exit 1
fi
echo -e "3.Downloading the latest version."
#curl -s "https://api.github.com/repos/klzgrad/naiveproxy/releases/latest" |grep openwrt-x86_64 | grep browser_download_url | cut -d : -f 2,3 | tr -d \"|wget -qi -
wget $PKG_URL -q --show-progress
echo -e "4.unzip and replace naive bin file"
if [ ! -f "$PKG_LATEST" ]; then
  colorEcho ${YELLOW} "Not found the naive release,Please Check Downloading file correct!"
  exit 1
fi
#echo -e $PKG_LATEST
#echo -e $PKG_DIR
#colorEcho ${YELLOW} "file and dir is showed above!"

xz -d $PKG_LATEST
tar -xvf `echo $PKG_LATEST|cut -d . -f 1-5`
#tar -xvf `echo $PKG_LATEST|sed s/\.xz\//g`
colorEcho ${YELLOW} "5.Please asure naive has been stopped!"
#echo -e "Or you should run:#ps -w|grep naive and kill -9 PID"
#kill -9 `pgrep naive` >/dev/null 2>&1

## terminate naive thread start
NAIVE_PID=$(ps -ef|grep naive|grep -v grep|grep -v $0|awk '{print $2}')
echo 'NAIVE_PID='$NAIVE_PID
echo '$The running shell script's name is='$0
if [[ ! -n $NAIVE_PID ]]; then 
        echo 'thread is not exist'
 else
        echo 'thread PID='$NAIVE_PID
        kill -9 $NAIVE_PID
fi
## terminate naive thread end

sleep 2
#echo -e $PKG_DIR 
#echo -e $PKG_TAR
#echo -e "the files above will be deleted!"
colorEcho ${GREEN} "6.Copy latest naive bin files to $NAIVE_PATH"
cp -f $PKG_DIR/naive $NAIVE_LOCAL_PATH/
echo -e "7.Tring restaring naiveproxy.service.May be you should restart it by manual"
default="n"  
read -e -p "Do you want to DEL dowloaded files?" mychoice
mychoice="${ac:-${default}}" 
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
colorEcho ${GREEN} "9.naive has been updated to the latest version!"
