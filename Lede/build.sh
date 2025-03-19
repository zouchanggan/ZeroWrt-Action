#!/bin/bash -e

# github actions - caddy server
export mirror=http://127.0.0.1:8080

echo "LAN: $LAN"
echo "Device: $device"
echo "openwrt_kernel: $openwrt_kernel"

# Clone source code
git clone https://github.com/coolsnowwolf/lede openwrt

# Enter source code
cd openwrt

# Init feeds
./scripts/feeds update -a
./scripts/feeds install -a

# lan
sed -i 's/192.168.1.1/$LAN/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/$LAN/g' package/base-files/luci2/bin/config_generate

# Replace kernel
sed -i 's/6.12/6.6/g' target/linux/x86/Makefile

# scripts
curl -sO $mirror/Mediatek/$source_branch/00-prepare_base.sh
curl -sO $mirror/Mediatek/$source_branch/01-prepare_package.sh
chmod 0755 00-prepare_base.sh
chmod 0755 01-prepare_package.sh
bash 00-prepare_base.sh
bash 01-prepare_package.sh

# Load devices Config
if [ "$device" = "friendlyarm_nanopi-r2c" ]; then
    curl -s $mirror/Lede/Configs/friendlyarm_nanopi-r2c.config > .config
elif [ "$device" = "friendlyarm_nanopi-r2s" ]; then
    curl -s $mirror/Lede/Configs/friendlyarm_nanopi-r2s.config > .config
elif [ "$device" = "friendlyarm_nanopi-r3s" ]; then
    curl -s $mirror/Lede/Configs/friendlyarm_nanopi-r3s.config > .config
elif [ "$device" = "friendlyarm_nanopi-r4s" ]; then
    curl -s $mirror/Lede/Configs/friendlyarm_nanopi-r4s.config > .config
elif [ "$device" = "friendlyarm_nanopi-r4se" ]; then
    curl -s $mirror/Lede/Configs/friendlyarm_nanopi-r4se.config > .config
elif [ "$device" = "friendlyarm_nanopi-r5c" ]; then    
    curl -s $mirror/Lede/Configs/friendlyarm_nanopi-r5c.config > .config
elif [ "$device" = "friendlyarm_nanopi-r5s" ]; then
    curl -s $mirror/Lede/Configs/friendlyarm_nanopi-r5s.config > .config
elif [ "$device" = "friendlyarm_nanopi-r6c" ]; then
    curl -s $mirror/Lede/Configs/friendlyarm_nanopi-r6c.config > .config
elif [ "$device" = "friendlyarm_nanopi-r6s" ]; then   
    curl -s $mirror/Lede/Configs/friendlyarm_nanopi-r6s.config > .config
elif [ "$device" = "firefly_station-p2" ]; then
    curl -s $mirror/Lede/Configs/firefly_station-p2.config > .config
elif [ "$device" = "friendlyarm_nanopi-neo3" ]; then 
    curl -s $mirror/Lede/Configs/friendlyarm_nanopi-neo3.config > .config
elif [ "$device" = "fastrhino_r66s" ]; then  
    curl -s $mirror/Lede/Configs/fastrhino_r66s.config > .config
elif [ "$device" = "fastrhino_r68s" ]; then
    curl -s $mirror/Lede/Configs/fastrhino_r68s.config > .config
elif [ "$device" = "ezpro_mrkaio-m68s" ]; then
    curl -s $mirror/Lede/Configs/ezpro_mrkaio-m68s.config > .config
elif [ "$device" = "ezpro_mrkaio-m68s-plus" ]; then
    curl -s $mirror/Lede/Configs/ezpro_mrkaio-m68s-plus.config > .config
elif [ "$device" = "hinlink_opc-h66k" ]; then
    curl -s $mirror/Lede/Configs/hinlink_opc-h66k.config > .config
elif [ "$device" = "hinlink_opc-h68k" ]; then
    curl -s $mirror/Lede/Configs/hinlink_opc-h68k.config > .config
elif [ "$device" = "hinlink_opc-h69k" ]; then
    curl -s $mirror/Lede/Configs/hinlink_opc-h69k.config > .config
elif [ "$device" = "lyt_t68m" ]; then
    curl -s $mirror/Lede/Configs/lyt_t68m.config > .config
fi

# ccache
echo "CONFIG_CCACHE=y" >> .config
echo "CONFIG_CCACHE_DIR=\"/builder/.ccache\"" >> .config

# init openwrt config
make defconfig

# Compile
make -j$(nproc)
