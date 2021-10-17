#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default

echo "当前配置文件为$CONFIG_FILE"
echo "CONFIG_FILE_DEVICE=$(basename $CONFIG_FILE .config)" >>$GITHUB_ENV
echo "配置文件设备为$CONFIG_FILE_DEVICE"

echo "feeds.conf.default 增加 passwall"
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall" >>feeds.conf.default

echo "feeds.conf.default 增加 OpenClash"
echo "src-git OpenClash https://github.com/vernesong/OpenClash" >>feeds.conf.default
