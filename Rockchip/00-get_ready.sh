#!/bin/bash

# 定义一个函数，用来克隆指定的仓库和分支
clone_repo() {
  # 参数1是仓库地址，参数2是分支名，参数3是目标目录
  repo_url=$1
  branch_name=$2
  target_dir=$3
  # 克隆仓库到目标目录，并指定分支名和深度为1
  git clone -b $branch_name --depth 1 $repo_url $target_dir
}

# 定义一些变量，存储仓库地址和分支名
immortalwrt_repo="https://github.com/coolsnowwolf/lede.git"
openwrt_repo="https://github.com/openwrt/openwrt.git"

# 开始克隆仓库，并行执行
clone_repo $immortalwrt_repo openwrt-24.10 immortalwrt &
clone_repo $openwrt_repo openwrt-24.10 openwrt &
# 等待所有后台任务完成
wait

# make olddefconfig
wget -qO - https://raw.githubusercontent.com/oppen321/ZeroWrt-Action/refs/heads/master/patch/linux/0003-include-kernel-defaults.mk.patch | patch -p1

# 进行一些处理
rm -rf openwrt/target/linux/rockchip
rm -rf package/boot/{rkbin,uboot-rockchip,arm-trusted-firmware-rockchip}
cp -rf immortalwrt/target/linux/rockchip openwrt/target/linux/rockchip
cp -rf patch/kernel/rockchip/* openwrt/target/linux/rockchip/patches-6.6/
cp -rf immortalwrt/package/boot/uboot-rockchip openwrt/package/boot/uboot-rockchip
cp -rf immortalwrt/package/boot/arm-trusted-firmware-rockchip openwrt/package/boot/arm-trusted-firmware-rockchip
sed -i '/REQUIRE_IMAGE_METADATA/d' openwrt/target/linux/rockchip/armv8/base-files/lib/upgrade/platform.sh

curl -o openwrt/include/kernel-6.6 https://raw.githubusercontent.com/immortalwrt/immortalwrt/refs/heads/openwrt-24.10/include/kernel-6.6

sed -i '/REQUIRE_IMAGE_METADATA/d' target/linux/rockchip/armv8/base-files/lib/upgrade/platform.sh
sed -i -e 's,kmod-r8168,kmod-r8169,g' openwrt/target/linux/rockchip/image/armv8.mk



