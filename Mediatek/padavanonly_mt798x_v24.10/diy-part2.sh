#!/bin/bash

# Load devices Config

# TTYD
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

# 移除要替换的包
rm -rf feeds/packages/lang/golang

# golong1.24依赖
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# kucat
git clone -b js https://github.com/sirpdboy/luci-theme-kucat
git clone https://github.com/sirpdboy/luci-app-kucat-config
