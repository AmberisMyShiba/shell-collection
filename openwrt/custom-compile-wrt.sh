!#/bin/bash

#A shell script for update and compile openwrt firm frmo lede Repository

# \033[42;37m 绿底白字#31m 红字#32m 绿字#33m 黄字#34m 蓝字#35m 紫字#36m 青字#37m 白字#41m 红底色
# 闪烁[40;5m \033[1m粗体'

##1.Clone or update lede repository
echo -e "\033[42;37m pull sources from repository \033[0m"
OPENWRT_DIR="lede/"
DIFF_CONFIG=x86_64.config
if [ ! -d "$OPENWRT_DIR" ];then
	echo -e "\033[42;37m pull sources from LEDE repository \033[0m"
	git clone https://github.com/coolsnowwolf/lede
	cd lede
else
	echo -e "\033[42;37m Found LEDE Repository in current DIR,prepare for updateing \033[0m"
	cd lede
	echo -e "\033[40;5m Cleaning Compile cache\033[0m"
	rm -rf ./feeds
	make distclean
    sleep 2
    echo -e "\033[42;37m Starting pull remote for syncing \033[0m"
    git pull
fi

##2.install extra luci software
##2.1	argon-theme		/jerrykuku/luci-theme-argon/tree/18.06
##2.2	hello-world		/fw876/helloworld
##2.3	opencalsh		/vernesong/OpenClash
##2.4	jd-dailybonus	/jerrykuku/node-request.git  #git node-request 依赖
						/jerrykuku/luci-app-jd-dailybonus.git

#2.1 install argon-theme
LUCI_DIR="luci-theme-argon/"
rm -rf package/$LUCI_DIR
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/$LUCI_DIR

#2.2 install helloworld
LUCI_DIR="luci-app-helloworld/"
rm -rf package/$LUCI_DIR
git clone --depth=1 https://github.com/fw876/helloworld.git package/$LUCI_DIR

#2.3 install openclash
LUCI_DIR="luci-app-openclash/"
rm -rf package/$LUCI_DIR
mkdir -p package/$LUCI_DIR
git -C package/$LUCI_DIR init
git -C package/$LUCI_DIR remote add -f origin https://github.com/vernesong/OpenClash.git
git -C package/$LUCI_DIR config core.sparsecheckout true
echo "luci-app-openclash" >> package/$LUCI_DIR/.git/info/sparse-checkout
git -C package/$LUCI_DIR pull --depth 1 origin master
git -C package/$LUCI_DIR branch --set-upstream-to=origin/master master
# 编译 po2lmo (如果有po2lmo可跳过)
if [ ! -f "/usr/bin/po2lmo" ]; then
	pushd package/$LUCI_DIR/luci-app-openclash/tools/po2lmo
	make && sudo make install
	popd
fi

#2.4 install luci-app-jd-dailybonus
LUCI_DIR="luci-app-jd-dailybonus"
rm -rf package/$LUCI_DIR
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/$LUCI_DIR

#4. install feeds
./scripts/feeds update -a 
./scripts/feeds install -a
DIFF_CONFIG=x86_64.config
if [ -f ../"$DIFF_CONFIG" ]; then
	echo -e "\033[1m Found \033[42;37mDIFF.config\033[0m,Copy to .config and apply.\033[0m"
	cp -f ../"$DIFF_CONFIG" .config
fi
make defconfig

default="y"
read -e -p "Do you wanna configure by menuconfig?(y/n)" ac
ac="${ac:-${default}}"
#echo $ac
case $ac in
	y|Y)
   		make menuconfig;;
   	n|N)
  		if [ ! -f "$DIFF_CONFIG" ];then
   			echo -e "\033[1m The file which name is\033[5m \033[42;31md$DIFF_CONFIG\033[0m \033[1mis not found! \033[0m"
          	echo -e "\033[36m Please make menuconfig at least once and run:[$ \033[32m scripts/diffconfig.sh > x86_64.config] to creat a diff config file.\033[0m"
           	exit 1
      	else
           	echo -e "\033[1m The file which name is\033[5m \033[42;31md$DIFF_CONFIG\033[0m \033[1mis found!\033[0m"
           	echo -e "\033[1m It will be the default .config file as compiling[0m \033[1mis not found! \033[0m"
           	make menuconfig
      	fi
		;;
   	*)
#   exit 0
esac
echo -e "Downloading feeds and sources"
default="Y"
read -e -p "Compile firmware right now?(y/n)" ac
ac="${ac:-${default}}"
#echo $ac
case $ac in
	y|Y)
		time make download V=sc
		make -j$(($(nproc)+1)) || make -j1 V=sc 2>&1 | tee build.log #| fgrep -i '[^_-"a-z]error[^_-.a-z]'
        ;;
	*)
        exit 0
 esac







