#!/bin/bash

if [[ $# -eq q ]]; then
# poweroff in 2 minitues
    ps -eo pid | grep $1 &> /dev/null || /sbin/shutdown -h +2
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
