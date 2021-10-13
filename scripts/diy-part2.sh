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

echo "修改hostname为$DEVICE_NAME"
sed -i "s/OpenWrt/$DEVICE_NAME/g" package/base-files/files/bin/config_generate

echo "修改ssid为$DEVICE_NAME"
sed -i "s/OpenWrt/$DEVICE_NAME/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh

echo '替换argon主题'
rm -rf package/lean/luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git package/lean/luci-app-argon-config

echo '默认使用argon主题'
sed -i "s/bootstrap/argon/g" feeds/luci/modules/luci-base/root/etc/config/luci

echo '新增OpenClash'
git clone --depth=1 https://github.com/vernesong/OpenClash.git package/lean/luci-app-openclash
