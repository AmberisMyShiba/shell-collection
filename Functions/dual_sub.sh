#!/bin/bash
#此脚本用于合并字幕文件产生双语字幕，以便在不支持多字幕的播放器上使用
WARNING="Sleep 2 secs for debug"
ENG_SRT="2_English.srt"
CHS_SRT="6_Chinese.srt"
DUAL_SRT="1_eng_chs.srt"

for subdirs in ./*
  do
    if test -d $subdirs
      then
	echo -e "\033[32m[Combing English-subs within Chinese-subs in $subdirs]\033[0m"
        diff $subdirs/$ENG_SRT $subdirs/$CHS_SRT -D DiffMark |grep -v '^#' > $subdirs/$DUAL_SRT
        echo -e "\033[31m[New Subs-file name is  $subdirs/$DUAL_SRT]\033[0m"
        echo -e "\033[33m\033[01m\033[05m[$WARNING ]\033[0m"
        sleep 2
    fi
  done
