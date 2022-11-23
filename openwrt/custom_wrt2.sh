#!/bin/bash

#A shell script for update and compile openwrt firm frmo lede Repository

# \033[42;37m 绿底白字#31m 红字#32m 绿字#33m 黄字#34m 蓝字#35m 紫字#36m 青字#37m 白字#41m 红底色
# 闪烁[40;5m \033[1m粗体'
trap "exit 1" HUP INT QUIT TERM PIPE

font_bold() {
    printf "\e[1m$*\e[0m"
}
color_red() {
    printf "\e[35m$*\e[0m"
}
color_green() {
    printf "\e[32m$*\e[0m"
}
color_yellow() {
    printf "\e[31m$*\e[0m"
}


#define variables
WRT_DIR="lede/"
DIFF_CONFIG="x86_64.diff"
#define subRepo git pull path
#ARGON_DIR="luci-theme-argon/"
HELLOWORLD_DIR="luci-app-helloworld/"
VSSR_DIR="luci-app-vssr/"
VSSR_DEPS_DIR="lua-maxminddb/"
OPENCLASH_DIR="luci-app-openclash/luci-app-openclash" #notice this special
JDDAILY_DIR="luci-app-jd-dailybonus/"
PKG_ARRAY=($HELLOWORLD_DIR $VSSR_DIR $VSSR_DEPS_DIR $OPENCLASH_DIR $JDDAILY_DIR) #no longer needed for $ARGON_DIR 
main () {
	case $1 in
	    n|N)		
    		ColneRepo
    		IntstallSubRepo
    		InstallFeeds
    		MkConfig
    		;;
    	r|R)	
    		UpdateRepo
    		InstallFeeds
    		MkConfig
    		;;
    	v|V)
    		vershow;;
    	h|H)
    		helpmsg;;
    	 *)
    	 echo "$(color_yellow "Unknown option: $arg")"; vershow;helpmsg; return 1
    	 ;;
	esac
return 0
}

helpmsg () {
echo "Useage:$0  [COMMAND]"
cat << 'EOF'
COMMAND :=
    n|compile wrt from scratch. Clone repo, Install submodules, Update and Install feeds.
    r|update source and recompile.Git pull repo and update upstream of submodules, Clean make, Recompile wrt
    h|help message

EOF
}

vershow () {
	echo  "$(font_bold $(color_green 'This script helps compiling custom openwrt firm')) $*"
}

ColneRepo ()  {
##1.Clone or update lede repository
echo -e "\033[31m It is proceeding the clone process \033[0m"
if [ ! -d "$WRT_DIR" ];then
	echo -e "\033[42;37m pull sources from LEDE repository \033[0m"
	git clone https://github.com/coolsnowwolf/lede
	cd lede
else
	echo -e "\033[40;5m Found LEDE Repository in current path\033[0m"
fi	
default="y"
read -e -p "The repo DIR  will be removed and clone remote ?(y/n)" ac
ac="${ac:-${default}}"
#echo $ac
case $ac in
	y|Y)
		rm -rf $WRT_DIR
		echo -e "\033[42;37m The old repo has been removed!!\033[0m"
		git clone https://github.com/coolsnowwolf/lede
		#debug point
		echo -e "\033[31m $WRT_DIR \033[0m"
		cd $WRT_DIR
		;;
	n|N)
		echo -e "\033[36m Please check the repo dir:[\033[31m $WRT_DIR \033[36m]to rebuild wrt.\033[0m"
      	exit 1
   		;;
	*)
		echo -e "\033[36m Please Input correct char (y/n):[\033[312 $WRT_DIR \033[36m] to rebuild wrt.\033[0m"
		;;
esac
}

UpdateRepo () {
	echo -e "\033[31m It is proceeding the pull process \033[0m"
	CUR_DIR=$(pwd|awk -F/ '{print $NF}')
	if  [ $CUR_DIR = $WRT_DIR ]; then
		echo "start updating remote repo"
	else
		echo -e "\033[33m swith path to ~/openwrt/$WRT_DIR \033[0m"
		cd ~/openwrt/$WRT_DIR
	fi
	echo -e "\033[40;5m Cleaning Compile cache(feeds clean && make distclean \033[0m"
	#rm -rf ./feeds #same as feeds clean
    ./scripts/feeds clean
    make distclean
    echo -e "\033[42;37m Starting pull remote for syncing \033[0m"
    #update main repo
    #git reset --hard
    git pull
    #update sub repo
    for str in ${PKG_ARRAY[@]}; do
    	if  [ ! -d package/$str ]; then
    		echo -e "\033[42;30m Not found submodule:$str,Please add it in [package/$str] manually! \033[0m"
    		exit 1
    	fi
    	echo -e "\033[33m updating $str repo \033[0m"
    	git -C package/$str pull
    done
}


IntstallSubRepo () {

##2.install extra luci software
##2.1	argon-theme			/jerrykuku/luci-theme-argon/tree/18.06
##2.2	hello-world			/fw876/helloworld
##2.3	vssr				/jerrykuku/luci-app-vssr
##2.4	opencalsh			/vernesong/OpenClash
##2.5	jd-dailybonus		/jerrykuku/node-request.git  #git node-request 依赖
##							/jerrykuku/luci-app-jd-dailybonus.git
#2.1 install argon-theme
#PKG_DIR=$ARGON_DIR
#rm -rf package/$PKG_DIR
#git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/$PKG_DIR

echo -e "\033[31m It is proceeding the submodules installations \033[0m"
#2.2 install helloworld
PKG_DIR=$HELLOWORLD_DIR
echo -e "\033[32m 1.reinstalling $PKG_DIR \033[0m"
rm -rf package/$PKG_DIR
git clone --depth=1 https://github.com/fw876/helloworld.git package/$PKG_DIR

#2.3 install vssr
PKG_DIR=$VSSR_DIR
DEPS_DIR=$VSSR_DEPS_DIR
echo -e "\033[32m 2.reinstalling $PKG_DIR \033[0m"
rm -rf package/{$PKG_DIR,$DEPS_DIR}
git clone https://github.com/jerrykuku/lua-maxminddb.git package/$DEPS_DIR
git clone https://github.com/jerrykuku/luci-app-vssr.git package/$PKG_DIR

##2.4 install openclash
##PKG_DIR="luci-app-openclash/"
PKG_DIR=$(echo $OPENCLASH_DIR|cut -d '/' -f2)
echo -e "\033[32m 3.reinstalling $PKG_DIR \033[0m"
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
PKG_DIR=$JDDAILY_DIR
rm -rf package/$PKG_DIR
echo -e "\033[32m 4.reinstalling $PKG_DIR \033[0m"
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/$PKG_DIR
}

InstallFeeds () {
#3. install feeds
echo -e "\033[31m It is proceeding feeds(update && install all) \033[0m"
./scripts/feeds update -a
./scripts/feeds install -a
}

MkConfig () {
echo -e "\033[31m It is proceeding the preparation of compiling \033[0m"
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
  		if [ ! -f "../$DIFF_CONFIG" ];then
   			echo -e "\033[1m The file which name is\033[5m \033[42;31md$DIFF_CONFIG\033[0m \033[1mis not found! \033[0m"
          	echo -e "\033[36m Please make menuconfig at least once and run:[\033[32m scripts/diffconfig.sh > x86_64.diff] to creat a diff config file.\033[0m"
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
 }
 
 main "$@"
