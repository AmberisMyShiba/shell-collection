#!/bin/bash

PORT=8301
if [[ -z $1 ]]; then
    echo "error:please input Port num as the formate: ./`basename $0` $PORT"
    exit
else
    case "$1" in
        [1-9][0-9]*)
        if [ $1 -gt 65535 && $1 -lt 1 ]; then
            echo "The Port number have to in a range from 1-65535"
            exit 1
        fi
        PORT=$1
        ;;
        *)
        echo "$1 is not a number"
        ;;
    esac
fi
mkdir -p ~/.ssh
cat > ~/.ssh/authorized_keys << EOF
ssh-rsa *** imported-openssh-key #paste rsa key here
EOF

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
#sed -i '/#PubkeyAuthentication yes/PubkeyAuthentication yes/g'
#sed -i 's/^#\(Port\)/\1' /etc/ssh/sshd_config
sed -i "s/#Port 22/Port $PORT/" /etc/ssh/sshd_config
#use "" to pass a varibale $PORT
sed -i 's/^#\(PubkeyAuthentication\)/\1/' /etc/ssh/sshd_config
sed -i 's/^#\(AuthorizedKeysFile\)/\1/' /etc/ssh/sshd_config
sed -i '/AuthorizedKeysFile/a\RSAAuthentication yes' /etc/ssh/sshd_config
default="n"
read -e -p "Please confirm to restart SSH service!(y/n)" ac
ac="${ac:-${default}}"
case $ac in
    y|Y)
    systemctl restart sshd
    ;;
    n|N)
    echo "Please restart SSH daemon service manually!"
    exit 0
    ;;
    *)
    exit 1
    ;;
esac
