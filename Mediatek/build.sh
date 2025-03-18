#!/bin/bash -e

# github actions - caddy server
export mirror=http://127.0.0.1:8080

echo "LAN: $LAN"
echo "Device: $device"
echo "Source branch: $source_branch"

# Clone source code
if [ "$source_branch" = "hanwckf_mt798x_v21.02" ]; then
    git clone --depth=1 https://github.com/hanwckf/immortalwrt-mt798x openwrt
elif [ "$source_branch" = "padavanonly_mt798x_v24.10" ]; then
    git clone -b 2410 --single-branch --filter=blob:none https://github.com/padavanonly/immortalwrt-mt798x-24.10 openwrt
else
    echo "Unknown source branch: $source_branch"
    exit 1
fi

# Enter source code
cd openwrt

# Init feeds
./scripts/feeds update -a
./scripts/feeds install -a

# lan
[ -n "$LAN" ] && export LAN=$LAN || export LAN=10.0.0.1

# scripts
curl -sO $mirror/Mediatek/$source_branch/00-prepare_base.sh
curl -sO $mirror/Mediatek/$source_branch/01-prepare_package.sh
chmod 0755 00-prepare_base.sh
chmod 0755 01-prepare_package.sh
bash 00-prepare_base.sh
bash 01-prepare_package.sh

# Load devices Config
if [ "$device" = "abt_asr3000" ]; then
    curl -s $mirror/Mediatek/$source_branch/abt_asr3000.config > .config
elif [ "$device" = "cetron_ct3003" ]; then
    curl -s $mirror/Mediatek/$source_branch/abt_asr3000.config > .config
elif [ "$device" = "cmcc_a10" ]; then
    curl -s $mirror/Mediatek/$source_branch//cmcc_a10.config > .config
fi

# init openwrt config
make defconfig

# Compile
make -j$(nproc)
