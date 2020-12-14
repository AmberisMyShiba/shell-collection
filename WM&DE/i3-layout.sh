#!/bin/bash
i3-msg "workspace 2:fbro; [workspace="__focused__"] kill"
i3-msg "workspace 2:Fbro; append_layout /home/tef/.i3/workspace-2.json"
