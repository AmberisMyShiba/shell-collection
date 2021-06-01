#!/bin/bash

if [ $# -ne 1 ]; then
    echo ">>>Please input a process name<<<";exit 1
else
    type $1 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Not found $1,Please recheck.";exit 1
    else
	while true;do
	PSCOUNT=$(ps -ef|grep $1|grep -v grep)
	if [ "PSCOUNT" != "0" ]; then
	  echo ">>>$1 is running...<<<"
	else 
	  echo "$1 isn't running"
	  /sbin/shutdown -h +3;exit 0
	fi
	sleep 5
	done
    fi
fi
