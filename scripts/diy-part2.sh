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

echo "修改默认IP为10.26.26.1"
sed -i 's/192.168.1.1/10.26.26.1/g' package/base-files/files/bin/config_generate
sed -i 's/192.168./10.26./g' package/base-files/files/bin/config_generate
sed -n '/10.26./p' package/base-files/files/bin/config_generate

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

echo "删除feeds/luci/themes/luci-theme-argon"
rm -rf feeds/luci/themes/luci-theme-argon
ls -l feeds/luci/themes

echo "增加jerrykuku/luci-theme-argon"
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/custom/luci-theme-argon

echo "增加jerrykuku/luci-app-argon-config"
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/custom/luci-app-argon-config

echo "增加rufengsuixing/luci-app-adguardhome"
git clone --depth=1 https://github.com/rufengsuixing/luci-app-adguardhome package/custom/luci-app-adguardhome

echo "增加xiaorouji/openwrt-passwall packages"
git clone --depth 1 -b packages https://github.com/xiaorouji/openwrt-passwall package/custom/openwrt-passwall/packages

echo "增加xiaorouji/luci-app-passwall luci"
git clone --depth 1 -b luci https://github.com/xiaorouji/openwrt-passwall package/custom/openwrt-passwall/luci

echo "修改luci-app-passwall默认值"
echo "当前："
cat package/custom/openwrt-passwall/luci/luci-app-passwall/Makefile
sed -i '/Include Shadowsocks Libev Client/,/default/{s/default.*/default n/}' package/custom/openwrt-passwall/luci/luci-app-passwall/Makefile
sed -i '/Include Shadowsocks Libev Server/,/default/{s/default.*/default n/}' package/custom/openwrt-passwall/luci/luci-app-passwall/Makefile
sed -i '/Include Shadowsocks Rust Client/,/default/{s/default.*/default n/}' package/custom/openwrt-passwall/luci/luci-app-passwall/Makefile
sed -i '/Include ShadowsocksR Libev Client/,/default/{s/default.*/default n/}' package/custom/openwrt-passwall/luci/luci-app-passwall/Makefile
sed -i '/Include ShadowsocksR Libev Server/,/default/{s/default.*/default n/}' package/custom/openwrt-passwall/luci/luci-app-passwall/Makefile
sed -i '/Include Simple-Obfs/,/default/{s/default.*/default n/}' package/custom/openwrt-passwall/luci/luci-app-passwall/Makefile
sed -i '/Include Trojan-GO/,/default/{s/default.*/default n/}' package/custom/openwrt-passwall/luci/luci-app-passwall/Makefile
sed -i '/Include Trojan-Plus/,/default/{s/default.*/default y/}' package/custom/openwrt-passwall/luci/luci-app-passwall/Makefile
sed -i '/Include V2ray/,/default/{s/default.*/default n/}' package/custom/openwrt-passwall/luci/luci-app-passwall/Makefile
sed -i '/Include V2ray-Plugin/,/default/{s/default.*/default n/}' package/custom/openwrt-passwall/luci/luci-app-passwall/Makefile
sed -i '/Include Xray/,/default/{s/default.*/default y/}' package/custom/openwrt-passwall/luci/luci-app-passwall/Makefile
sed -i '/Include Xray-Plugin/,/default/{s/default.*/default n/}' package/custom/openwrt-passwall/luci/luci-app-passwall/Makefile
echo "修改后："
cat package/custom/openwrt-passwall/luci/luci-app-passwall/Makefile

echo "增加vernesong/luci-app-openclash"
git clone --depth 1 https://github.com/vernesong/OpenClash package/custom/OpenClash

echo "修改DEFAULT_PACKAGES"
sed -n '/DEFAULT_PACKAGES.router/,/^ifneq/p' include/target.mk
sed -i '/DEFAULT_PACKAGES.router/,/^ifneq/{s/luci-app-autoreboot//g;s/luci-app-ssr-plus//g;s/luci-app-unblockmusic//g;s/luci-app-ramfree//g;s/luci-app-accesscontrol//g}' include/target.mk
sed -i '/DEFAULT_PACKAGES.router/a\\tautomount autosamba ddns-scripts_cloudflare.com-v4 iperf3 ipv6helper luci-app-argon-config luci-app-socat luci-app-ttyd luci-app-webadmin nano \\' include/target.mk
sed -n '/DEFAULT_PACKAGES.router/,/^ifneq/p' include/target.mk

