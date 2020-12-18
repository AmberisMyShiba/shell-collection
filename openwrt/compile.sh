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
read -p "Do you wanna menuconfig?(y/n)" ac
    case $ac in
    	y|Y)
		make menuconfig;;
		*)
		exit 0
	esac
echo -e "Downloading feeds and sources"
#echo -n "Do you want to Compile now?(y/n)"
read -p "Do you want to Compile now?(y/n)" ac
    case $ac in
       	y|Y)
       	make download V=sc;;
       	*)
       	exit 0
    esac
