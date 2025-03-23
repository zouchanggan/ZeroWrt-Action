#!/bin/bash -e

# github actions - caddy server
export mirror=http://127.0.0.1:8080

# Clone source code
git clone -b openwrt-24.10 --single-branch --filter=blob:none https://github.com/openwrt/openwrt

# Enter source code
cd openwrt

# Init feeds
./scripts/feeds update -a
./scripts/feeds install -a

# Load core
case "$Load_core" in
    "AdGuardhome")
        mkdir -p files/usr/bin/AdGuardHome
        AGH_CORE=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep /AdGuardHome_linux_arm64 | awk -F '"' '{print $4}')
        curl -sL "$AGH_CORE" | tar xOvz > files/usr/bin/AdGuardHome/AdGuardHome
        chmod +x files/usr/bin/AdGuardHome/AdGuardHome
        ;;
    "Meta")
        mkdir -p files/etc/openclash/core
        CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
        GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
        GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
        wget -qO- "$CLASH_META_URL" | tar xOvz > files/etc/openclash/core/clash_meta
        wget -qO- "$GEOIP_URL" > files/etc/openclash/GeoIP.dat
        wget -qO- "$GEOSITE_URL" > files/etc/openclash/GeoSite.dat
        chmod +x files/etc/openclash/core/clash*
        ;;
    "All")
        # AdGuardHome
        mkdir -p files/usr/bin/AdGuardHome
        AGH_CORE=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep /AdGuardHome_linux_arm64 | awk -F '"' '{print $4}')
        curl -sL "$AGH_CORE" | tar xOvz > files/usr/bin/AdGuardHome/AdGuardHome
        chmod +x files/usr/bin/AdGuardHome/AdGuardHome

        # Clash Meta
        mkdir -p files/etc/openclash/core
        CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
        GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
        GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
        wget -qO- "$CLASH_META_URL" | tar xOvz > files/etc/openclash/core/clash_meta
        wget -qO- "$GEOIP_URL" > files/etc/openclash/GeoIP.dat
        wget -qO- "$GEOSITE_URL" > files/etc/openclash/GeoSite.dat
        chmod +x files/etc/openclash/core/clash*
        ;;
    "None")
        # 不执行任何操作
        ;;
esac


# lan
[ -n "$LAN" ] && export LAN=$LAN || export LAN=10.0.0.1

# scripts
curl -sO $mirror/Rockchip/00-prepare_base.sh
curl -sO $mirror/Rockchip/01-prepare_package.sh
curl -sO $mirror/Rockchip/02-convert_translation.sh
curl -sO $mirror/Rockchip/03-remove_upx.sh
curl -sO $mirror/Rockchip/04-create_acl_for_luci.sh
chmod 0755 00-prepare_base.sh
chmod 0755 01-prepare_package.sh
chmod 0755 02-convert_translation.sh
chmod 0755 03-remove_upx.sh
chmod 0755 04-create_acl_for_luci.sh
bash 00-prepare_base.sh
bash 01-prepare_package.sh
bash 02-convert_translation.sh
bash 03-remove_upx.sh
bash 04-create_acl_for_luci.sh

# Load devices Config
curl -s $mirror/Rockchip/rockchip.config > .config

# gcc14 & 15
if [ "$USE_GCC13" = y ]; then
    export USE_GCC13=y gcc_version=13
elif [ "$USE_GCC14" = y ]; then
    export USE_GCC14=y gcc_version=14
fi

# gcc config
echo -e "\n# gcc $gcc_version" >> .config
echo -e "CONFIG_DEVEL=y" >> .config
echo -e "CONFIG_TOOLCHAINOPTS=y" >> .config
echo -e "CONFIG_GCC_USE_VERSION_$gcc_version=y\n" >> .config

# Toolchain Cache
if [ "$ENABLE_CCACHE" = "y" ]; then
    echo "Cache is enabled. Downloading and setting up toolchain cache..."    

    # 选择对应的 GCC 版本工具链
    case "$gcc_version" in
        "GCC_13") file="toolchain_musl_openwrt_rockchip_gcc-13.tar.zst" ;;
        "GCC_14") file="toolchain_musl_openwrt_rockchip_gcc-14.tar.zst" ;;
        *)
            echo "Unknown GCC version: $gcc_version"
            exit 1
            ;;
    esac    

    # 下载并解压
    curl -O -L --fail --progress-bar "https://github.com/oppen321/openwrt_caches/releases/download/OpenWrt_Toolchain_Cache/$file" || {
        echo "Download failed for $file"
        exit 1
    }

    tar -I "zstd" -xf "$file" || {
        echo "Extraction failed for $file"
        exit 1
    }

    rm -f "$file"

    # 统一处理 bin 目录和缓存
    mkdir -p bin
    find ./staging_dir/ ./tmp/ -type f -exec touch {} \; >/dev/null 2>&1
else
    echo "Cache is disabled. Skipping toolchain cache setup."
fi
   
# Options menu
if [ "$OPTIONS_MENU" = "y" ]; then
    echo "Options menu (Loading the ZeroWrt options menu)"
    mkdir -p files/bin
    mkdir -p files/root
    curl -s $mirror/Rockchip/files/bin/ZeroWrt > files/bin/ZeroWrt
    curl -s $mirror/Rockchip/files/root/version.txt > files/root/version.txt
    chmod +x files/bin/ZeroWrt
    chmod +x files/root/version.txt
else
    echo "Do not load ZeroWrt" 
fi

# init openwrt config
make defconfig

# Compile
make -j$(nproc)
