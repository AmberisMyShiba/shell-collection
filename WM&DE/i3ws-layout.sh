#!/bin/bash

# append this script to i3 config file
# exec_always --no-startup-id ~/i3ws-layout.sh
# autostart this script in i3 startup,Can auto layout ws2 and ws3 that I used to
i3-msg "workspace 2:Fedt; [workspace="__focused__"] kill"
sleep 0.5
i3-msg "workspace 2:Fedt; exec gedit; workspace 1:Comb"
sleep 0.5
i3-msg "workspace 2:Fedt; splitv; exec nautilus; workspace 1:Comb"
sleep 0.5
i3-msg "workspace 3:Term; [workspace="__focused__"] kill"
i3-msg "workspace 3:Term; exec urxvt; splith; exec urxvt"
sleep 0.5
i3-msg "workspace 1:Comb"


