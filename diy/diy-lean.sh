#!/bin/bash

# Remove and update plugins
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box,adguardhome,alist,chinadns-ng,daed,dns2socks,dns2tcp,pdnsd-alt,shadowsocks-libev,trojan,v2ray-geodata,}
rm -rf feeds/luci/applications/{luci-app-alist,luci-app-daed,luci-app-mosdns,luci-app-openclash,luci-app-passwall,luci-app-passwall2}
rm -rf feeds/packages/lang/golang

# OpenAppFilter
git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter

# 
