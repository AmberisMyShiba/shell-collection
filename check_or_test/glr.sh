#!/bin/bash
#glr means get latest release from github
get_latest_release() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

usage() {
# $ get_latest_release "creationix/nvm"
# v0.31.4
cat << 'EOF'
Useage:./glr.sh  <"Account/Repo">
Example:./glr.sh "klzgrad/naiveproxy"
EOF
}

main() {
    if [ $# -eq 0 ];
    then
        usage
    exit
    else
        curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
        grep '"tag_name":' |                                            # Get tag line
        sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
    fi
}

main "$@"
