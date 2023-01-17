#!/bin/bash

## check getcap before ss-tproxy running
## add this script to ss-tproxy.conf as section of 
## pre_start () {
##                      sudo bash setcap_proxy.sh       }

#######color code########
RED="31m"      # Error message
YELLOW="33m"   # Warning message
GREEN="32m"

colorEcho(){
    echo -e "\033[${1}${@:2}\033[0m" 1>& 2
}

# Make sure only root can run our script
#[ `whoami` != "root" ] && colorEcho ${RED} "This script must be run as root."  && exit 1


#clear up the proxy log file
PROXY_LOG_FILE=$(grep startcmd /etc/ss-tproxy/ss-tproxy.conf|cut -d '>' -f 2 | cut -d ' ' -f 1)
if [ -f "$PROXY_LOG_FILE" ]; then
        colorEcho ${GREEN} "Clear up the proxy running log"
        #rm -rf $PROXY_LOG_FILE
        su proxy -c"(cat /dev/null > $PROXY_LOG_FILE)"
fi
#check and set the correct caps of proxy before start
PROXY_PROCESS_NAME=$(grep startcmd /etc/ss-tproxy/ss-tproxy.conf|cut -d '(' -f 2|cut -d ' ' -f 1)
CAP_ATTR=$(getcap $PROXY_PROCESS_NAME|cut -d' ' -f 2)
BE_CAPPED='cap_net_bind_service,cap_net_admin=ep'
colorEcho ${GREEN} "Proxy process name is:$PROXY_PROCESS_NAME"
colorEcho ${YELLOW} "Proxy process cap is:$CAP_ATTR"
if [ "$CAP_ATTR" != "$BE_CAPPED" ]; then
    colorEcho ${RED} "Proxy process cap is incorrect !!,its caps just have been set!"
        setcap cap_net_bind_service,cap_net_admin+ep $PROXY_PROCESS_NAME
else
        colorEcho ${GREEN} "Proxy process cap is correct!"
fi
