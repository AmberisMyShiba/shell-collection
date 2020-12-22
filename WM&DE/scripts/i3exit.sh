#!/bin/bash

cmd=$(echo -e "lockscreen\nlogout\nreboot\npoweroff" | rofi -width 300 -dmenu -p system:)
case $cmd in
lockscreen)
i3lock -p default -i /home/rohk/Pictures/LasCatedralesBeach_ZH-CN5680206879_1920x1080.jpg & ;;
logout)
i3-msg exit ;;
reboot)
systemctl reboot ;;
poweroff)
systemctl poweroff ;;
esac

--------------------------
chmod +x i3exit.sh #make script executive
cp i3exit.sh ~/.scripts/
modify polybar config file add following
---------------------------
[module/poweroff]
type = custom/script
exec = echo "  "
;click-left = rofi -modi run,drun,window -show drun
click-left = /home/rohk/.scripts/i3exit.sh
click-right = i3lock -p default -i /home/rohk/Pictures/LasCatedralesBeach_ZH-CN5680206879_1920x1080.jpg &
click-middle = sudo poweroff
format-padding = 1
---------------------------------
