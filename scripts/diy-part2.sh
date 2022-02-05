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

echo "修改/etc/firewall.user"
sed -n '/>> \/etc\/firewall.user$/p' package/lean/default-settings/files/zzz-default-settings
sed -i '/>> \/etc\/firewall.user$/{s/^/# /}' package/lean/default-settings/files/zzz-default-settings
sed -n '/>> \/etc\/firewall.user$/p' package/lean/default-settings/files/zzz-default-settings

echo "修改DISTRIB_REVISION"
sed -n '/DISTRIB_REVISION=/p' package/lean/default-settings/files/zzz-default-settings
sed -i "s/.*DISTRIB_REVISION=.*/echo \"DISTRIB_REVISION=\'PuXiongfei build $(date "+%Y.%m.%d")\'\">> \/etc\/openwrt_release/" package/lean/default-settings/files/zzz-default-settings
sed -n '/DISTRIB_REVISION=/p' package/lean/default-settings/files/zzz-default-settings

echo "修改KERNEL_BUILD_USER"
sed -n '/KERNEL_BUILD_USER$/,/help$/p' config/Config-kernel.in
sed -i '/KERNEL_BUILD_USER$/,/help$/{s/""/"PuXiongfei"/}' config/Config-kernel.in
sed -n '/KERNEL_BUILD_USER$/,/help$/p' config/Config-kernel.in

echo "替换jerrykuku/luci-theme-argon"
rm -rf package/lean/luci-theme-argon && git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/lean/luci-theme-argon

echo "增加jerrykuku/luci-app-argon-config"
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/custom/luci-app-argon-config

echo "增加rufengsuixing/luci-app-adguardhome"
git clone --depth=1 https://github.com/rufengsuixing/luci-app-adguardhome package/custom/luci-app-adguardhome

echo "增加xiaorouji/openwrt-passwall"
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall package/custom/openwrt-passwall

echo "增加vernesong/luci-app-openclash"
git clone --depth 1 https://github.com/vernesong/OpenClash package/custom/OpenClash

echo "修改DEFAULT_PACKAGES"
sed -n '/DEFAULT_PACKAGES.router/,/^ifneq/p' include/target.mk
sed -i '/DEFAULT_PACKAGES.router/,/^ifneq/{s/luci-app-autoreboot//g;s/luci-app-unblockmusic//g;s/luci-app-accesscontrol//g}' include/target.mk
sed -i '/DEFAULT_PACKAGES.router/a\\tautomount autosamba ddns-scripts_cloudflare.com-v4 ipv6helper luci-app-argon-config luci-app-easymesh luci-app-ttyd luci-app-webadmin \\' include/target.mk
sed -n '/DEFAULT_PACKAGES.router/,/^ifneq/p' include/target.mk

if [ "$CONFIG_FILE_DEVICE" = "D2" ]; then
    echo "修改$CONFIG_FILE_DEVICE的DEVICE_PACKAGES"
    sed -n '/d-team_newifi-d2$/,/d-team_newifi-d2$/p' target/linux/ramips/image/mt7621.mk
    sed -i '/d-team_newifi-d2$/,/d-team_newifi-d2$/{s/kmod-mt7603e/kmod-mt7603/g;s/kmod-mt76x2e/kmod-mt76x2/g;s/luci-app-mtwifi//g;s/-wpad-openssl//g}' target/linux/ramips/image/mt7621.mk
    sed -i '/d-team_newifi-d2$/,/d-team_newifi-d2$/{s/\\/luci-app-aria2 luci-app-mwan3helper luci-app-nfs luci-app-passwall luci-app-wireguard luci-app-zerotier \\/}' target/linux/ramips/image/mt7621.mk
    sed -n '/d-team_newifi-d2$/,/d-team_newifi-d2$/p' target/linux/ramips/image/mt7621.mk
    echo "修改passwall默认值"
    sed -n '/INCLUDE_Shadowsocks_Libev_Client$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -i '/INCLUDE_Shadowsocks_Libev_Client$/,/default/{s/default y/default n/}' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -n '/INCLUDE_Shadowsocks_Libev_Client$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile

    sed -n '/INCLUDE_ShadowsocksR_Libev_Client$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -i '/INCLUDE_ShadowsocksR_Libev_Client$/,/default/{s/default y/default n/}' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -n '/INCLUDE_ShadowsocksR_Libev_Client$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile

    sed -n '/INCLUDE_Simple_Obfs$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -i '/INCLUDE_Simple_Obfs$/,/default/{s/default y/default n/}' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -n '/INCLUDE_Simple_Obfs$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile

    sed -n '/INCLUDE_Xray$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -i '/INCLUDE_Xray$/,/default/{/default/s/$/&||mipsel/}' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -n '/INCLUDE_Xray$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile
