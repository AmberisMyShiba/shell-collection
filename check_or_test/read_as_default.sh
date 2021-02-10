#! /bin/bash
#echo -n "Do you want to menuconfig?(y/n)"

read -s -t3 -p "Do you wanna menuconfig?(y/n)" ac
ac=${ac:-"y"}
if [ $ac = "y" ]; then
    cd /usr/src/linux
    make menuconfig
else
    echo -e
    echo -n "you choose (n),exited process."
    exit 0
fi
