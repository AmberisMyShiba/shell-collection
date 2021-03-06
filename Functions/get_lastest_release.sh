#!/bin/bash

get_latest_release() {
  url="https://api.github.com/repos/"$1"/release/latest"
#  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
#    curl --silent $url |
#    grep '"tag_name":' |                                            # Get tag line
#    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

usage() {
# $ get_latest_release "creationix/nvm"
# v0.31.4
cat << 'EOF'
Useage:./get_latest_release.sh  <"Account/Repo">
Example:./get_latest_release.sh "klzgrad/naiveproxy"
EOF
}

main() {
    if [ $# -eq 0 ];
    then
        usage
    exit
    else
#        echo $1
        echo 'https://api.github.com/repos/$1/releases/latest'
        get_latest_release
        echo $url

    fi
}

main "$@"
