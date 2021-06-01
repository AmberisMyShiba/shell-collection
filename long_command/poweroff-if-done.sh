#!/bin/bash

if [[ $# -eq 1 ]]; then
# poweroff in 1 minitues
    type $1 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "$1 is not exist!"
        exit 1
    fi
    ps -eo pid | pgrep $1 &> /dev/null || /sbin/shutdown -h +3
else
    echo -e "Useage:bash poweroff-if-done.sh [emerge]"
    exit 1
fi

----------------------------------------------------------------
$ su -c 'while [[ -d /proc/7338 ]]; do sleep 10; done; poweroff'
replace 7338 as task pid
----------------------------------------------------------------


ctrl+z pause the process,and then type
root # bg && wait && poweroff
or
fg; poweroff
or
fg && poweroff
1.bg resumes executing of emerge in the background. 
2.wait waits for last command sent to background to terminate. 
3.When emerge finishes with success, poweroff command will be executed. 
