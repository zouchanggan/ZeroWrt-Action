#!/bin/bash -e

# github actions - caddy server
export mirror=http://127.0.0.1:8080

# Clone source code
git clone -b openwrt-24.10 --single-branch --filter=blob:none https://github.com/immortalwrt/immortalwrt openwrt

# Enter source code
cd openwrt

# Init feeds
./scripts/feeds update -a
./scripts/feeds install -a

# lan
[ -n "$LAN" ] && export LAN=$LAN || export LAN=10.0.0.1

# scripts
curl -sO $mirror/Rockchip/00-prepare_base.sh
curl -sO $mirror/Rockchip/01-prepare_package.sh
chmod 0755 00-prepare_base.sh
chmod 0755 01-prepare_package.sh
bash 00-prepare_base.sh
bash 01-prepare_package.sh

# Load devices Config
curl -s $mirror/Rockchip/rockchip.config > .config

# gcc15 patches
curl -s $mirror/patch/GCC/202-toolchain-gcc-add-support-for-GCC-15.patch | patch -p1

# gcc config
echo -e "\n# gcc ${gcc_version}" >> .config
echo -e "CONFIG_DEVEL=y" >> .config
echo -e "CONFIG_TOOLCHAINOPTS=y" >> .config
echo -e "CONFIG_GCC_USE_VERSION_${gcc_version}=y\n" >> .config

# gcc14 & 15
if [ "$gcc_version" = "GCC_13" ] || [ "$OPTIONS_MENU" = "y" ]; then
    curl -O -L --progress-bar https://github.com/oppen321/openwrt_caches/releases/download/OpenWrt_Toolchain_Cache/toolchain_musl_immortalwrt_rockchip_gcc-13.tar.zst
elif [ "$gcc_version" = "GCC_14" ] || [ "$OPTIONS_MENU" = "y" ]; then
    curl -O -L --progress-bar https://github.com/oppen321/openwrt_caches/releases/download/OpenWrt_Toolchain_Cache/toolchain_musl_immortalwrt_rockchip_gcc-14.tar.zst
elif [ "$gcc_version" = "GCC_15" ] || [ "$OPTIONS_MENU" = "y" ]; then
    curl -O -L --progress-bar https://github.com/oppen321/openwrt_caches/releases/download/OpenWrt_Toolchain_Cache/toolchain_musl_immortalwrt_rockchip_gcc-15.tar.zst
fi

# Options menu
if [ "$OPTIONS_MENU" = "y" ]; then
    echo "Options menu (Loading the ZeroWrt options menu)"
    mkdir -p files/bin
    mkdir -p files/root
    curl -s $mirror/Mediatek/files/bin/ZeroWrt > files/bin/ZeroWrt
    curl -s $mirror/Mediatek/files/root/version.txt > files/root/version.txt
    chmod +x files/bin/ZeroWrt
    chmod +x files/root/version.txt
else
    echo "Do not load ZeroWrt" 
fi

# init openwrt config
make defconfig

# Compile
make -j$(nproc)
