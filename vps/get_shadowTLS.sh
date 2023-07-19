#!/bin/bash

repo="ihciah/shadow-tls"    #server or client
version=$1 # 获取第二个参数：version
arch=$2  
os_type=$3 # 获取第一个参数：os_type
url=""

filecheck() {
    tgn=$1
    if [ -f "$1" ]; then
        echo -e "\t File $1 existed! Would you delete it(y/n)!!"
        default="y|Y"
        read -r -p "input Yes(y) or No(n) [default=$default] " answer
        : "${mychoice:=$default}"
        echo "you answered: $answer"
        case $mychoice in
        y | Y)
            echo "Debug the file $tgn will be rm"
            echo "Delete action confirmed!"
            rm -rf "$tgn"
            ;;
        n | N)
            echo "File will be reserved."
            exit 1
            ;;
        esac
    fi

}

main () {
        if [ $# -lt 1 ]; then
                echo -e "\tPlease input version number as para1, arch as para2, OS as para3"
    echo -e "\tThe OS type shoud be:linux|openwrt|apple"
    echo -e "\tThe architech could choose:x86_64|arm|armv7|aarch64"
    echo -e "\tExample:./$0  0.2.3 x86_64 linux"
                exit 1
        fi
        case $2 in
                x86_64)                 arch="x86_64";;
                arm)                            arch="arm";;
                armv7)                  arch="armv7";;
                aarch64)                arch="aarch64";;
                *)                      echo "null arch input,x86_64 will be the deault!"; arch="x86_64";;
        esac
        case $3 in
                linux)                  os_type="unknown-linux-musl";;
                openwrt)                os_type="unknown-linux-musl";;
                apple)                  os_type="apple-darwin";;
                *)                      echo "null OS_type input,linux-gnu will be the deault!"; os_type="unknown-linux-gnu";;
        esac
        url=https://github.com/$repo/releases/download/v$version/${repo##*/}-$arch-$os_type
  if [ ! -z "$repo" ]; then
        echo "Debug:repo: $repo, Version: $version, Arch:$arch , OS:$os_type"
                echo "Debug:$repo target URL:$url"
                filename=${repo##*/}-$version-$arch-$os_type
                filecheck "$filename"
                wget "$url" -q --show-progres -O "$filename" || {
        echo "Error: Failed to download file,please verify input params"
      exit 1
    }
  else
        echo "repo is a NULL"
        exit 1
  fi
}

main "$@"
