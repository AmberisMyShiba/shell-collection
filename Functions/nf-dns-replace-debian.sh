#!/bin/bash

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
read -p "Please input the New DNS,it will replace the current one:  " DNS_NEW
check_ip $DNS_NEW
echo
echo -e "\033[32m\033[01m The Current unlock DNS is: \033[0m" $DNS_NOW
echo
echo -e "\033[33m\033[01m The New unlock DNS will be replaced with: \033[0m" $DNS_NEW
sed  -i "s/$DNS_NOW/$DNS_NEW/g" $UNLOCK_FILE
sleep 1
echo -e "\033[36m\033[01m Dnsmasq service will be restarted.\033[0m"
systemctl restart dnsmasq
}

main "$@"
