#!/usr/bin/env bash

set -e -o pipefail

if [ -d /usr/local/go ]; then
  export PATH="$PATH:/usr/local/go/bin"
fi

DIR=$(dirname "$0")
PROJECT=$DIR/../..

pushd $PROJECT
VERSION=$(CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go run ./cmd/internal/read_tag)
go install -v -trimpath -ldflags "-X \"github.com/sagernet/sing-box/constant.Version=$VERSION\"-s -w -buildid=" -tags with_gvisor,with_clash_api,with_grpc,with_utls,with_ech,with_reality_server,with_quic,with_wireguard,with_acme ./cmd/sing-box
popd

sudo systemctl stop sing-box
sudo kill $(pgrep -x sing-box) 2>/dev/null || true
sudo cp /usr/local/bin/sing-box /usr/local/bin/sing-box-old
sudo cp $(go env GOPATH)/bin/sing-box /usr/local/bin/sing-box
sudo systemctl status sing-box
