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
    curl -s $mirror/Mediatek/$source_branch/cetron_ct3003.config > .config
elif [ "$device" = "cmcc_a10" ]; then
    curl -s $mirror/Mediatek/$source_branch/cmcc_a10.config > .config
elif [ "$device" = "cmcc_rax3000m_emmc" ]; then
    curl -s $mirror/Mediatek/$source_branch/cmcc_rax3000m_emmc.config > .config
elif [ "$device" = "cmcc_rax3000m_nand" ]; then
    curl -s $mirror/Mediatek/$source_branch/cmcc_rax3000m_nand.config > .config
elif [ "$device" = "gl_inet_gl_mt3000" ]; then    
    curl -s $mirror/Mediatek/$source_branch/gl_inet_gl_mt3000.config > .config
elif [ "$device" = "h3c_nx30pro" ]; then
    curl -s $mirror/Mediatek/$source_branch/h3c_nx30pro.config > .config
elif [ "$device" = "imou_lc_hx3001" ]; then
    curl -s $mirror/Mediatek/$source_branch/imou_lc_hx3001.config > .config
elif [ "$device" = "jcg_q30" ]; then   
    curl -s $mirror/Mediatek/$source_branch/jcg_q30.config > .config
elif [ "$device" = "konka_komi_a31" ]; then
    curl -s $mirror/Mediatek/$source_branch/konka_komi_a31.config > .config
elif [ "$device" = "livinet_zr_3020" ]; then 
    curl -s $mirror/Mediatek/$source_branch/livinet_zr_3020.config > .config
elif [ "$device" = "mediatek_360_t7" ]; then  
    curl -s $mirror/Mediatek/$source_branch/mediatek_360_t7.config > .config
elif [ "$device" = "mediatek_360_t7_108m_ubi" ]; then
    curl -s $mirror/Mediatek/$source_branch/mediatek_360_t7_108m_ubi.config > .config
elif [ "$device" = "mediatek_clt_r30b1" ]; then
    curl -s $mirror/Mediatek/$source_branch/mediatek_clt_r30b1.config > .config
elif [ "$device" = "mediatek_clt_r30b1_112m_ubi" ]; then
    curl -s $mirror/Mediatek/$source_branch/mediatek_clt_r30b1_112m_ubi.config > .config
elif [ "$device" = "xiaomi_mi_router_ax3000t" ]; then
    curl -s $mirror/Mediatek/$source_branch/xiaomi_mi_router_ax3000t.config > .config
elif [ "$device" = "xiaomi_mi_router_ax3000t_stock_layout" ]; then
    curl -s $mirror/Mediatek/$source_branch/xiaomi_mi_router_ax3000t_stock_layout.config > .config
elif [ "$device" = "xiaomi_mi_router_wr30u_stock_layout" ]; then
    curl -s $mirror/Mediatek/$source_branch/xiaomi_mi_router_wr30u_stock_layout.config > .config
elif [ "$device" = "xiaomi_mi_router_wr30u_112m_ubi_layout" ]; then
    curl -s $mirror/Mediatek/$source_branch/xiaomi_mi_router_wr30u_112m_ubi_layout.config > .config
elif [ "$device" = "gl_inet_gl_mt6000" ]; then
    curl -s $mirror/Mediatek/$source_branch/gl_inet_gl_mt6000.config > .config
elif [ "$device" = "tp_link_tl_xdr6086" ]; then
    curl -s $mirror/Mediatek/$source_branch/tp_link_tl_xdr6086.config > .config
elif [ "$device" = "tp_link_tl_xdr6088" ]; then
    curl -s $mirror/Mediatek/$source_branch/tp_link_tl_xdr6088.config > .config
elif [ "$device" = "xiaomi_redmi_router_ax6000" ]; then 
    curl -s $mirror/Mediatek/$source_branch/xiaomi_redmi_router_ax6000.config > .config
elif [ "$device" = "xiaomi_redmi_router_ax6000_stock_layout" ]; then
    curl -s $mirror/Mediatek/$source_branch/xiaomi_redmi_router_ax6000_stock_layout.config > .config
elif [ "$device" = "jdcloud_re_cp_03" ]; then
    curl -s $mirror/Mediatek/$source_branch/jdcloud_re_cp_03.config > .config
elif [ "$device" = "netcore_n60_pro" ]; then 
    curl -s $mirror/Mediatek/$source_branch/netcore_n60_pro.config > .config
elif [ "$device" = "netcore_n60" ]; then
    curl -s $mirror/Mediatek/$source_branch/netcore_n60.config > .config
fi

# Toolchain Cache
if [ "$source_branch" = "hanwckf_mt798x_v21.02" ]; then
    curl -O -L --progress-bar https://github.com/oppen321/openwrt_caches/releases/download/Hanwckf_MT798X_v21.02/toolchain_mediatek.tar.zst
elif [ "$source_branch" = "padavanonly_mt798x_v24.10" ]; then
    curl -O -L --progress-bar https://github.com/oppen321/openwrt_caches/releases/download/Padavanonly_MT798X_v24.10/toolchain_mediatek.tar.zst
fi    
tar -I "zstd" -xf toolchain_mediatek.tar.zst
rm -f toolchain_mediatek.tar.zst
mkdir bin
find ./staging_dir/ -name '*' -exec touch {} \; >/dev/null 2>&1
find ./tmp/ -name '*' -exec touch {} \; >/dev/null 2>&1

# init openwrt config
make defconfig

# Compile
make -j$(nproc)
