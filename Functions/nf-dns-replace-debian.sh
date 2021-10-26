UNLOCK_FILE="/etc/dnsmasq.d/unlock.conf"
DNS_NOW=$(grep "address=" $UNLOCK_FILE|awk -v FS="/" '{if(NR==2) print $3}')

check_ip()
{
  IP=$1
  VALID_CHECK=$(echo $IP|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
  if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$">/dev/null; then
     if [ "${VALID_CHECK:-no}" = "yes" ]; then
        echo -e "\033[32m The New DNS IP $DNS_NEW is available.\033[0m"
     else
        echo -e "\033[33m\033[01m IP: $DNS_NEW isn't available! \033[0m"
	exit 1
     fi
   else
        echo -e "\033[31m\033[01m Your input isn't an IP format! \033[0m"
	exit 1
   fi
}


main() {
		echo
		echo -e "\033[32m\033[01m The Current unlock DNS is: \033[0m" $DNS_NOW
	if [ $# -eq 0 ] ;then
		read -p "Please input the New DNS,it will replace the current one:  " DNS_NEW
		check_ip $DNS_NEW
		echo
		echo -e "\033[33m\033[01m The New unlock DNS will be replaced with: \033[0m" $DNS_NEW
		sed  -i "s/$DNS_NOW/$DNS_NEW/g" $UNLOCK_FILE
	elif [ $# -eq 1 ];then
		DNS_NEW=$1
		check_ip $DNS_NEW
		echo -e "\033[33m\033[01m The New unlock DNS will be replaced with: \033[0m" $DNS_NEW
		echo
		sed -i 	"s/$DNS_NOW/$DNS_NEW/g" $UNLOCK_FILE
	else
		echo -e "\033[32m\033[01m Useage:$0 [DNS IP Address] \033[0m"
		exit 1
	fi
	
	echo -e "\033[36m\033[01m Dnsmasq service will be restarted.\033[0m"
	systemctl restart dnsmasq
	sleep 1
	systemctl status dnsmasq >null
	
	if [ $? -eq 0 ];then
		echo -e "\033[32m\033[01m Dnsmasq service restarted sucess.\033[0m"
	else
		echo -e "\033[33m\033[01m Dnsmasq service restarting encounted an error.\033[0m"
	fi
}

main "$@"
