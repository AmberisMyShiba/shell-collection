#!/bin/bash

os_type=$1 # 获取第一个参数：操作系统OS
version=$2 # 获取第二个参数：version
arch=$3    # 获取第三个参数：architect
repo=sing-box
url=""

filecheck() {
        tgn=$1
        if [ -f $1 ]; then
                echo -e "\t File $1 existed! Would you delete it(y/n)!!"
                read mychoice leftover
                case $mychoice in
                y | Y)
                        echo "Debug the file $tgn will be rm"
                        echo "Delete action confirmed!"
                        rm -rf $tgn
                        ;;
                n | N)
                        echo "File will be reserved."
                        exit 1
                        ;;
                esac
        fi

}
main() {
        if [ $# -lt 1 ]; then
                echo -e "\tPlease input OS type as para1,version number as para2,arch as para3"
                echo -e "\tThe OS shoud be:linux|windows|android|darwin"
                echo -e "\tThe architech could choose:amd64|amd64v3|armv7|arm64|s390x"
                echo -e "\tExample:./get_sing-box.sh linux 1.3.0 amd64"

                exit 1
        fi
        case $1 in
        linux | l) os_type="linux" ;;
        andriod | a) os_type="android" ;;
        windows | win | w) os_type="windows" ;;
        *)
                echo "null OS type is matched,linux as default"!
                os_type="linux"
                ;;
        esac
        case $3 in
        amd64) arch="amd64.tar.gz" ;;
        amd64v3) arch="amd64v3.tar.gz" ;;
        armv7) arch="armv7.tar.gz" ;;
        s390x) arch="s390x.tar.gz" ;;
        *)
                echo "null arch is matched,amd64 will be the deault!"
                arch="amd64.tar.gz"
                ;;
        esac
        url=https://github.com/SagerNet/$repo/releases/download/v$version/$repo-$version-$os_type-$arch
        echo "Debug:$repo OS_type: $os_type, Version: v$version, Arch:$arch"
        echo "Debug:$repo target URL:$url"
        filename=$repo-$version-$os_type-$arch
        filecheck $filename
        wget "$url" -q --show-progres -O $filename || {
                echo "Error: Failed to download file,please verify input params"
                exit 1
        }
        tar -xvf $filename >/dev/null 2>&1
        rm -f $filename >/dev/null 2>&1

}

main "$@"
