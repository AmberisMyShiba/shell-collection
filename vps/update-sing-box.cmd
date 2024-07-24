git fetch
git rev-list --tags --max-count=2
git describe --tags %tag_hash%
git checkout %tag%
go install -v -trimpath -ldflags "-X \"github.com/sagernet/sing-box/constant.Version=$VERSION\"-s -w -buildid=" -tags with_gvisor,with_clash_api,with_grpc,with_utls,with_ech,with_reality_server,with_quic,with_wireguard,with_acme .\cmd\sing-box
