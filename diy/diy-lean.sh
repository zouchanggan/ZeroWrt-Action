#!/bin/bash

# 修改默认IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/luci2/bin/config_generate

##更改主机名
sed -i "s/hostname='.*'/hostname='ZeroWrt'/g" package/base-files/files/bin/config_generate
sed -i "s/hostname='.*'/hostname='ZeroWrt'/g" package/base-files/luci2/bin/config_generate

# banner
cp -f $GITHUB_WORKSPACE/diy/banner  package/base-files/files/etc/banner

# 更换内核
# sed -i 's/6.6/6.12/g' target/linux/x86/Makefile

# 补充汉化
echo -e "\nmsgid \"VPN\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"魔法网络\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "\nmsgid \"VPN\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"魔法网络\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po

## golang 为 1.23.x
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

# Zero-package
git clone --depth=1 https://github.com/oppen321/Zero-package package/Zero-package
sed -i 's/iStoreOS/ZeroWrt/' package/Zero-package/istoreos-files/files/etc/board.d/10_system

# Lucky
rm -rf feeds/luci/applications/luci-app-lucky
rm -rf feeds/packages/net/lucky
git clone https://github.com/gdy666/luci-app-lucky.git package/lucky

# theme
rm -rf feeds/luci/themes/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

# OpenAppFilter
git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter

# 替换default-settings
rm -rf package/lean/default-settings/files/zzz-default-settings
curl -L -o package/lean/default-settings/files/zzz-default-settings https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/lean/files/zzz-default-settings
chmod +x package/lean/default-settings/files/zzz-default-settings

# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by OPPPEN321/g" package/lean/default-settings/files/zzz-default-settings
