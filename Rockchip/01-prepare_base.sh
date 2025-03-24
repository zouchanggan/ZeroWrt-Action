#!/bin/bash
#========================================================================================================================
# https://github.com/oppen321/ZeroWrt-Action
# Description: Automatically Build OpenWrt for Rockchip
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/immortalwrt/immortalwrt / Branch: openwrt-24.10
#========================================================================================================================

# 更换为 ImmortalWrt Uboot 以及 Target
rm -rf ./target/linux/rockchip
cp -rf ../immortalwrt/target/linux/rockchip ./target/linux/rockchip
cp -rf ../patch/kernel/rockchip/* ./target/linux/rockchip/patches-6.6/
rm -rf package/boot/{rkbin,uboot-rockchip,arm-trusted-firmware-rockchip}
cp -rf ../immortalwrt/package/boot/uboot-rockchip ./package/boot/uboot-rockchip
cp -rf ../immortalwrt/package/boot/arm-trusted-firmware-rockchip ./package/boot/arm-trusted-firmware-rockchip
sed -i '/REQUIRE_IMAGE_METADATA/d' target/linux/rockchip/armv8/base-files/lib/upgrade/platform.sh

curl -L -o include/kernel-6.6 https://raw.githubusercontent.com/immortalwrt/immortalwrt/refs/heads/openwrt-24.10/include/kernel-6.6

# default LAN IP
sed -i "s/192.168.1.1/$LAN/g" package/base-files/files/bin/config_generate

# 修改名称
sed -i 's/OpenWrt/ZeroWrt/' package/base-files/files/bin/config_generate

# init-settings.sh
mkdir -p files/etc/uci-defaults
curl -s $mirror/Rockchip/files/etc/uci-defaults/99-init-settings > files/etc/uci-defaults/99-init-settings

# Realtek driver - R8168 & R8125 & R8126 & R8152 & R8101
rm -rf package/kernel/r8168 package/kernel/r8101 package/kernel/r8125 package/kernel/r8126
git clone $gitea/package_kernel_r8126 package/kernel/r8168
git clone $gitea/package_kernel_r8152 package/kernel/r8152
git clone $gitea/package_kernel_r8101 package/kernel/r8101
git clone $gitea/package_kernel_r8125 package/kernel/r8125
git clone $gitea/package_kernel_r8126 package/kernel/r8126

# Luci diagnostics.js
sed -i "s/openwrt.org/www.qq.com/g" feeds/luci/modules/luci-mod-network/htdocs/luci-static/resources/view/network/diagnostics.js

# TTYD
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

# luci
pushd feeds/luci
    curl -s $mirror/patch/luci/0001-luci-mod-status-firewall-disable-legacy-firewall-rul.patch | patch -p1
popd

# 移除 SNAPSHOT 标签
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in
sed -i '/CONFIG_BUILDBOT/d' include/feeds.mk
sed -i 's/;)\s*\\/; \\/' include/feeds.mk
