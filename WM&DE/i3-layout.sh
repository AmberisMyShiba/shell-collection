#!/bin/bash
i3-msg "workspace 2:fbro; [workspace="__focused__"] kill"
#i3-msg "workspace 2:Fbro; append_layout /home/tef/.i3/workspace-2.json"
#i3-msg "workspace 2:Fbro; exec gedit; exec urxvt; focus parent; splitv; exec nautilus"
sleep 0.5
i3-msg 'workspace 2:Fbro; exec gedit;workspace 1:Comb'
sleep 0.5
i3-msg 'workspace 2:Fbro; exec urxvt; workspace 1:Comb'
sleep 0.5
i3-msg 'workspace 2:Fbro; focus parent; splitv; exec nautilus'
