#!/bin/bash
CHECKTIME=0
ENDFLAG=TRUE
PSCOUNT=0
PSNAME=""
LOGFILE='./poweroff-lastest-time.log'

main () {
while [[ $ENDFLAG = TRUE ]]
do
    if [ $# -lt 1 ]; then
        echo -e "\tPlease input one or more processes name."
        echo -e "\tExample:$0 emerge make"
        exit 1
    fi

    PSCOUNT=0
    PSNAME=""
    for para in "$@"
    do
        paracheck $para
        PSCOUNT=$[$PSCOUNT+$(pgrep -c $para)]
        if [ $(pgrep -c $para) -ne 0 ]; then
            PSNAME=$PSNAME" "$para
        else
            para=""
            PSNAME=$PSNAME$para    
        fi
        echo $PSCOUNT
        echo $PSNAMEM
    done
    if [ $PSCOUNT = 0 ]; then
        ENDFLAG=FALSE
    else
        ((CHECKTIME++))
       	if [ $CHECKTIME -ge 2 ]; then
       		echo ">>>$PSNAME has been running...for $((CHECKTIME-1)) minutes.<<<"
       	else
       		echo ">>>$PSNAME is running detected.<<<"
       	fi
        sleep 60
    fi
done
loginfo
}

paracheck() {
    type $1 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        printf '"%s"\t is not found,Please confirm its exists.\n' "$para"
        exit 1
    fi
}


loginfo() {
    echo "Monitoring Process not running"
    echo "The lastest Poweroff time is" > $LOGFILE
    echo $(LANG=en_US.UTF-8 date) >> $LOGFILE
	echo "It's countdonwing 3 min to shutdown"
    /sbin/shutdown -h +3
    exit 0
}

main "$@"
