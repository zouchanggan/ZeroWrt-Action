#!/bin/bash

# 修改默认IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# profile
sed -i 's#\\u@\\h:\\w\\\$#\\[\\e[32;1m\\][\\u@\\h\\[\\e[0m\\] \\[\\033[01;34m\\]\\W\\[\\033[00m\\]\\[\\e[32;1m\\]]\\[\\e[0m\\]\\\$#g' package/base-files/files/etc/profile
sed -ri 's/(export PATH=")[^"]*/\1%PATH%:\/opt\/bin:\/opt\/sbin:\/opt\/usr\/bin:\/opt\/usr\/sbin/' package/base-files/files/etc/profile
sed -i '/PS1/a\export TERM=xterm-color' package/base-files/files/etc/profile

# TTYD
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

# bash
sed -i 's#ash#bash#g' package/base-files/files/etc/passwd
sed -i '\#export ENV=/etc/shinit#a export HISTCONTROL=ignoredups' package/base-files/files/etc/profile
mkdir -p files/root
curl -so files/root/.bash_profile https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/files/raw/branch/main/root/.bash_profile
curl -so files/root/.bashrc https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/files/raw/branch/main/root/.bashrc

# 移除要替换的包
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box,adguardhome,socat}
rm -rf feeds/packages/net/alist feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/packages/lang/golang

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# golong1.23依赖
#git clone --depth=1 https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/packages_lang_golang -b 23.x feeds/packages/lang/golang

# SSRP & Passwall
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/openwrt_helloworld.git package/helloworld -b v5

# Alist
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/luci-app-alist package/alist

# Mosdns
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/luci-app-mosdns.git -b v5 package/mosdns
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/v2ray-geodata.git package/v2ray-geodata

# Realtek 网卡 - R8168 & R8125 & R8126 & R8152 & R8101
rm -rf package/kernel/r8168 package/kernel/r8101 package/kernel/r8125 package/kernel/r8126
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/package_kernel_r8168 package/kernel/r8168
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/package_kernel_r8152 package/kernel/r8152
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/package_kernel_r8101 package/kernel/r8101
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/package_kernel_r8125 package/kernel/r8125
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/package_kernel_r8126 package/kernel/r8126

# Adguardhome
git_sparse_clone master https://github.com/kenzok8/openwrt-packages adguardhome luci-app-adguardhome

# iStore
git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
git_sparse_clone main https://github.com/linkease/istore luci

# Docker
rm -rf feeds/luci/applications/luci-app-dockerman
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/luci-app-dockerman -b 24.10 feeds/luci/applications/luci-app-dockerman
rm -rf feeds/packages/utils/{docker,dockerd,containerd,runc}
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/packages_utils_docker feeds/packages/utils/docker
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/packages_utils_dockerd feeds/packages/utils/dockerd
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/packages_utils_containerd feeds/packages/utils/containerd
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/packages_utils_runc feeds/packages/utils/runc
sed -i '/sysctl.d/d' feeds/packages/utils/dockerd/Makefile
pushd feeds/packages
    curl -s https://init.cooluc.com/openwrt/patch/docker/0001-dockerd-fix-bridge-network.patch | patch -p1
    curl -s https://init.cooluc.com/openwrt/patch/docker/0002-docker-add-buildkit-experimental-support.patch | patch -p1
    curl -s https://init.cooluc.com/openwrt/patch/docker/0003-dockerd-disable-ip6tables-for-bridge-network-by-defa.patch | patch -p1
popd

# UPnP
rm -rf feeds/{packages/net/miniupnpd,luci/applications/luci-app-upnp}
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/miniupnpd feeds/packages/net/miniupnpd -b v2.3.7
git clone https://$GIT_USERNAME:$GIT_PASSWORD@git.kejizero.online/zhao/luci-app-upnp feeds/luci/applications/luci-app-upnp -b master

