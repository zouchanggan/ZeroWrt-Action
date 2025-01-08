#!/bin/bash

mkdir -p files/etc/opkg

# 设置新的源地址
NEW_SOURCES="
src/gz openwrt_base https://downloads.openwrt.org/releases/24.10.0-rc5/packages/x86_64/base
src/gz openwrt_luci https://downloads.openwrt.org/releases/24.10.0-rc5/packages/x86_64/luci
src/gz openwrt_packages https://downloads.openwrt.org/releases/24.10.0-rc5/packages/x86_64/packages
src/gz openwrt_routing https://downloads.openwrt.org/releases/24.10.0-rc5/packages/x86_64/routing
src/gz openwrt_telephony https://downloads.openwrt.org/releases/24.10.0-rc5/packages/x86_64/telephony
"

# 创建 opkg 配置文件并写入源地址
echo "$NEW_SOURCES" > files/etc/opkg/distfeeds.conf

chmod +x files/etc/opkg/distfeeds.conf
