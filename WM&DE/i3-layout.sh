#!/bin/bash
# this script can auto load ws2 for vertical of layout
# start ws2 layout
i3-msg "workspace 2:fbro; [workspace="__focused__"] kill"
####
####
sleep 0.5
i3-msg 'workspace 2:Fbro; exec gedit; workspace 1:Comb'
sleep 0.5
i3-msg 'workspace 2:Fbro; exec urxvt; workspace 1:Comb'
sleep 0.5
i3-msg 'workspace 2:Fbro; focus parent; splitv; exec nautilus'

#start ws3 layout
sleep 0.5
i3-msg 'workspace 3:Term; [workspace="__focused__"] kill'
sleep 0.5
i3-msg 'workspace 3:Term; exec urxvt'
sleep 0.5
i3-msg 'workspace 3:Term; splitv; exec urxvt; workspace 1:Comb'
#####
#####
sleep 0.5
i3-msg 'workspace 3:Term; focus parent; splith;exec urxvt'
sleep 0.5
i3-msg 'workspace 1:Comb; splith'
