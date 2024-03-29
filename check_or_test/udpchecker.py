import argparse
import socket
import socks

def main(proxy_port):
    s = socks.socksocket(socket.AF_INET, socket.SOCK_DGRAM)
    s.set_proxy(socks.SOCKS5, "127.0.0.1", proxy_port)
    # Raw DNS request
    req = b"\x12\x34\x01\x00\x00\x01\x00\x00\x00\x00\x00\x00\x05\x62\x61\x69\x64\x75\x03\x63\x6f\x6d\x00\x00\x01\x00\x01"
    s.sendto(req, ("8.8.8.8", 53))
    (rsp, address) = s.recvfrom(4096)
    if rsp[0] == req[0] and rsp[1] == req[1]:
        print("UDP check passed")
    else:
        print("Invalid response")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--proxy-port", type=int, default=8010, help="Proxy port")
    args = parser.parse_args()

    main(args.proxy_port)