fi
if [ "$CONFIG_FILE_DEVICE" = "K3" ]; then
    echo "删除lean/k3screenctrl"
    rm -rf package/lean/k3screenctrl
    echo "增加Hill-98/luci-app-k3screenctrl"
    git clone --depth 1 https://github.com/Hill-98/luci-app-k3screenctrl package/custom/luci-app-k3screenctrl
    echo "增加Hill-98/openwrt-k3screenctrl"
    git clone --depth 1 https://github.com/Hill-98/openwrt-k3screenctrl package/custom/openwrt-k3screenctrl
    echo "复制config/K3/patches"
    cp -af $GITHUB_WORKSPACE/config/K3/patches package/custom/openwrt-k3screenctrl/
    echo "显示000-fix-k3screen.patch"
    cat package/custom/openwrt-k3screenctrl/patches/000-fix-k3screen.patch
    echo "替换brcmfmac4366c-pcie.bin"
    md5sum $GITHUB_WORKSPACE/config/K3/brcmfmac4366c-pcie_3.0.0.4.386.45987.bin
    cp -af $GITHUB_WORKSPACE/config/K3/brcmfmac4366c-pcie_3.0.0.4.386.45987.bin package/lean/k3-brcmfmac4366c-firmware/files/lib/firmware/brcm/brcmfmac4366c-pcie.bin
    md5sum package/lean/k3-brcmfmac4366c-firmware/files/lib/firmware/brcm/brcmfmac4366c-pcie.bin
    echo "修改$CONFIG_FILE_DEVICE的DEVICE_PACKAGES"
    sed -n '/phicomm_k3$/,/phicomm_k3$/p' target/linux/bcm53xx/image/Makefile
    sed -i '/phicomm_k3$/,/phicomm_k3$/{/DEVICE_PACKAGES/s/$/& autocore-arm luci-app-adguardhome luci-app-aria2 luci-app-mwan3helper luci-app-netdata luci-app-nfs luci-app-openclash luci-app-passwall luci-app-rclone luci-app-wireguard luci-app-zerotier/}' target/linux/bcm53xx/image/Makefile
    sed -n '/phicomm_k3$/,/phicomm_k3$/p' target/linux/bcm53xx/image/Makefile
    echo "修改Makefile只编译K3"
    sed -i 's|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += phicomm_k3|TARGET_DEVICES += phicomm_k3|' target/linux/bcm53xx/image/Makefile
    echo "修改02_network"
    sed -n '/phicomm,k3)/,/;;/p' target/linux/bcm53xx/base-files/etc/board.d/02_network
    sed -i '/phicomm,k3)/,/;;/{s/"0:lan" "1:lan"/"0:lan:1" "1:lan:0"/}' target/linux/bcm53xx/base-files/etc/board.d/02_network
    sed -n '/phicomm,k3)/,/;;/p' target/linux/bcm53xx/base-files/etc/board.d/02_network
