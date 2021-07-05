#!/bin/bash
CHECKTIME=0
LOGFILE="./Poweroff-time.txt"
if [ $# -ne 1 ]; then
    echo "Please input a process name,like emerge or make etc.";exit 1
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
	  echo $(LANG=en_US.UTF-8 date) >> $LOGFILE
          echo "It's countdonwing 3 min to shutdown"
	  /sbin/shutdown -h +3;exit 0
        else
        #CHECKTIME=$((CHECKTIME+1))
        ((CHECKTIME++))
	  if [ $CHECKTIME -ge 2 ]; then
	    echo ">>>$1 has been running...for $CHECKTIME minutes.<<<"
	  else
	    echo ">>>$1 is running detected.<<<"
	  fi
        fi
	sleep 60
        done
    fi
fi
