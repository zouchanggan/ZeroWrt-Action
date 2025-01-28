#!/bin/bash

# ZeroWrt选项菜单
mkdir -p files/bin
curl -L -o files/bin/ZeroWrt https://git.kejizero.online/zhao/files/raw/branch/main/bin/ZeroWrt
chmod +x files/bin/ZeroWrt
mkdir -p files/root
curl -L -o files/root/version.txt https://git.kejizero.online/zhao/files/raw/branch/main/bin/version.txt
chmod +x files/root/version.txt

# Adguardhome设置
mkdir -p files/etc
curl -L -o files/etc/AdGuardHome-dnslist.yaml https://git.kejizero.online/zhao/files/raw/branch/main/etc/AdGuardHome-dnslist.yaml
chmod +x files/etc/AdGuardHome-dnslist.yaml
curl -L -o files/etc/AdGuardHome-mosdns.yaml https://git.kejizero.online/zhao/files/raw/branch/main/etc/AdGuardHome-mosdns.yaml
chmod +x files/etc/AdGuardHome-mosdns.yaml
curl -L -o files/etc/AdGuardHome-dns.yaml https://git.kejizero.online/zhao/files/raw/branch/main/etc/AdGuardHome-dns.yaml
chmod +x files/etc/AdGuardHome-dns.yaml

# default_set
mkdir -p files/etc/config
curl -L -o files/etc/config/default_dhcp.conf https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/files/default_dhcp.conf
curl -L -o files/etc/config/default_mosdns https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/files/default_mosdns
curl -L -o files/etc/config/default_smartdns https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/files/default_smartdns
curl -L -o files/etc/config/default_AdGuardHome https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/files/default_AdGuardHome
curl -L -o files/etc/config/default_passwall https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/files/default_passwall
curl -L -o files/etc/config/default_openclash https://raw.githubusercontent.com/oppen321/ZeroWrt/refs/heads/master/files/default_openclash
chmod +x files/etc/config/default_dhcp.conf
chmod +x files/etc/config/default_mosdns
chmod +x files/etc/config/default_smartdns
chmod +x files/etc/config/default_AdGuardHome
chmod +x files/etc/config/default_passwall
chmod +x files/etc/config/default_openclash