if [ "$CONFIG_FILE_DEVICE" = "K3" ]; then
    mkdir -p package/custom/brcmfmac4366c
    echo "增加lwz322/luci-app-k3screenctrl"
    git clone --depth 1 https://github.com/lwz322/luci-app-k3screenctrl package/custom/luci-app-k3screenctrl
    echo "增加lwz322/k3screenctrl_build"
    git clone --depth 1 https://github.com/lwz322/k3screenctrl_build package/custom/k3screenctrl_build
    echo "复制000-fix-k3screen.patch"
    cp -af package/lean/k3screenctrl/patches package/custom/k3screenctrl_build/
    ls -la package/custom/k3screenctrl_build/patches
    echo "获取brcmfmac4366c-pcie.bin"
    BIN_PATH=$(curl -s https://api.github.com/repos/PuXiongfei/brcmfmac4366c/releases/latest | grep browser_download_url | cut -d '"' -f 4)
    wget -O package/custom/brcmfmac4366c/brcmfmac4366c-pcie.bin ${BIN_PATH}
    md5sum package/custom/brcmfmac4366c/brcmfmac4366c-pcie.bin
    echo "删除lean/k3screenctrl"
    rm -rf package/lean/k3screenctrl
    echo "替换brcmfmac4366c-pcie.bin"
    cp -af package/custom/brcmfmac4366c/brcmfmac4366c-pcie.bin package/lean/k3-brcmfmac4366c-firmware/files/lib/firmware/brcm/brcmfmac4366c-pcie.bin
    md5sum package/lean/k3-brcmfmac4366c-firmware/files/lib/firmware/brcm/brcmfmac4366c-pcie.bin
    echo "修改$CONFIG_FILE_DEVICE的DEVICE_PACKAGES"
    sed -n '/phicomm_k3$/,/phicomm_k3$/p' target/linux/bcm53xx/image/Makefile
    sed -i '/phicomm_k3$/,/phicomm_k3$/{/DEVICE_PACKAGES/s/$/& autocore-arm docker-compose luci-app-adguardhome luci-app-aria2 luci-app-dockerman luci-app-k3screenctrl luci-app-openclash luci-app-passwall luci-app-rclone luci-app-zerotier tailscale/}' target/linux/bcm53xx/image/Makefile
    sed -n '/phicomm_k3$/,/phicomm_k3$/p' target/linux/bcm53xx/image/Makefile
    echo "修改Makefile只编译K3"
    sed -i 's|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += phicomm_k3|TARGET_DEVICES += phicomm_k3|' target/linux/bcm53xx/image/Makefile
    echo "修改02_network"
    sed -n '/phicomm,k3)/,/;;/p' target/linux/bcm53xx/base-files/etc/board.d/02_network
    sed -i '/phicomm,k3)/,/;;/{s/"0:lan" "1:lan"/"0:lan:1" "1:lan:0"/}' target/linux/bcm53xx/base-files/etc/board.d/02_network
    sed -n '/phicomm,k3)/,/;;/p' target/linux/bcm53xx/base-files/etc/board.d/02_network
fi
if [ "$CONFIG_FILE_DEVICE" = "N1" ]; then
    echo "增加ophub/luci-app-amlogic"
    git clone --depth 1 https://github.com/ophub/luci-app-amlogic package/custom/luci-app-amlogic
    echo "修改$CONFIG_FILE_DEVICE的DEVICE_PACKAGES"
    sed -n '/DEFAULT_PACKAGES/p' target/linux/armvirt/Makefile
    sed -i 's/DEFAULT_PACKAGES.*/DEFAULT_PACKAGES +=/' target/linux/armvirt/Makefile
    sed -i '/DEFAULT_PACKAGES/s/$/& perl perl-http-date perlbase-getopt perlbase-time perlbase-unicode perlbase-utf8/' target/linux/armvirt/Makefile
    sed -i '/DEFAULT_PACKAGES/s/$/& blkid fdisk lsblk parted/' target/linux/armvirt/Makefile
    sed -i '/DEFAULT_PACKAGES/s/$/& attr btrfs-progs chattr dosfstools e2fsprogs f2fs-tools f2fsck lsattr mkf2fs xfs-fsck xfs-mkfs/' target/linux/armvirt/Makefile
    sed -i '/DEFAULT_PACKAGES/s/$/& bsdtar pigz/' target/linux/armvirt/Makefile
    sed -i '/DEFAULT_PACKAGES/s/$/& bash/' target/linux/armvirt/Makefile
    sed -i '/DEFAULT_PACKAGES/s/$/& gawk getopt losetup tar uuidgen/' target/linux/armvirt/Makefile
    sed -i '/DEFAULT_PACKAGES/s/$/& kmod-brcmfmac kmod-brcmutil kmod-cfg80211 kmod-mac80211/' target/linux/armvirt/Makefile
    sed -i '/DEFAULT_PACKAGES/s/$/& wpa-cli wpad-openssl/' target/linux/armvirt/Makefile
    sed -i '/DEFAULT_PACKAGES/s/$/& kmod-usb-hid kmod-mmc usbutils pciutils kmod-usb-audio kmod-usb-net kmod-usb-net-asix-ax88179 kmod-usb-net-rtl8150 kmod-usb-net-rtl8152-vendor kmod-sound-core kmod-bluetooth bluez-utils bluez-utils-extra bluez-daemon alsa-utils/' target/linux/armvirt/Makefile
    sed -i '/DEFAULT_PACKAGES/s/$/& docker-compose luci-app-adguardhome luci-app-amlogic luci-app-aria2 luci-app-dockerman luci-app-netdata luci-app-openclash luci-app-passwall luci-app-rclone luci-app-zerotier tailscale/' target/linux/armvirt/Makefile
    sed -n '/DEFAULT_PACKAGES/p' target/linux/armvirt/Makefile
    echo "修改.config"
    echo "CONFIG_TESTING_KERNEL=y" >>.config
    echo "CONFIG_BRCMFMAC_SDIO=y" >>.config
    echo "# CONFIG_BRCMFMAC_USB is not set" >>.config
    echo "# CONFIG_BRCMFMAC_PCIE is not set" >>.config
    echo "CONFIG_BTRFS_PROGS_ZSTD=y" >>.config
    echo "CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_OFFLOADING=y" >>.config
    echo "# CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_SHORTCUT_FE is not set" >>.config
    echo "# CONFIG_TARGET_ROOTFS_INITRAMFS is not set" >>.config
    echo "# CONFIG_TARGET_ROOTFS_CPIOGZ is not set" >>.config
    echo "# CONFIG_TARGET_ROOTFS_EXT4FS is not set" >>.config
    echo "# CONFIG_TARGET_ROOTFS_SQUASHFS is not set" >>.config
    cat .config
fi
if [ "$CONFIG_FILE_DEVICE" = "R86S" ]; then
    echo "修改target/linux/x86/Makefile"
    sed -n '/DEFAULT_PACKAGES/,/BuildTarget/p' target/linux/x86/Makefile
    sed -i '/DEFAULT_PACKAGES/,/BuildTarget/{s/luci-app-adbyby-plus//g;s/luci-app-ipsec-vpnd//g;s/luci-app-unblockmusic//g;s/luci-app-xlnetacc//g;s/luci-app-wireguard//g}' target/linux/x86/Makefile
    sed -i '/DEFAULT_PACKAGES/a\bash blkid fdisk lsblk parted \\' target/linux/x86/Makefile
    sed -i '/DEFAULT_PACKAGES/a\ibt-firmware iwlwifi-firmware-ax200 iwlwifi-firmware-ax210 kmod-cfg80211 kmod-iwlwifi kmod-mac80211 wpad-openssl \\' target/linux/x86/Makefile
    sed -i '/DEFAULT_PACKAGES/a\luci-app-adguardhome luci-app-aria2 luci-app-netdata luci-app-openclash luci-app-passwall luci-app-rclone tailscale \\' target/linux/x86/Makefile
    sed -n '/DEFAULT_PACKAGES/,/BuildTarget/p' target/linux/x86/Makefile
    echo "修改.config"
    echo "CONFIG_GRUB_TITLE=\"OpenWrt PuXiongfei build $(date "+%Y.%m.%d")\"" >>.config
    cat .config
fi

echo "查看package/custom"
ls -1 package/custom
