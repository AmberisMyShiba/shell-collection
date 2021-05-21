#!/bin/bash

if [[ $# -eq q ]]; then
# poweroff in 2 minitues
    ps -eo pid | grep $1 &> /dev/null || /sbin/shutdown -h +2
fi