fi
if [ "$CONFIG_FILE_DEVICE" = "R3G" ]; then
    echo "修改$CONFIG_FILE_DEVICE的DEVICE_PACKAGES"
    sed -n '/xiaomi_mi-router-3g$/,/xiaomi_mi-router-3g$/p' target/linux/ramips/image/mt7621.mk
    sed -i '/xiaomi_mi-router-3g$/,/xiaomi_mi-router-3g$/{s/\\/luci-app-adguardhome luci-app-aria2 luci-app-mwan3helper luci-app-netdata luci-app-nfs luci-app-openclash luci-app-passwall luci-app-rclone luci-app-wireguard luci-app-zerotier \\/}' target/linux/ramips/image/mt7621.mk
    sed -n '/xiaomi_mi-router-3g$/,/xiaomi_mi-router-3g$/p' target/linux/ramips/image/mt7621.mk
    echo "修改passwall默认值"
    sed -n '/INCLUDE_Shadowsocks_Libev_Client$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -i '/INCLUDE_Shadowsocks_Libev_Client$/,/default/{s/default y/default n/}' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -n '/INCLUDE_Shadowsocks_Libev_Client$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile

    sed -n '/INCLUDE_ShadowsocksR_Libev_Client$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -i '/INCLUDE_ShadowsocksR_Libev_Client$/,/default/{s/default y/default n/}' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -n '/INCLUDE_ShadowsocksR_Libev_Client$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile

    sed -n '/INCLUDE_Simple_Obfs$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -i '/INCLUDE_Simple_Obfs$/,/default/{s/default y/default n/}' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -n '/INCLUDE_Simple_Obfs$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile

    sed -n '/INCLUDE_Xray$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -i '/INCLUDE_Xray$/,/default/{/default/s/$/&||mipsel/}' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    sed -n '/INCLUDE_Xray$/,/default/p' package/custom/openwrt-passwall/luci-app-passwall/Makefile
    if [ -e $GITHUB_WORKSPACE/config/R3G_switch.patch ]; then
        echo "显示R3G_switch.patch"
        cat $GITHUB_WORKSPACE/config/R3G_switch.patch
        echo "应用R3G_switch.patch"
        git apply $GITHUB_WORKSPACE/config/R3G_switch.patch
        echo "显示mt7621_xiaomi_mi-router-3g.dts"
        cat target/linux/ramips/dts/mt7621_xiaomi_mi-router-3g.dts
        echo "显示02_network"
        cat target/linux/ramips/mt7621/base-files/etc/board.d/02_network
    fi
fi
if [ "$CONFIG_FILE_DEVICE" = "R86S" ]; then
    echo "修改target/linux/x86/Makefile"
    sed -n '/DEFAULT_PACKAGES/,/BuildTarget/p' target/linux/x86/Makefile
    sed -i '/DEFAULT_PACKAGES/,/BuildTarget/{s/luci-app-adbyby-plus//g;s/luci-app-unblockmusic//g;s/luci-app-xlnetacc//g}' target/linux/x86/Makefile
    sed -i '/DEFAULT_PACKAGES/a\luci-app-adguardhome luci-app-aria2 luci-app-mwan3helper luci-app-docker luci-app-netdata luci-app-nfs luci-app-openclash luci-app-passwall luci-app-rclone \\' target/linux/x86/Makefile
    sed -n '/DEFAULT_PACKAGES/,/BuildTarget/p' target/linux/x86/Makefile

    echo "修改GRUB_TITLE"
    sed -n '/GRUB_TITLE$/,/help$/p' config/Config-images.in
    sed -i "/GRUB_TITLE$/,/help$/{s|\"OpenWrt\"|\"OpenWrt PuXiongfei build $(date "+%Y.%m.%d")\"|}" config/Config-images.in
    sed -n '/GRUB_TITLE$/,/help$/p' config/Config-images.in

    echo "修改QCOW2_IMAGES"
    sed -n '/QCOW2_IMAGES$/,/config/p' config/Config-images.in
    sed -i '/QCOW2_IMAGES$/a\\t\tdefault y' config/Config-images.in
    sed -n '/QCOW2_IMAGES$/,/config/p' config/Config-images.in

    echo "修改TARGET_IMAGES_GZIP"
    sed -n '/TARGET_IMAGES_GZIP$/,/default/p' config/Config-images.in
    sed -i '/TARGET_IMAGES_GZIP$/,/default/{s/default n/default y/}' config/Config-images.in
    sed -n '/TARGET_IMAGES_GZIP$/,/default/p' config/Config-images.in
fi
if [ "$CONFIG_FILE_DEVICE" = "Y1" ]; then
    echo "修改$CONFIG_FILE_DEVICE的DEVICE_PACKAGES"
    sed -n '/lenovo_newifi-y1$/,/lenovo_newifi-y1$/p' target/linux/ramips/image/mt7620.mk
    sed -i '/lenovo_newifi-y1$/,/lenovo_newifi-y1$/{/DEVICE_PACKAGES/s/$/& luci-app-wireguard luci-app-zerotier/}' target/linux/ramips/image/mt7620.mk
    sed -n '/lenovo_newifi-y1$/,/lenovo_newifi-y1$/p' target/linux/ramips/image/mt7620.mk
fi

echo "查看package/custom"
ls -1 package/custom

echo "./scripts/feeds update -a"
./scripts/feeds update -a

echo "./scripts/feeds install -a"
./scripts/feeds install -a
