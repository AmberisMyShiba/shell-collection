#!/bin/bash

#######color code########
RED="31m"      # Error message
YELLOW="33m"   # Warning message
GREEN="32m"
BLUE="34m"
WHITE="97m"
BLINK="\e[5m"

KEYPATH="~/path/to/key_rsa "
VPSID1="root@0.1.2.3"
VPSID2="ubuntu@1.2.3.4"
VPSID3="root@1.2.3.4"
ROUTER="root@192.168.1.1"
TARGETID=""
VPSPORT=1234

colorEcho(){
    echo -e "\033[${1}${@:2}\033[0m" 1>& 2
#useage:colorEcho ${RED} "something"
}

sshloginto(){
 colorEcho ${YELLOW}"It's Logging to $TARGETID:$VPSPORT"
ssh -i $KEYPATH $TARGETID -p $VPSPORT
}


# Make sure only root can run our script
#[ `whoami` != "root" ] && colorEcho ${RED} "This script must be run as root."  && exit 1




if [ $# -ne 1 ]; then
  colorEcho ${WHITE}"Useage: ./sshlogin.sh [1|2]. 1 as bandwagon,2 as orcale"
  exit 9
fi
case $(echo $1|tr '[:upper:]' '[:lower:]') in
#case $1 in
        1|B|b|bandwagon)
        TARGETID=$VPSID1
        ;;
        2|O|o|oracle)
        TARGETID=$VPSID2
        ;;
        3|C|c|cpa)
        TARGETID=$VPSID3
        ;;
        *)
        colorEcho ${YELLOW}${BLINK}"Please input vps name or number for loggin"
        exit 9
        ;;
esac
sshloginto
