#!/bin/bash
#========================================================================================================================
# https://github.com/oppen321/ZeroWrt-Action
# Description: Automatically Build OpenWrt
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/immortalwrt/immortalwrt / Branch: openwrt-24.10
#========================================================================================================================

# 替换软件包
rm -rf feeds/packages/lang/golang
rm -rf feeds/packages/utils/coremark
rm -rf feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/net/{alist,zerotier,xray-core,v2ray-core,v2ray-geodata,sing-box}

# golong1.24依赖
git clone --depth=1 -b 24.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# helloworld
git clone --depth=1 -b helloworld https://github.com/oppen321/openwrt-package package/helloworld

# 加载软件源
git clone --depth=1 https://github.com/oppen321/openwrt-package package/openwrt-package

# 加入作者信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='ZeroWrt-$(date +%Y%m%d)'/g"  package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By OPPEN321'/g" package/base-files/files/etc/openwrt_release

# 主题设置
sed -i 's/bing/none/' package/openwrt-package/luci-app-argon-config/root/etc/config/argon
curl -s $mirror/images/bg1.jpg package/openwrt-package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
sed -i 's#<a class="luci-link" href="https://github.com/openwrt/luci" target="_blank">Powered by <%= ver.luciname %> (<%= ver.luciversion %>)</a> /#<a class="luci-link" href="https://www.kejizero.online" target="_blank">探索无限</a> /#' package/openwrt-package/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">ArgonTheme |<a href="https://github.com/oppen321/ZeroWrt-Action" target="_blank">ZeroWrt-Action |g' package/openwrt-package/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's#<a class="luci-link" href="https://github.com/openwrt/luci" target="_blank">Powered by <%= ver.luciname %> (<%= ver.luciversion %>)</a> /#<a class="luci-link" href="https://www.kejizero.online" target="_blank">探索无限</a> /#' package/openwrt-package/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm
sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">ArgonTheme |<a href="https://github.com/oppen321/ZeroWrt-Action" target="_blank">ZeroWrt-Action |g' package/openwrt-package/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm


# update feeds
./scripts/feeds update -a
./scripts/feeds install -a
