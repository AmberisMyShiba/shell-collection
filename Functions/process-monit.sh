#!/bin/bash
LOGFILE="./Poweroff-time.txt"
if [ $# -ne 1 ]; then
    echo ">>>Please input a process name<<<";exit 1
else
    type $1 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Not found $1,Please recheck.";exit 1
    else
        while true;do
        PSCOUNT=$(pgrep $1)
        if [ ! -n "$PSCOUNT" ]; then
          echo "$1 isn't running"
	  echo "The lastest Poweroff time is" > $LOGFILE
	  echo $(date) >> $LOGFILE
          /sbin/shutdown -h +3;exit 0
        else
          echo ">>>$1 is running...<<<"
        fi
	sleep 60
        done
    fi
fi
