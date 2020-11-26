#!/bin/bash
#test status of 3 services which are caddy v2ray and naiveproxy
#if 3services is not running,start them
#Date:Mon Nov 9 19：50

CADDY_STATUS=$(systemctl status caddy |grep Active |awk '{print $3}'|cut -d "(" -f2 |cut -d ")" -f1)
if [ "CADDY_STATUS" == "dead" ];then
	echo "Caddy service is not running,It will be started Now!"
	systemctl start {caddy,v2ray,naiveproxy};else
	echo $CADDY_STATUS
fi
