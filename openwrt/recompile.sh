#!/bin/bash
echo -e "\033[42;37m pull sources from repository \033[0m"
# \033[42;37m 绿底白字#31m 红字#32m 绿字#33m 黄字#34m 蓝字#35m 紫字#36m 青字#37m 白字#41m 红底色
#闪烁[40;5m \033[1m粗体'
if [ ! -d "lede/" ];then
        git clone https://github.com/coolsnowwolf/lede
        grep -v ^# feeds.conf.default|tr -s "\n" > lede/feeds.conf.default
        cd lede
else
  cd lede
        echo -e "\033[40;5m Cleaning Compile cache \033[0m"
#rm -rf ./feeds
#make distclean
        sleep 2
        git pull
fi
echo -e
echo -e "\033[1m update and install all feeds \033[0m"
echo -e 
./scripts/feeds update -a
./scripts/feeds install -a
echo -e
echo -e "\033[1m prepearing for make compile \033[0m"
make clean
make defconfig

#echo -n "Do you want to configure by menuconfig?(y/n)"
#if yes:        make menuconfig 
#if no:         cp diffconfig to .config and make defconfig
default="y"
read -e -p "Do you wanna configure by menuconfig?(y/n)" ac
ac="${ac:-${default}}"
#echo $ac
    case $ac in
      y|Y)
    make menuconfig;;
      n|N)
    if [ ! -f "diff.config" ];then
       echo -e "\033[1m The file which name is\033[5m \033[42;31mdiff.config\033[0m \033[1mis not found! \033[0m"
       echo -e "\033[36m Please make menuconfig at least once and run:[$ \033[32m scripts/diff.config > diff.config] to creat it.\033[0m"
      exit 1
    else
      echo 'cp diff.config >.config'
      echo 'make defconfig'
    fi
    ;;
      *)
#   exit 0
    esac
echo -e "Downloading feeds and sources"
default="Y"
read -e -p "Compile firmware right now?(y/n)" ac
ac="${ac:-${default}}"
#echo $ac
    case $ac in
        y|Y)
                time make download V=sc
                                        time make -j$(($(nproc)+1)) || make -j1 V=sc 2>&1 | tee build.log | fgrep -i '[^_-"a-z]error[^_-.a-z]'
                                        ;;
        *)
                exit 0
    esac
