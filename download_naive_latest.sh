#!/bin/bash
curl -s "https://api.github.com/repos/klzgrad/naiveproxy/releases/latest" | grep linux-x64 | grep browser_download_url | cut -d : -f 2,3 | tr -d \" | wget -qi -
tar -xvf naive*tar.xz
sudo cp naive*/naive /usr/local/bin/naive
