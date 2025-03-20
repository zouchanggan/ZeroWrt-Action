#!/bin/bash

# 更新插件
rm -rf ./feeds/packages/net/{dns2socks,v2ray-core,xray-core,pdnsd-alt,dns2tcp,ipt2socks,microsocks,chinadns-ng,redsocks2,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,trojan,tuic-client,v2ray-geodata,v2ray-plugin,xray-plugin}
rm -rf ./feeds/luci/applications/{luci-app-passwall,luci-app-openclash,luci-app-ssr-plus}
rm -rf ./package/feeds/packages/{dns2socks,v2ray-core,xray-core,pdnsd-alt,dns2tcp,ipt2socks,microsocks,chinadns-ng,redsocks2,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,trojan,tuic-client,v2ray-geodata,v2ray-plugin,xray-plugin}
rm -rf ./package/feeds/luci/{luci-app-passwall,luci-app-openclash,luci-app-ssr-plus}
rm -rf feeds/packages/lang/golang

# 加载软件源
git clone --depth=1 -b helloworld https://github.com/oppen321/openwrt-package package/openwrt-package

# luci-app-adguardhome
git clone --depth=1 https://github.com/oppen321/luci-app-adguardhome

# 设置文件目录
mv package/openwrt-package/{dns2socks,v2ray-core,xray-core,pdnsd-alt,dns2tcp,ipt2socks,microsocks,chinadns-ng,redsocks2,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,trojan,tuic-client,v2ray-geodata,v2ray-plugin,xray-plugin} feeds/packages/net
mv package/openwrt-package/{luci-app-passwall,luci-app-openclash,luci-app-ssr-plus} feeds/luci/applications

## golang 为 1.24.x
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang
