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

echo '修改hostname为${DEVICE_NAME}'
sed -i 's/OpenWrt/$DEVICE_NAME/g' package/base-files/files/bin/config_generate

echo '修改ssid为${DEVICE_NAME}'
sed -i 's/OpenWrt/$DEVICE_NAME/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

echo '默认使用argon主题'
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

echo '替换argon主题'
rm -rf package/lean/luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon
rm -rf package/lean/luci-app-argon-config
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git package/lean/luci-app-argon-config

echo '修改DEFAULT_PACKAGES'
sed -i 's/luci-app-autoreboot//g;s/luci-app-unblockmusic//g;s/luci-app-ramfree//g;s/luci-app-accesscontrol//g' include/target.mk
sed -i '/DEFAULT_PACKAGES.router/a\ automount ipv6helper ddns-scripts_cloudflare.com-v4 luci-app-argon-config luci-app-aria2 luci-app-diskman luci-app-hd-idle luci-app-pushbot luci-app-samba4 luci-app-udpxy luci-app-zerotier \\' include/target.mk

if [[ $DEVICE_NAME=D2 ]]; then
    echo '修改passwall默认值'
    sed -n '/Include Haproxy/,/^config/p' feeds/passwall/luci-app-passwall/Makefile
    sed -i '/Include Haproxy/,/^config/{s/arm/arm||mips||mipsel/g}' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include Haproxy/,/^config/p' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include Xray/,/^endmenu/p' feeds/passwall/luci-app-passwall/Makefile
    sed -i '/Include Xray/,/^endmenu/{s/arm/arm||mips||mipsel/g}' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include Xray/,/^endmenu/p' feeds/passwall/luci-app-passwall/Makefile
    echo '修改D2的DEVICE_PACKAGES'
    sed -n '/d-team_newifi-d2$/,/d-team_newifi-d2$/p' target/linux/ramips/image/mt7621.mk
    sed -i '/d-team_newifi-d2$/,/d-team_newifi-d2$/{s/kmod-mt7603e/kmod-mt7603/g;s/kmod-mt76x2e/kmod-mt76x2/g;s/luci-app-mtwifi//g;s/-wpad-openssl//g;s/\\/luci-app-passwall \\/g}' target/linux/ramips/image/mt7621.mk
    sed -n '/d-team_newifi-d2$/,/d-team_newifi-d2$/p' target/linux/ramips/image/mt7621.mk
elif [[ $DEVICE_NAME=K3 ]]; then
    echo '修改passwall默认值'
    sed -n '/Include Haproxy/,/^config/p' feeds/passwall/luci-app-passwall/Makefile
    sed -i '/Include Haproxy/,/^config/{s/arm/arm||mips||mipsel/g}' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include Haproxy/,/^config/p' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include V2ray/,/^config/p' feeds/passwall/luci-app-passwall/Makefile
    sed -i '/Include V2ray/,/^config/{s/arm/arm||mips||mipsel/g}' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include V2ray/,/^config/p' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include V2ray-Plugin/,/^config/p' feeds/passwall/luci-app-passwall/Makefile
    sed -i '/Include V2ray-Plugin/,/^config/{s/arm/arm||mips||mipsel/g}' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include V2ray-Plugin/,/^config/p' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include Xray/,/^endmenu/p' feeds/passwall/luci-app-passwall/Makefile
    sed -i '/Include Xray/,/^endmenu/{s/arm/arm||mips||mipsel/g}' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include Xray/,/^endmenu/p' feeds/passwall/luci-app-passwall/Makefile
    echo '修改K3的DEVICE_PACKAGES'
    sed -n '/phicomm_k3$/,/phicomm_k3$/p' target/linux/bcm53xx/image/Makefile
    sed -i '/phicomm_k3$/,/phicomm_k3$/{/DEVICE_PACKAGES/s/$/& autocore-arm luci-app-rclone luci-app-openclash luci-app-passwall/g}' target/linux/bcm53xx/image/Makefile
    sed -n '/phicomm_k3$/,/phicomm_k3$/p' target/linux/bcm53xx/image/Makefile
elif [[ $DEVICE_NAME=R3G ]]; then
    echo '修改passwall默认值'
    sed -n '/Include Haproxy/,/^config/p' feeds/passwall/luci-app-passwall/Makefile
    sed -i '/Include Haproxy/,/^config/{s/arm/arm||mips||mipsel/g}' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include Haproxy/,/^config/p' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include V2ray/,/^config/p' feeds/passwall/luci-app-passwall/Makefile
    sed -i '/Include V2ray/,/^config/{s/arm/arm||mips||mipsel/g}' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include V2ray/,/^config/p' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include V2ray-Plugin/,/^config/p' feeds/passwall/luci-app-passwall/Makefile
    sed -i '/Include V2ray-Plugin/,/^config/{s/arm/arm||mips||mipsel/g}' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include V2ray-Plugin/,/^config/p' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include Xray/,/^endmenu/p' feeds/passwall/luci-app-passwall/Makefile
    sed -i '/Include Xray/,/^endmenu/{s/arm/arm||mips||mipsel/g}' feeds/passwall/luci-app-passwall/Makefile
    sed -n '/Include Xray/,/^endmenu/p' feeds/passwall/luci-app-passwall/Makefile
    echo '修改R3G的DEVICE_PACKAGES'
    sed -n '/xiaomi_mi-router-3g$/,/xiaomi_mi-router-3g$/p' target/linux/ramips/image/mt7621.mk
    sed -i '/xiaomi_mi-router-3g$/,/xiaomi_mi-router-3g$/{s/\\/luci-app-rclone luci-app-openclash luci-app-passwall \\/g}' target/linux/ramips/image/mt7621.mk
    sed -n '/xiaomi_mi-router-3g$/,/xiaomi_mi-router-3g$/p' target/linux/ramips/image/mt7621.mk
fi
