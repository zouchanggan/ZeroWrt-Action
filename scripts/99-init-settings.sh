#!/bin/bash

# Set default theme to luci-theme-argon
uci set luci.main.mediaurlbase='/luci-static/kucat'
uci commit luci

# Set NTP
uci -q batch <<-EOF
	set system.@system[0].timezone='CST-8'
	set system.@system[0].zonename='Asia/Shanghai'

	delete system.ntp.server
	add_list system.ntp.server='ntp1.aliyun.com'
	add_list system.ntp.server='ntp.tencent.com'
	add_list system.ntp.server='ntp.ntsc.ac.cn'
	add_list system.ntp.server='time.apple.com'
EOF
uci commit system

# Set password
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow

# Set diagnostics
uci set luci.diag.dns='www.qq.com'
uci set luci.diag.ping='www.qq.com'
uci set luci.diag.route='www.qq.com'
uci commit luci

# Set up hostname mapping
uci add dhcp domain
uci set "dhcp.@domain[-1].name=time.android.com"
uci set "dhcp.@domain[-1].ip=203.107.6.88"
uci commit dhcp

# Set SSH
uci delete ttyd.@ttyd[0].interface
uci set dropbear.@dropbear[0].Interface=''
uci commit

# Set zram
mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
zram_size=$(echo | awk "{print int($mem_total*0.25/1024)}")
uci set system.@system[0].zram_size_mb="$zram_size"
uci set system.@system[0].zram_comp_algo='zstd'
uci commit system

# Set distfeeds.conf
if [ $(grep -c SNAPSHOT /etc/opkg/distfeeds.conf) -eq '0' ]; then
    sed -i 's,downloads.openwrt.org,mirrors.aliyun.com/openwrt,g' /etc/opkg/distfeeds.conf
else
    sed -i 's,downloads.openwrt.org,mirror.sjtu.edu.cn/openwrt,g' /etc/opkg/distfeeds.conf
fi

# Disable IPV6 ula prefix
# sed -i 's/^[^#].*option ula/#&/' /etc/config/network

# Check file system during boot
# uci set fstab.@global[0].check_fs=1
# uci commit fstab

exit 0
