#!/bin/bash

## golang 为 1.24.x
rm -rf feeds/packages/lang/golang/*
git clone https://github.com/sbwml/packages_lang_golang -b 24.x package/golang
cp -af package/golang/* feeds/packages/lang/golang/

# luci-app-adguardhome
git clone --depth=1 https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome

# xray-core
rm -rf feeds/packages/net/xray-core/*
git clone --depth=1 https://github.com/oppen321/xray-core package/xray-core
cp -af package/xray-core/*  feeds/packages/net/xray-core/

# luci-app-mosdns
rm -rf feeds/package/net/mosdns/*
rm -rf feeds/package/net/v2ray-geodata/*
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns -b v5-lua package/mosdns
git clone --depth=1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
cp -af package/mosdns/mosdns/* feeds/packages/net/mosdns/
cp -af package/v2ray-geodata/* feeds/packages/net/v2ray-geodata/

./scripts/feeds update -a
./scripts/feeds install -a
