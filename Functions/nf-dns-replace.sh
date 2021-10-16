#!/bin/bash

UNLOCK_FILE="/etc/dnsmasq.d/unlock.conf"
DNS_NOW=$(grep "address=" $UNLOCK_FILE|awk -v FS="/" '{if(NR==2) print $3}')
main () {
read -e -p "Please input the New DNS,it will replace the current one:  " DNS_NEW
check_ip $DNS_NEW
echo -e
echo -e "\033[32m\033[01mThe Current unlock DNS is: \033[0m" $DNS_NOW
echo -e
echo -e "\033[33m\033[01mThe New unlock DNS will be replaced with: \033[0m" $DNS_NEW
sed -i "s/$DNS_NOW/$DNS_NEW/g" $UNLOCK_FILE

}

function check_ip()
{
  IP=$1
  if [[ $IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    FIELD1=$(echo $IP|cut -d. -f1)
    FIELD2=$(echo $IP|cut -d. -f2)
    FIELD3=$(echo $IP|cut -d. -f3)
    FIELD4=$(echo $IP|cut -d. -f4)
    if [ $FIELD1 -le 255 -a $FIELD2 -le 255 -a $FIELD3 -le 255 -a $FIELD4 -le 255 ]; then
      echo -e "\033[32m The New DNS IP $DNS_NEW is available.\033[0m"
    else
      echo -e "\033[33m\033[01m IP: $DNS_NEW isn't available! \033[0m"
    fi
  else
    echo -e  "\033[31m\033[01m Your input isn't an IP format!\033[0m"
    exit 1
  fi
}

main "$@"
