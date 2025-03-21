#!/bin/bash

## golang 为 1.24.x
rm -rf feeds/packages/lang/golang/*
git clone https://github.com/sbwml/packages_lang_golang -b 24.x package/golang
cp -af package/golang/* feeds/packages/lang/golang/

# luci-app-adguardhome
git clone --depth=1 https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome

# luci-app-mosdns
rm -rf feeds/package/net/mosdns/*
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns -b v5-lua package/mosdns
git clone --depth=1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
cp -af package/mosdns/mosdns/* feeds/packages/net/mosdns/

./scripts/feeds update -a
./scripts/feeds install -a
