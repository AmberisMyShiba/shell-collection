!#/bin/bash

#A shell script for update and compile openwrt firm frmo lede Repository

# \033[42;37m 绿底白字#31m 红字#32m 绿字#33m 黄字#34m 蓝字#35m 紫字#36m 青字#37m 白字#41m 红底色
# 闪烁[40;5m \033[1m粗体'

##1.Clone or update lede repository
echo -e "\033[42;37m pull sources from repository \033[0m"
OPENWRT_DIR="lede/"
DIFF_CONFIG="x86_64.diff"

#define subRepo git pull path
ARGON_DIR="luci-theme-argon/"
HELLOWORLD_DIR="luci-app-helloworld/"
VSSR_DIR="luci-app-vssr/"
VSSR_DEPS_DIR="lua-maxminddb/"
OPENCLASH_DIR="luci-app-openclash/luci-app-openclash" #notice this special
JDDAILY_DIR="luci-app-jd-dailybonus/"
PKG_ARRAY=($ARGON_DIR $HELLOWORLD_DIR $VSSR_DIR $VSSR_DEPS_DIR $OPENCLASH_DIR $JDDAILY_DIR)

if [ ! -d "$OPENWRT_DIR" ];then
	echo -e "\033[42;37m pull sources from LEDE repository \033[0m"
	git clone https://github.com/coolsnowwolf/lede
	cd lede
else
	echo -e "\033[42;37m Found LEDE Repository in current DIR,prepare for updating \033[0m"
	cd lede
	echo -e "\033[40;5m Cleaning Compile cache\033[0m"
	rm -rf ./feeds
	make distclean
    sleep 2
    echo -e "\033[42;37m Starting pull remote for syncing \033[0m"
    
    #update main repo
    git pull
    
    #update sub repo
    for str in ${PKG_ARRAY[@]}; do
    	git -C package/$str pull
    done
fi

##2.install extra luci software
##2.1	argon-theme		/jerrykuku/luci-theme-argon/tree/18.06
##2.2	hello-world		/fw876/helloworld
##2.3	vssr			/jerrykuku/luci-app-vssr
##2.4	opencalsh		/vernesong/OpenClash
##2.5	jd-dailybonus	/jerrykuku/node-request.git  #git node-request 依赖
						/jerrykuku/luci-app-jd-dailybonus.git

#2.1 install argon-theme
PKG_DIR=$ARGON_DIR
rm -rf package/$PKG_DIR
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/$PKG_DIR

#2.2 install helloworld
PKG_DIR=$HELLOWORLD_DIR
rm -rf package/$PKG_DIR
git clone --depth=1 https://github.com/fw876/helloworld.git package/$PKG_DIR

#2.3 install vssr
PKG_DIR=$VSSR_DIR
DEPS_DIR=$VSSR_DEPS_DIR
rm -rf package/{$PKG_DIR,$DEPS_DIR}
git clone https://github.com/jerrykuku/lua-maxminddb.git $PKG_DIR
git clone https://github.com/jerrykuku/luci-app-vssr.git $DEPS_DIR

#2.4 install openclash
#PKG_DIR="luci-app-openclash/"
PKG_DIR=$(echo $OPENCLASH_DIR|cut -d '/' -f2)
rm -rf package/$PKG_DIR
mkdir -p package/$PKG_DIR
git -C package/$PKG_DIR init
git -C package/$PKG_DIR remote add -f origin https://github.com/vernesong/OpenClash.git
git -C package/$PKG_DIR config core.sparsecheckout true
echo "luci-app-openclash" >> package/$PKG_DIR/.git/info/sparse-checkout
git -C package/$PKG_DIR pull --depth 1 origin master
git -C package/$PKG_DIR branch --set-upstream-to=origin/master master
# 编译 po2lmo (如果有po2lmo可跳过)
if [ ! -f "/usr/bin/po2lmo" ]; then
	pushd package/$PKG_DIR/luci-app-openclash/tools/po2lmo
	make && sudo make install
	popd
fi

#2.5 install luci-app-jd-dailybonus
PKG_DIR=$JDDAILY
rm -rf package/$PKG_DIR
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/$PKG_DIR

#4. install feeds
./scripts/feeds update -a 
./scripts/feeds install -a
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
          	echo -e "\033[36m Please make menuconfig at least once and run:[$ \033[32m scripts/diffconfig.sh > x86_64.diff] to creat a diff config file.\033[0m"
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
		time make download -j$(($(nproc)+1))
		make -j$(($(nproc)+1)) || make -j1 V=sc 2>&1 | tee build.log #| fgrep -i '[^_-"a-z]error[^_-.a-z]'
        ;;
	*)
        exit 0
 esac
