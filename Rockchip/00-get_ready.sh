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
lede_repo="https://github.com/coolsnowwolf/lede.git"
openwrt_repo="https://github.com/openwrt/openwrt.git"

# 开始克隆仓库，并行执行
clone_repo $lede_repo master lean &
clone_repo $openwrt_repo openwrt-24.10 openwrt &
# 等待所有后台任务完成
wait

# 进行一些处理
