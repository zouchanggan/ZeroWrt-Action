#!/bin/bash

# 设置默认密码
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow

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
curl -so files/root/.bash_profile https://git.kejizero.online/zhao/files/raw/branch/main/root/.bash_profile
curl -so files/root/.bashrc https://git.kejizero.online/zhao/files/raw/branch/main/root/.bashrc

#补充汉化
echo -e "\nmsgid \"Control\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"控制\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po

echo -e "\nmsgid \"NAS\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"网络存储\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po

echo -e "\nmsgid \"VPN\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"魔法网络\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po

echo -e "\nmsgid \"Temperature\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"温度\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po

              
##配置ip等
sed -i 's|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += phicomm-k3|TARGET_DEVICES += phicomm-k3| ; s|# TARGET_DEVICES += phicomm_k3|TARGET_DEVICES += phicomm_k3|' target/linux/bcm53xx/image/Makefile
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/luci2/bin/config_generate

##取消bootstrap为默认主题
rm -rf ./feeds/luci/themes/luci-theme-argon
rm -rf ./feeds/luci/themes/luci-theme-design
rm -rf ./feeds/luci/themes/luci-theme-argon-mod

rm -rf ./package/feeds/luci/luci-theme-argon
rm -rf ./package/feeds/luci/luci-theme-design
rm -rf ./package/feeds/luci/luci-theme-argon-mod

sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-kucat/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-kucat/g' feeds/luci/collections/luci-nginx/Makefile

##加入作者信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='ZeroWrt-$(date +%Y%m%d)'/g" package/lean/default-settings/files/zzz-default-settings   
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By OPPEN321'/g" package/lean/default-settings/files/zzz-default-settings


sed -i "2iuci set istore.istore.channel='zero_oppen321'" package/lean/default-settings/files/zzz-default-settings
sed -i "3iuci commit istore" package/lean/default-settings/files/zzz-default-settings


##更改主机名
sed -i "s/hostname='.*'/hostname='ZeroWrt'/g" package/base-files/files/bin/config_generate
sed -i "s/hostname='.*'/hostname='ZeroWrt'/g" package/base-files/luci2/bin/config_generate

##WiFi
sed -i "s/LEDE/ZeroWrt/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh

### fix speed
sed -i "s/speed = <2500>;/speed = <1000>;/g" target/linux/mediatek/dts/mt7622-*.dts
sed -i "s/speed = <2500>;/speed = <1000>;/g" target/linux/mediatek/dts/mt7623a-*.dts
sed -i "s/speed = <2500>;/speed = <1000>;/g" target/linux/mediatek/dts/mt7981b-*.dts
sed -i "s/speed = <2500>;/speed = <1000>;/g" target/linux/mediatek/dts/mt7986a-*.dts
sed -i "s/speed = <2500>;/speed = <1000>;/g" target/linux/mediatek/dts/mt7622-*.dtsi
sed -i "s/speed = <2500>;/speed = <1000>;/g" target/linux/mediatek/dts/mt7623a-*.dtsi


##
sed -i '/option Interface/d'  package/network/services/dropbear/files/dropbear.config
##
rm -rf ./package/lean/k3screenctrl

## rockchip
cp -af feeds/2305ipk/patch/rockchip/*  target/linux/rockchip/armv8/base-files/

# 进阶设置
git clone https://github.com/sirpdboy/luci-app-advancedplus package/luci-app-advancedplus

# theme
git clone https://github.com/sirpdboy/luci-theme-kucat package/luci-theme-kucat -b js

# 设置向导
git clone --depth=1 https://github.com/sirpdboy/luci-app-netwizard package/luci-app-netwizard

# ZeroWrt选项菜单
mkdir -p files/bin
curl -L -o files/bin/ZeroWrt https://git.kejizero.online/zhao/files/raw/branch/main/bin/ZeroWrt
chmod +x files/bin/ZeroWrt
mkdir -p files/root
curl -L -o files/root/version.txt https://git.kejizero.online/zhao/files/raw/branch/main/bin/version.txt
chmod +x files/root/version.txt
