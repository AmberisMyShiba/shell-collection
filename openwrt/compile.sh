#!/bin/bash

git pull
./scripts/feeds clean
./scripts/feeds update -a && ./scripts/feeds install -a
#make menuconfig # set target 
#scripts/diffconfig.sh > mydiffconfig #(save your changes in the text file mydiffconfig).
make clean 
cp x86_64_diff.config .config
make defconfig #to set default config for build system and device
make -j$(($(nproc)+1)) || make V=s 2>&1 | tee build.log | grep -i '[^_-"a-z]error[^_-.a-z]' 

