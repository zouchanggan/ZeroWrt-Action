#!/bin/bash

# 修改默认IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# 更改 Argon 主题背景
cp -f $GITHUB_WORKSPACE/images/bg1.jpg feeds/theme/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
sed -i "s/option online_wallpaper 'bing'/option online_wallpaper 'none'/g" feeds/luci/applications/luci-app-argon-config/root/etc/config/argon
