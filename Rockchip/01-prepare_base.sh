#!/bin/bash
#========================================================================================================================
# https://github.com/oppen321/ZeroWrt-Action
# Description: Automatically Build OpenWrt for Rockchip
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/immortalwrt/immortalwrt / Branch: openwrt-24.10
#========================================================================================================================

# default LAN IP
sed -i "s/192.168.1.1/$LAN/g" package/base-files/files/bin/config_generate

# 修改名称
sed -i 's/OpenWrt/ZeroWrt/' package/base-files/files/bin/config_generate

# init-settings.sh
mkdir -p files/etc/uci-defaults
curl -s $mirror/Rockchip/files/etc/uci-defaults/99-init-settings > files/etc/uci-defaults/99-init-settings

# Luci diagnostics.js
sed -i "s/openwrt.org/www.qq.com/g" feeds/luci/modules/luci-mod-network/htdocs/luci-static/resources/view/network/diagnostics.js

# Realtek driver - R8168 & R8125 & R8126 & R8152 & R8101
rm -rf package/kernel/r8168 package/kernel/r8101 package/kernel/r8125 package/kernel/r8126
git clone $gitea/package_kernel_r8126 package/kernel/r8168
git clone $gitea/package_kernel_r8152 package/kernel/r8152
git clone $gitea/package_kernel_r8101 package/kernel/r8101
git clone $gitea/package_kernel_r8125 package/kernel/r8125
git clone $gitea/package_kernel_r8126 package/kernel/r8126

# TTYD
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

# luci
pushd feeds/luci
    curl -s $mirror/patch/luci/0001-luci-mod-status-firewall-disable-legacy-firewall-rul.patch | patch -p1
popd

# video
curl -s $mirror/patch/linux/video/0001-rockchip-drm-panfrost.patch
curl -s $mirror/patch/linux/video/0002-drm-rockchip-support.patch
git apply 0001-rockchip-drm-panfrost.patch
git apply 0002-drm-rockchip-support.patch

# 移除 SNAPSHOT 标签
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in
sed -i '/CONFIG_BUILDBOT/d' include/feeds.mk
sed -i 's/;)\s*\\/; \\/' include/feeds.mk

# kernel modules
rm -rf package/kernel/linux
git checkout package/kernel/linux
pushd package/kernel/linux/modules
    rm -f [a-z]*.mk
    curl -Os $mirror/patch/modules/block.mk
    curl -Os $mirror/patch/modules/can.mk
    curl -Os $mirror/patch/modules/crypto.mk
    curl -Os $mirror/patch/modules/firewire.mk
    curl -Os $mirror/patch/modules/fs.mk
    curl -Os $mirror/patch/modules/gpio.mk
    curl -Os $mirror/patch/modules/hwmon.mk
    curl -Os $mirror/patch/modules/i2c.mk
    curl -Os $mirror/patch/modules/iio.mk
    curl -Os $mirror/patch/modules/input.mk
    curl -Os $mirror/patch/modules/leds.mk
    curl -Os $mirror/patch/modules/lib.mk
    curl -Os $mirror/patch/modules/multiplexer.mk
    curl -Os $mirror/patch/modules/netdevices.mk
    curl -Os $mirror/patch/modules/netfilter.mk
    curl -Os $mirror/patch/modules/netsupport.mk
    curl -Os $mirror/patch/modules/nls.mk
    curl -Os $mirror/patch/modules/other.mk
    curl -Os $mirror/patch/modules/pcmcia.mk
    curl -Os $mirror/patch/modules/rtc.mk
    curl -Os $mirror/patch/modules/sound.mk
    curl -Os $mirror/patch/modules/spi.mk
    curl -Os $mirror/patch/modules/usb.mk
    curl -Os $mirror/patch/modules/video.mk
    curl -Os $mirror/patch/modules/virt.mk
    curl -Os $mirror/patch/modules/w1.mk
    curl -Os $mirror/patch/modules/wpan.mk
popd
