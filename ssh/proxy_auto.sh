#!/bin/bash
#when ssh login,test status of 3 services which are caddy v2ray and naiveproxy
#if 3services is not running,start them
#Date:Mon Nov 9 19  ^z50
#add this shell to lastline in .bashrc

CADDY_STATUS1=$(systemctl status caddy |grep Active |awk '{print $3}'|cut -d "(" -f2 |cut -d ")" -f1)
if [ "CADDY_STATUS1" == "dead" ];then
    echo "Caddy service is not running,It will be started Now!"
    systemctl start {caddy,v2ray,naiveproxy};else
    CADDY_STATUS2=$(systemctl status caddy |grep " - " |awk '{print $4,$5,$6,$7}')
    echo $CADDY_STATUS2" is "$CADDY_STATUS1
fi
