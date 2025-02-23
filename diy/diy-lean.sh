#!/bin/bash

# Change default ip
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/luci2/bin/config_generate

# Change hostname
sed -i "s/hostname='.*'/hostname='ZeroWrt'/g" package/base-files/files/bin/config_generate
sed -i "s/hostname='.*'/hostname='ZeroWrt'/g" package/base-files/luci2/bin/config_generate

# Load iStoreOS


# Remove and update plugins
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box,adguardhome,alist,chinadns-ng,daed,dns2socks,dns2tcp,pdnsd-alt,shadowsocks-libev,trojan,v2ray-geodata,}
rm -rf feeds/luci/applications/{luci-app-alist,luci-app-daed,luci-app-mosdns,luci-app-openclash,luci-app-passwall,luci-app-passwall2}
rm -rf feeds/packages/lang/golang

# The modified version is the compilation date
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by OPPEN321/g" package/lean/default-settings/files/zzz-default-settings
sed -i 's/LEDE/ZeroWrt/' package/lean/default-settings/files/zzz-default-settings

# Golang
git clone -b 23.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# OpenAppFilter
git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter

