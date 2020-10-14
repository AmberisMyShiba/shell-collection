#!/bin/bash

OS_NAME=$(awk -F= '/^NAME/{print $2}' /etc/os-release|tr -d \")
if [ $OS_NAME = "OpenWrt" ];then
  echo "OS is OpenWrt"
  exit 0
else
  echo "OS is not OpenWrt,OS name is:$OS_NAME"
  exit 1  
fi
