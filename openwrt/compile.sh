#!/bin/bash
echo -e "pull sources from repository"
git pull
echo -e
echo -e "update and install all feeds"
echo -e 
./scripts/feeds update -a
./scripts/feeds install -a
echo -e
echo -e "prepearing for make compile"
make clean
make defconfig

#echo -n "Do you want to menuconfig?(y/n)"
read -s -t10 -p "Do you wanna menuconfig?(y/n)" ac
if [ $ac = "y" ]; then
    make menuconfig
fi
echo -e "Downloading feeds and sources"
make download V=sc
make -j$(($(nproc)+1)) || make V=s 2>&1 | tee build.log | fgrep -i '[^_-"a-z]error[^_-.a-z]' 
