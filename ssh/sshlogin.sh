#!/bin/bash

#######color code########
RED="31m"      # Error message
YELLOW="33m"   # Warning message
GREEN="32m"
BLUE="34m"
WHITE="97m"
BLINK="\e[5m"

KEYPATH="/home/tef/Vultr/id_rsa "
VPSID1="root@173.242.112.62"
VPSID2="ubuntu@132.226.224.151"
TARGETID=""
VPSPORT=8301

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
  colorEcho ${WHITE}"Useage: ./sshlogin.sh [1|2].   and 1 as bandwagon,2 as orcale"
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
	*)
	colorEcho ${YELLOW}${BLINK}"Please input vps name or number for loggin"
	exit 9
	;;
esac
sshloginto


