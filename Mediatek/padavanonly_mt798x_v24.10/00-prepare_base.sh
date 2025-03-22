#!/bin/bash -e
#========================================================================================================================
# https://github.com/oppen321/ZeroWrt-Action
# Description: Automatically Build OpenWrt for Mediatek
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/padavanonly/immortalwrt-mt798x-24.10 / Branch: 2410
#========================================================================================================================

# default LAN IP
sed -i "s/192.168.6.1/$LAN/g" package/base-files/files/bin/config_generate

# init-settings.sh
mkdir -p files/etc/uci-defaults
curl -s $mirror/Mediatek/files/etc/uci-defaults/99-init-settings > files/etc/uci-defaults/99-init-settings

# 更改 Argon 主题背景
curl -s $mirror/images/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# Load source
sed -i "1isrc-git extraipk https://github.com/xiangfeidexiaohuo/extra-ipk\n" feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a
