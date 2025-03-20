#!/bin/bash

# luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall/*
git clone --depth=1 https://github.com/oppen321/luci-app-passwall package/luci-app-passwall
cp -af package/luci-app-passwall/*  feeds/luci/applications/luci-app-passwall/

# luci-app-ssr-plus
rm -rf feeds/luci/applications/luci-app-ssr-plus/*
git clone --depth=1 https://github.com/oppen321/luci-app-ssr-plus package/luci-app-ssr-plus
cp -af package/luci-app-ssr-plus/*  feeds/luci/applications/luci-app-ssr-plus/

# luci-app-openclash
rm -rf feeds/luci/applications/luci-app-openclash/*
git clone --depth=1 https://github.com/oppen321/luci-app-openclash package/luci-app-openclash
cp -af package/luci-app-openclash/*  feeds/luci/applications/luci-app-openclash/

## golang 为 1.24.x
rm -rf feeds/packages/lang/golang/*
git clone https://github.com/sbwml/packages_lang_golang -b 24.x packages/golang
cp -af packages/golang/* feeds/packages/lang/golang/

# luci-app-adguardhome
git clone --depth=1 https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome

