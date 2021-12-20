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
echo "修改默认IP为192.168.26.26"
sed -i 's/192.168.1.1/192.168.26.26/g' package/base-files/files/bin/config_generate
sed -n '/192.168./p' package/base-files/files/bin/config_generate

echo "修改hostname为$CONFIG_FILE_DEVICE"
sed -i "s|OpenWrt|$CONFIG_FILE_DEVICE|g" package/base-files/files/bin/config_generate
sed -n '/.hostname=/p' package/base-files/files/bin/config_generate

echo "修改ssid为$CONFIG_FILE_DEVICE"
sed -i "s|OpenWrt|$CONFIG_FILE_DEVICE|g" package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -n '/.ssid=/p' package/kernel/mac80211/files/lib/wifi/mac80211.sh

echo "修改country为CN"
sed -i 's/US$/CN/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -n '/.country=/p' package/kernel/mac80211/files/lib/wifi/mac80211.sh

echo "修改luci-theme-bootstrap为luci-theme-argon"
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -n '/luci-theme-/p' feeds/luci/collections/luci/Makefile

echo "删除 lean/luci-theme-argon"
rm -rf package/lean/luci-theme-argon

echo "增加 jerrykuku/luci-theme-argon"
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon

echo "增加 jerrykuku/luci-app-argon-config"
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

echo "增加 xiaorouji/openwrt-passwall"
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall package/openwrt-passwall

echo "增加 vernesong/luci-app-openclash"
git clone --depth 1 https://github.com/vernesong/OpenClash package/OpenClash

echo "增加 Lienol/luci-app-socat"
git clone --depth 1 https://github.com/Lienol/openwrt-package Lienol/openwrt-package && cp -af Lienol/openwrt-package/luci-app-socat package

echo "修改DEFAULT_PACKAGES"
sed -n '/DEFAULT_PACKAGES.router/,/^ifneq/p' include/target.mk
sed -i '/DEFAULT_PACKAGES.router/,/^ifneq/{s/luci-app-autoreboot//g;s/luci-app-unblockmusic//g;s/luci-app-ramfree//g;s/luci-app-accesscontrol//g}' include/target.mk
sed -i '/DEFAULT_PACKAGES.router/a\ automount ipv6helper ddns-scripts_cloudflare.com-v4 luci-app-argon-config luci-app-diskman luci-app-easymesh luci-app-hd-idle luci-app-pushbot luci-app-samba4 luci-app-socat luci-app-ttyd luci-app-udpxy luci-app-webadmin luci-app-zerotier \\' include/target.mk
sed -n '/DEFAULT_PACKAGES.router/,/^ifneq/p' include/target.mk

if [ "$CONFIG_FILE_DEVICE" = "D2" ]; then
    echo "修改$CONFIG_FILE_DEVICE的DEVICE_PACKAGES"
    sed -n '/d-team_newifi-d2$/,/d-team_newifi-d2$/p' target/linux/ramips/image/mt7621.mk
    sed -i '/d-team_newifi-d2$/,/d-team_newifi-d2$/{s/kmod-mt7603e/kmod-mt7603/g;s/kmod-mt76x2e/kmod-mt76x2/g;s/luci-app-mtwifi//g;s/-wpad-openssl//g;s/\\/luci-app-passwall \\/g}' target/linux/ramips/image/mt7621.mk
    sed -n '/d-team_newifi-d2$/,/d-team_newifi-d2$/p' target/linux/ramips/image/mt7621.mk
    echo "修改passwall默认值"
    sed -i '/"Include Haproxy"/,/^config/{s/arm/arm||mips||mipsel/g}' package/luci-app-passwall/Makefile
    sed -i '/"Include V2ray"/,/^config/{s/arm/arm||mips||mipsel/g}' package/luci-app-passwall/Makefile
    sed -i '/"Include V2ray-Plugin/,/^config/{s/arm/arm||mips||mipsel/g}' package/luci-app-passwall/Makefile
    sed -i '/"Include Xray"/,/^endmenu/{s/arm/arm||mips||mipsel/g}' package/luci-app-passwall/Makefile
    cat package/lean/luci-app-passwall/Makefile
fi
if [ "$CONFIG_FILE_DEVICE" = "K3" ]; then
    echo "删除 lean/k3screenctrl"
    rm -rf package/lean/k3screenctrl

    echo "删除 lean/luci-app-k3screenctrl"
    rm -rf package/lean/luci-app-k3screenctrl

    echo "删除 lean/k3screenctrl_build"
    rm -rf package/lean/k3screenctrl_build

    echo "增加 lwz322/k3screenctrl"
    git clone --depth=1 https://github.com/lwz322/k3screenctrl package/k3screenctrl

    cho "增加 lwz322/luci-app-k3screenctrl"
    git clone --depth=1 https://github.com/lwz322/luci-app-k3screenctrl package/luci-app-k3screenctrl

    cho "增加 lwz322/k3screenctrl_build"
    git clone --depth=1 https://github.com/lwz322/k3screenctrl_build package/k3screenctrl_build

    echo "替换brcmfmac4366c-pcie.bin"
    md5sum $GITHUB_WORKSPACE/config/brcmfmac4366c-pcie_3.0.0.4.386.45898.bin
    cp -af $GITHUB_WORKSPACE/config/brcmfmac4366c-pcie_3.0.0.4.386.45898.bin package/lean/k3-brcmfmac4366c-firmware/files/lib/firmware/brcm/brcmfmac4366c-pcie.bin
    md5sum package/lean/k3-brcmfmac4366c-firmware/files/lib/firmware/brcm/brcmfmac4366c-pcie.bin
    echo "修改$CONFIG_FILE_DEVICE的DEVICE_PACKAGES"
    sed -n '/phicomm_k3$/,/phicomm_k3$/p' target/linux/bcm53xx/image/Makefile
    sed -i '/phicomm_k3$/,/phicomm_k3$/{/DEVICE_PACKAGES/s/$/& luci-app-k3screenctrl autocore-arm luci-app-rclone luci-app-openclash luci-app-passwall luci-app-aria2/g}' target/linux/bcm53xx/image/Makefile
    sed -n '/phicomm_k3$/,/phicomm_k3$/p' target/linux/bcm53xx/image/Makefile
    echo "修改Makefile只编译K3"
    sed -i 's|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += phicomm_k3|TARGET_DEVICES += phicomm_k3|' target/linux/bcm53xx/image/Makefile
    echo "修改02_network"
    sed -n '/phicomm,k3)/,/;;/p' target/linux/bcm53xx/base-files/etc/board.d/02_network
    sed -i '/phicomm,k3)/,/;;/{s/"0:lan" "1:lan"/"0:lan:1" "1:lan:0"/g}' target/linux/bcm53xx/base-files/etc/board.d/02_network
    sed -n '/phicomm,k3)/,/;;/p' target/linux/bcm53xx/base-files/etc/board.d/02_network
fi
if [ "$CONFIG_FILE_DEVICE" = "R3G" ]; then
    echo "修改$CONFIG_FILE_DEVICE的DEVICE_PACKAGES"
    sed -n '/xiaomi_mi-router-3g$/,/xiaomi_mi-router-3g$/p' target/linux/ramips/image/mt7621.mk
    sed -i '/xiaomi_mi-router-3g$/,/xiaomi_mi-router-3g$/{s/\\/luci-app-rclone luci-app-openclash luci-app-passwall luci-app-aria2 \\/g}' target/linux/ramips/image/mt7621.mk
    sed -n '/xiaomi_mi-router-3g$/,/xiaomi_mi-router-3g$/p' target/linux/ramips/image/mt7621.mk
    echo "修改passwall默认值"
    sed -i '/"Include Haproxy"/,/^config/{s/arm/arm||mips||mipsel/g}' package/luci-app-passwall/Makefile
    sed -i '/"Include V2ray"/,/^config/{s/arm/arm||mips||mipsel/g}' package/luci-app-passwall/Makefile
    sed -i '/"Include V2ray-Plugin/,/^config/{s/arm/arm||mips||mipsel/g}' package/luci-app-passwall/Makefile
    sed -i '/"Include Xray"/,/^endmenu/{s/arm/arm||mips||mipsel/g}' package/luci-app-passwall/Makefile
    cat package/lean/luci-app-passwall/Makefile
    if [ -e $GITHUB_WORKSPACE/config/R3G_switch.patch ]; then
        echo "R3G_switch.patch"
        cat $GITHUB_WORKSPACE/config/R3G_switch.patch
        echo "应用R3G_switch.patch"
        git apply $GITHUB_WORKSPACE/config/R3G_switch.patch
        echo "mt7621_xiaomi_mi-router-3g.dts"
        cat target/linux/ramips/dts/mt7621_xiaomi_mi-router-3g.dts
        echo "02_network"
        cat target/linux/ramips/mt7621/base-files/etc/board.d/02_network
    fi
fi
