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
default="y"
read -e -p "Do you wanna menuconfig?(y/n)" ac
ac="${ac:-${default}}"
#echo $ac
    case $ac in
    	y|Y)
		make menuconfig;;
		*)
#		exit 0
	esac
echo -e "Downloading feeds and sources"
default="Y"
read -e -p "Compile firmware right now?(y/n)" ac
ac="${ac:-${default}}"
#echo $ac
    case $ac in
       	y|Y)
       	make download V=sc
		make -j$(($(nproc)+1)) || make V=s 2>&1 | tee build.log | fgrep -i '[^_-"a-z]error[^_-.a-z]' ;;
       	*)
       	exit 0
    esac
