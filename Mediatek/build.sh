#!/bin/bash -e

# github actions - caddy server
export mirror=http://127.0.0.1:8080

# Clone source code
source_branch=${{ github.event.inputs.source_branch }}
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
bash 00-prepare_base.sh
bash 02-prepare_package.sh
chmod 0755 *sh

# Load devices Config
device
case "$device" in
    "abt_asr3000")
        curl -L -o .config $mirror/Mediatek/$source_branch/abt_asr3000.config
        ;;
    "cetron_ct3003")
        curl -L -o .config $mirror/Mediatek/$source_branch/cetron_ct3003.config
        ;;
    "cmcc_a10")
        curl -L -o .config $mirror/Mediatek/$source_branch/cmcc_a10.config
        ;;
    "cmcc_rax3000m_emmc")
        curl -L -o .config $mirror/Mediatek/$source_branch/cmcc_rax3000m_emmc.config
        ;;
    "cmcc_rax3000m_nand")
        curl -L -o .config $mirror/Mediatek/$source_branch/cmcc_rax3000m_nand.config
        ;;
    "gl_inet_gl_mt3000")
        curl -L -o .config $mirror/Mediatek/$source_branch/gl_inet_gl_mt3000.config
        ;;        
    *)
        echo "Unknown device: $device"
        exit 1
        ;;
esac

# Compile
make -j$(nproc)
