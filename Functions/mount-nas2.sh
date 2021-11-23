#!/bin/bash
trap "exit 1" HUP INT QUIT TERM PIPE

font_bold() {
    printf "\e[1m$*\e[0m"
}
color_red() {
    printf "\e[35m$*\e[0m"
}
color_green() {
    printf "\e[32m$*\e[0m"
}
color_yellow() {
    printf "\e[31m$*\e[0m"
}

helpmsg () {
cat << 'EOF'
Useage:mount-nas  [COMMAND]
COMMAND :={
    m|mount    mount nas samba share folders
    u|umount   umount nas samba share folders
    h|help     show help message
           }
Specify the COMMADN default as blank, it will auto detect and exec mount/umount
EOF
}

mk_mount_dir () {
#check if mount point exist,otherwise create dir
DIR_VIDEO="/mnt/networkshare/nas-video"
DIR_XUNLEI="/mnt/networkshare/nas-xunlei"
DIR_NETBACKUP="/mnt/networkshare/nas-netbackup"
if [ ! -d $DIR_VIDEO ]; then
  	echo "MountPoint not exist!now mkdir to " "$(color_green "$DIR_VIDEO")"
	mkdir -p $DIR_VIDEO
fi

if [ ! -d $DIR_XUNLEI ]; then
  echo "MountPoint not exist!now mkdir to " "$(color_green "$DIR_XUNLEI")"
  mkdir -p $DIR_XUNLEI
fi

if [ ! -d $DIR_NETBACKUP ]; then
  echo "MountPoint not exist!now mkdir to " "$(color_green "$DIR_NETBACKUP")"
  mkdir -p $DIR_NETBACKUP
fi

}

mountnas() {
#echo 5858 | sudo -S mount -t cifs -o vers=2.0,user=id,password=passwd,defaults //192.168.5.168/video /mnt/networkshare/nas-video
#sleep 1
#echo 5858 | sudo -S mount -t cifs -o vers=2.0,user=id,password=passwd,defaults //192.168.5.168/ttdownload /mnt/networkshare/nas-xunlei
#echo 5858 | sudo -S mount -t cifs -o vers=2.0,user=id,password=passwd,defaults //192.168.5.168/netbackup /mnt/networkshare/nas-netbackup

mk_mount_dir

if mount | grep /mnt/networkshare/nas > /dev/null; then
    echo "$(font_bold "It seems like NAS sharing already mounted!")"
else
    mount -t cifs -o vers=2.0,user=tef,password=passwd,defaults //192.168.5.168/video /mnt/networkshare/nas-video
mount -t cifs -o vers=2.0,user=id,password=passwd,defaults //192.168.5.168/ttdownload /mnt/networkshare/nas-xunlei
mount -t cifs -o vers=2.0,user=id,password=passwd,defaults //192.168.5.168/netbackup /mnt/networkshare/nas-netbackup
    echo "$(color_green "NAS Sharing folders is Mounted")"
fi
}

umountnas() {
#echo 5858 | sudo -S umount /mnt/networksahre/{nas-video,nas-xunlei,nas-netbackup}

#umount /mnt/networkshare/{nas-video,nas-xunlei,nas-netbackup}
#check if mount point has been mounted
if mount | grep /mnt/networkshare/nas > /dev/null; then
    umount /mnt/networkshare/nas-*
    echo "$(color_green "Umount NAS share Complete")"
else
    echo "$(color_yellow "Not found any mounted Sharing folders")"
fi
}

vershow () {
echo  "$(font_bold $(color_green 'This script is for quick access Nas samba sharing folders')) $*"
}

main () {

# Make sure only root can run our script
[ `whoami` != "root" ] && echo "$fond_bold $(color_yellow "This script must be run as root.")"  && exit 1

case $1 in
    m|mount)		mountnas;;
    u|umount)		umountnas;;
    v|version)		vershow;;
    h|help)		helpmsg;;
     *)			echo "$(color_yellow "Unknown option: $arg")"; vershow;helpmsg; return 1;;
esac
return 0
}

main "$@"
