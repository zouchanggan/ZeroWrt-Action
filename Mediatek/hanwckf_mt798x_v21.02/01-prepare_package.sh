#!/bin/bash

# 更新插件
rm -rf feeds/luci/applications/luci-app-passwall/*
rm -rf feeds/luci/applications/luci-app-ssr-plus/*
rm -rf feeds/luci/applications/luci-app-openclash/*
rm -rf feeds/packages/lang/golang/*

# luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall/*
git clone --depth=1 https://github.com/oppen321/luci-app-passwall package/luci-app-passwall
cp -af package/luci-app-passwall/*  feeds/luci/applications/luci-app-passwall/

# luci-app-ssr-plus
rm -rf feeds/luci/applications/luci-app-ssr-plus/*
git clone --depth=1 https://github.com/oppen321/luci-app-ssr-plus package/luci-app-ssr-plus
cp -af package/luci-app-ssr-plus/*  feeds/luci/applications/luci-app-ssr-plus/

# luci-app-openclash
rm -rf feeds/luci/applications/luci-app-openclash/*

# luci-app-adguardhome
git clone --depth=1 https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome

# 设置文件目录
mv package/openwrt-package/{dns2socks,v2ray-core,xray-core,pdnsd,dns2tcp,ipt2socks,microsocks,chinadns-ng,redsocks2,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,trojan,tuic-client,v2ray-geodata,v2ray-plugin,xray-plugin} feeds/packages/net
mv package/openwrt-package/{luci-app-passwall,luci-app-openclash,luci-app-ssr-plus} feeds/luci/applications

## golang 为 1.24.x
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang
