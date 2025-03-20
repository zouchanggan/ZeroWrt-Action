#!/bin/bash

echo -e "\nmsgid \"Control\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"控制\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po

echo -e "\nmsgid \"NAS\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"网络存储\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po

# 更新插件
rm -rf ./feeds/packages/net/{dns2socks,v2ray-core,xray-core,pdnsd-alt,dns2tcp,ipt2socks,microsocks,chinadns-ng,redsocks2,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,trojan,tuic-client,v2ray-geodata,v2ray-plugin,xray-plugin}
rm -rf ./feeds/luci/applications/{luci-app-passwall,luci-app-openclash,luci-app-ssr-plus}
rm -rf ./package/feeds/packages/{dns2socks,v2ray-core,xray-core,pdnsd-alt,dns2tcp,ipt2socks,microsocks,chinadns-ng,redsocks2,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,trojan,tuic-client,v2ray-geodata,v2ray-plugin,xray-plugin}
rm -rf ./package/feeds/luci/applications/{luci-app-passwall,luci-app-openclash,luci-app-ssr-plus}

# 加载软件源
git clone -b helloworld https://github.com/oppen321/openwrt-package package/openwrt-package

## golang 为 1.24.x
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang
