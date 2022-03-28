#!/bin/bash
intertube=0
while [ $intertube -ne 1 ]; do
  #ping -c1 www.baidu.com &> /dev/null
  wget -T 3 -p www.google.com -o /dev/null
  if [ $? -eq 0 ]
  then
    sudo layman -S
    sudo emerge --sync
    sudo emerge -1uv portage
    sudo emerge -uDNv --with-bdeps=y --keep-going @world
    sudo emerge -c
    intertube=1
  else 
    echo "Waiting for Network connetcion to GWF Outside"  && sleep 2
  fi
done
echo "System is updated!"
