#!/usr/bin/env bash

while [ "$select" != "NO" -a "$select" != "YES" ]; do
    select=$(echo -e '          NO              \n            YES             ' | dmenu -nb '#151515' -nf '#999999' -sb '#f00060' -sf '#000000' -fn '-*-*-medium-r-normal-*-*-*-*-*-*-100-*-*' -i -p "Exit display-manager?" | xargs)
    [ -z "$select" ] && exit 0
done
[ "$select" = "NO" ] && exit 0
i3-msg exit



-----------------------------------------


Here is a simple rofi logout script that I’m using on my i3 setup.

Put it in place and bind it to a shortcut.
For i3 e.g.: "bindsym $mod+Shift+e exec ~/.bin/rofi-logout"

#!/bin/bash

cmd=$(echo -e "suspend\nlogout\nreboot\npoweroff" | rofi -width 350 -dmenu -p system:)
case $cmd in
suspend)
systemctl suspend ;;
logout)
i3-msg exit ;;
reboot)
systemctl reboot ;;
poweroff)
systemctl poweroff ;;
esac
