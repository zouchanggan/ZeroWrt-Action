#!/bin/bash
#========================================================================================================================
# https://github.com/oppen321/ZeroWrt-Action
# Description: Automatically Build OpenWrt
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/immortalwrt/immortalwrt / Branch: openwrt-24.10
#========================================================================================================================

# 替换软件包
rm -rf feeds/packages/lang/golang
rm -rf feeds/packages/net/{v2ray-geodata,alist,mentohust,dns2socks,dns2tcp,geoview,sing-box,tcping,trojan,tuic-client,v2ray-core,v2ray-plugin,xray-core.xray-plugin.simple-obfs,shadowsocks-rust,redsocks2,naiveproxy,microsocks,hysteria,lua-neturl}
rm -rf feeds/luci/applications/{luci-app-alist,luci-app-mentohust,luci-app-passwall,luci-app-openclash}

# golong1.24依赖
git clone --depth=1 -b 24.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# helloworld
git clone --depth=1 -b helloworld https://github.com/oppen321/openwrt-package package/openwrt-package

# mosdns
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone --depth=1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# alist
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/alist

# mentohust
git clone --depth=1 https://github.com/sbwml/luci-app-mentohust package/luci-app-mentohust

# adguardhome
git clone --depth=1 https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome

# netspeedtest
git clone --depth=1 https://github.com/sirpdboy/netspeedtest package/netspeedtest

# parentcontrol
git clone --depth=1 https://github.com/sirpdboy/luci-app-parentcontrol package/luci-app-parentcontrol

# autotimeset
git clone --depth=1 https://github.com/sirpdboy/luci-app-autotimeset package/luci-app-autotimeset

# chatgpt-web
git clone --depth=1 https://github.com/sirpdboy/luci-app-chatgpt-web package/luci-app-chatgpt-web

# eqosplus
git clone --depth=1 https://github.com/sirpdboy/luci-app-eqosplus package/luci-app-eqosplus

# wolplus
git clone --depth=1 https://github.com/oppen321/luci-app-wolplus package/luci-app-wolplus