sed -i '/exit 0/i \
# 禁用IPV6\n\
uci set dhcp.lan.ra="disabled"\n\
uci set dhcp.lan.dhcpv6="disabled"\n\
uci set dhcp.lan.ndp="disabled"\n\
uci set dhcp.@dnsmasq[0].filter_aaaa="1"\n\
uci set dhcp.@dnsmasq[0].min_cache_ttl="0"\n\
uci set dhcp.@dnsmasq[0].max_cache_ttl="0"\n\
uci commit dhcp\n\
/etc/init.d/dnsmasq restart\n\
# diagnostics\n\
uci set luci.diag.dns="www.qq.com"\n\
uci set luci.diag.ping="www.qq.com"\n\
uci set luci.diag.route="www.qq.com"\n\
uci commit luci\n\
# 设置主机名映射，解决安卓原生TV首次连不上网的问题\n\
uci add dhcp domain\n\
uci set "dhcp.@domain[-1].name=time.android.com"\n\
uci set "dhcp.@domain[-1].ip=203.107.6.88"\n\
uci commit dhcp\n\
# 设置所有网口可访问网页终端\n\
uci delete ttyd.@ttyd[0].interface\n\
# 设置所有网口可连接 SSH\n\
uci set dropbear.@dropbear[0].Interface=""\n\
uci commit\n\
# Docker换源\n\
uci add_list dockerd.globals.registry_mirrors="https://docker.m.daocloud.io"\n\
uci commit dockerd\n\
# Smartdns相关设置\n\
uci add smartdns server\n\
uci set smartdns.@server[0].enabled="1"\n\
uci set smartdns.@server[0].type="udp"\n\
uci set smartdns.@server[0].name="清华大学TUNA协会"\n\
uci set smartdns.@server[0].ip="101.6.6.6"\n\
uci set smartdns.@server[0].server_group="smartdns-China"\n\
uci set smartdns.@server[0].blacklist_ip="0"\n\
uci add smartdns server\n\
uci set smartdns.@server[1].enabled="1"\n\
uci set smartdns.@server[1].type="udp"\n\
uci set smartdns.@server[1].name="114"\n\
uci set smartdns.@server[1].ip="114.114.114.114"\n\
uci set smartdns.@server[1].server_group="smartdns-China"\n\
uci set smartdns.@server[1].blacklist_ip="0"\n\
uci set smartdns.@server[1].port="53"\n\
uci add smartdns server\n\
uci set smartdns.@server[2].enabled="1"\n\
uci set smartdns.@server[2].type="udp"\n\
uci set smartdns.@server[2].name="ail dns ipv4"\n\
uci set smartdns.@server[2].ip="223.5.5.5"\n\
uci set smartdns.@server[2].port="53"\n\
uci set smartdns.@server[2].server_group="smartdns-China"\n\
uci set smartdns.@server[2].blacklist_ip="0"\n\
uci add smartdns server\n\
uci set smartdns.@server[3].enabled="1"\n\
uci set smartdns.@server[3].name="Ali DNS"\n\
uci set smartdns.@server[3].ip="https://dns.alidns.com/dns-query"\n\
uci set smartdns.@server[3].type="https"\n\
uci set smartdns.@server[3].no_check_certificate="0"\n\
uci set smartdns.@server[3].server_group="smartdns-China"\n\
uci set smartdns.@server[3].blacklist_ip="0"\n\
uci add smartdns server\n\
uci set smartdns.@server[4].enabled="1"\n\
uci set smartdns.@server[4].name="360 Secure DNS"\n\
uci set smartdns.@server[4].type="https"\n\
uci set smartdns.@server[4].no_check_certificate="0"\n\
uci set smartdns.@server[4].server_group="smartdns-China"\n\
uci set smartdns.@server[4].blacklist_ip="0"\n\
uci set smartdns.@server[4].ip="https://doh.360.cn/dns-query"\n\
uci add smartdns server\n\
uci set smartdns.@server[5].enabled="1"\n\
uci set smartdns.@server[5].name="DNSPod Public DNS+"\n\
uci set smartdns.@server[5].ip="https://doh.pub/dns-query"\n\
uci set smartdns.@server[5].type="https"\n\
uci set smartdns.@server[5].no_check_certificate="0"\n\
uci set smartdns.@server[5].server_group="smartdns-China"\n\
uci set smartdns.@server[5].blacklist_ip="0"\n\
uci add smartdns server\n\
uci set smartdns.@server[6].enabled="1"\n\
uci set smartdns.@server[6].type="udp"\n\
uci set smartdns.@server[6].name="baidu dns"\n\
uci set smartdns.@server[6].ip="180.76.76.76"\n\
uci set smartdns.@server[6].port="53"\n\
uci set smartdns.@server[6].server_group="smartdns-China"\n\
uci set smartdns.@server[6].blacklist_ip="0"\n\
uci add smartdns server\n\
uci set smartdns.@server[7].enabled="1"\n\
uci set smartdns.@server[7].type="udp"\n\
uci set smartdns.@server[7].name="360dns"\n\
uci set smartdns.@server[7].ip="101.226.4.6"\n\
uci set smartdns.@server[7].port="53"\n\
uci set smartdns.@server[7].server_group="smartdns-China"\n\
uci set smartdns.@server[7].blacklist_ip="0"\n\
uci add smartdns server\n\
uci set smartdns.@server[8].enabled="1"\n\
uci set smartdns.@server[8].type="udp"\n\
uci set smartdns.@server[8].name="dnspod"\n\
uci set smartdns.@server[8].ip="119.29.29.29"\n\
uci set smartdns.@server[8].port="53"\n\
uci set smartdns.@server[8].blacklist_ip="0"\n\
uci set smartdns.@server[8].server_group="smartdns-China"\n\
uci add smartdns server\n\
uci set smartdns.@server[9].enabled="1"\n\
uci set smartdns.@server[9].name="Cloudflare-tls"\n\
uci set smartdns.@server[9].ip="1.1.1.1"\n\
uci set smartdns.@server[9].type="tls"\n\
uci set smartdns.@server[9].server_group="smartdns-Overseas"\n\
uci set smartdns.@server[9].exclude_default_group="0"\n\
uci set smartdns.@server[9].blacklist_ip="0"\n\
uci set smartdns.@server[9].no_check_certificate="0"\n\
uci set smartdns.@server[9].port="853"\n\
uci set smartdns.@server[9].spki_pin="GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg="\n\
uci add smartdns server\n\
uci set smartdns.@server[10].enabled="1"\n\
uci set smartdns.@server[10].name="Google_DNS-tls"\n\
uci set smartdns.@server[10].type="tls"\n\
uci set smartdns.@server[10].server_group="smartdns-Overseas"\n\
uci set smartdns.@server[10].exclude_default_group="0"\n\
uci set smartdns.@server[10].blacklist_ip="0"\n\
uci set smartdns.@server[10].no_check_certificate="0"\n\
uci set smartdns.@server[10].port="853"\n\
uci set smartdns.@server[10].ip="8.8.4.4"\n\
uci set smartdns.@server[10].spki_pin="r/fTokourI3+um9Rws4XrHG6fWEmHpZ8iWnOUjzwwjQ="\n\
uci add smartdns server\n\
uci set smartdns.@server[11].enabled="1"\n\
uci set smartdns.@server[11].name="Quad9-tls"\n\
uci set smartdns.@server[11].ip="9.9.9.9"\n\
uci set smartdns.@server[11].type="tls"\n\
uci set smartdns.@server[11].server_group="smartdns-Overseas"\n\
uci set smartdns.@server[11].exclude_default_group="0"\n\
uci set smartdns.@server[11].blacklist_ip="0"\n\
uci set smartdns.@server[11].no_check_certificate="0"\n\
uci set smartdns.@server[11].port="853"\n\
uci set smartdns.@server[11].spki_pin="lhFSxAyDlRXX8Kc0dxo46Bo5b4Qsnn5xco8fsj9G1F4="\n\
uci commit smartdns\n\
/etc/init.d/smartdns restart\n\
# Smartdns优化\n\
uci set smartdns.global.expire="600"\n\
uci set smartdns.global.cache_size="2048"\n\
uci set smartdns.global.dns_per_server="3"\n\
uci set smartdns.global.query_cache_size="512"\n\
uci set smartdns.global.domain_cache_size="256"\n\
uci commit smartdns\n\
# 重新启动相关服务\n\
/etc/init.d/network restart\n\
/etc/init.d/dnsmasq restart\n\
/etc/init.d/smartdns restart\n\
/etc/init.d/odhcpd restart\n\
exit 0
' package/lean/default-settings/files/zzz-default-settings
