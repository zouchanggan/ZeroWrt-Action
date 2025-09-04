#!/bin/bash

# 根据平台设置 core 架构
if [ "$platform" = "rockchip" ]; then
    core="arm64"
elif [ "$platform" = "x86_64" ]; then
    core="amd64"
fi

mkdir -p files/usr/bin

AGH_CORE=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep /AdGuardHome_linux_$core | awk -F '"' '{print $4}')

wget -qO- $AGH_CORE | tar xOvz > files/usr/bin/AdGuardHome

chmod +x files/usr/bin/AdGuardHome
