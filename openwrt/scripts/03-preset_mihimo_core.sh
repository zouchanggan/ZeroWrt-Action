#!/bin/bash

# 创建 OpenClash 核心目录（若不存在则自动创建）
mkdir -p files/etc/openclash/core

# 根据平台设置 core 架构
if [ "$platform" = "rockchip" ]; then
    core="arm64"
elif [ "$platform" = "x86_64" ]; then
    core="amd64"
fi

# 根据 mihomo_core 类型选择下载链接
if [ "$mihomo_core" = "meta" ]; then
    CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-$core.tar.gz"
elif [ "$mihomo_core" = "smart" ]; then
    CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/smart/clash-linux-$core.tar.gz"
fi
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"

# 下载并解压 Clash Meta 内核，输出为 clash_meta 可执行文件
wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta

# 下载 GeoIP 数据库（IP 地址归属地信息）
wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat

# 下载 GeoSite 数据库（常用域名分类信息）
wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat

# 赋予 Clash 核心文件可执行权限
chmod +x files/etc/openclash/core/clash*
