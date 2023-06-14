#!/bin/bash

type=$1 # 获取第一个参数：type
version=$2 # 获取第二个参数：version
arch=$3  
url=""
main () {
        if [ $# -lt 1 ]; then
                echo -e "\tPlease input tuic's process type"
                echo -e "\tThe type shoud be:server or client"
                exit 1
        fi
        case $3 in
                x86_64)         arch="x86_64-unknown-linux-gnu";;
                openwrt)        arch="x86_64-unknown-linux-musl";;
                win)            arch="x86_64-pc-windows-gnu.exe";;
                *)              echo "null arch input,x86_64 will be the deault!";arch="x86_64-unknown-linux-gnu";;
        esac
        url=https://github.com/EAimTY/tuic/releases/download/tuic-$type-$version/tuic-$type-$version-$arch
    if [ "$type" == "server" ] || [ "$type" == "client" ]; then
         echo "Debug:TUIC type: $type, Version: $version, Arch:$arch"
         echo "Debug:TUIC target URL:$url"
         wget "$url" -q --show-progres|| {
            echo "Error: Failed to download file,please verify input params"
            exit 1
        }
    else
        echo "Unknown type: $type"
        exit 1
    fi

}

main "$@"
