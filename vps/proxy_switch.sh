#!/bin/bash
# switch proxy to naive(caddy) or xray(nginx)

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

help_msg() {
cat << 'EOF'
Useage:proxy_switch.sh <proxy>
The options of <proxy> are :(<caddy> or <nginx>)
This VPS has been installed proxy applicaions are:[naive] [v2ray] and [xray]
This VPS has been installed web service are caddy and nginx

If proxy switch to naive,it will enable Caddy service and start naive and v2ray(include shadowsocks) and at the same time nginx will be shutdowned and 
disabled.

If proxy switch to xray reversely,it will disable Caddy/{navie,v2ray},meanwhile also nginx/xray will be actived.

help yourself and enjoy it!
EOF
}

go_caddy() {
echo "$fond_bold $(color_red "Systemctl Disable nginx now and Stopping Xray.")" && exit 1
systemctl disable --now {nginx,xray}
echo "$fond_bold $(color_yellow "Systemctl Enable Caddy now and Starting naive/v2ray.")" && exit 1
sleep 3
systemctl enable --now {caddy,v2ray,naiveproxy}
}

go_nginx() {
echo "$fond_bold $(color_red "Systemctl Disable Caddy now and Stopping V2ray/navie.")" && exit 1
systemctl disable --now {caddy,v2ray,naiveproxy}
echo "$fond_bold $(color_yellow "Systemctl Enable Nginx now and Starting Xray.")" && exit 1
sleep 3
systemctl enable --now {nginx,xray}
}

main() {
# Make sure only root can run our script
[ `whoami` != "root" ] && echo "$fond_bold $(color_yellow "This script must be run as root.")" && exit 1
if [ $# -eq 0 ]; then help_msg; exit 1;fi
case $1 in
    caddy|naive|v2ray)  go_caddy;;
    nginx|xray)         go_nginx;;
    *)                  help_msg;;
esac
return 0
}

main "$@"
