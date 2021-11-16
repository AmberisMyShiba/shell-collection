#!/bin/bash

#######color code########
RED="31m"      # Error message
YELLOW="33m"   # Warning message
GREEN="32m"
colorEcho(){
    echo -e "\033[${1}${@:2}\033[0m" 1>& 2
}

ENDFLAG=TRUE
CHECKTIME=600 #10 minutes as default
LOGFILE="/var/log/unlockdns-update.log"
DNS_INIT=$(nslookup tw1.dnsunlock.com|grep "Address: "|cut -d : -f 2)

main () {
# Make sure only root can run our script
        [ `whoami` != "root" ] && colorEcho ${RED} "This script must be run as root."  && exit 1
        if [[ "$1" =~ ^[0-9]+$ ]]; then
                echo Beging-monitor
        elif [[ "$1" = "--help" ]];then
                echo helpmsg
        else
                echo errormsg
                exit 1
        fi
}
        #while [[ $ENDFLAG = TRUE ]]
        #do
main "$@"
