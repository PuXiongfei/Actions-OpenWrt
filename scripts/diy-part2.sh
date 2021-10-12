#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
echo '修改默认IP为192.168.26.26'
sed -i 's/192.168.1.1/192.168.26.26/g' package/base-files/files/bin/config_generate

echo "修改hostname"
sed -i "s/OpenWrt/$DEVICE_NAME/g" package/base-files/files/bin/config_generate

echo "修改ssid"
sed -i "s/OpenWrt/$DEVICE_NAME/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh

echo '默认使用argon主题'
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git
ls -la
echo 'ls -la ../lean/luci-theme-argon'
ls -la ../lean/luci-theme-argon
rm -rf ../lean/luci-theme-argon
sed -i "s/bootstrap/argon/g" feeds/luci/modules/luci-base/root/etc/config/luci