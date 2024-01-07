#!/bin/bash

# 移除package
find . -maxdepth 4 -iname "*adguardhome" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*advanced" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*amlogic" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*autotimeset" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*bypass" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*ddnsto" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*dockerman" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*mosdns" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*netdata" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*nlbwmon*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*onliner" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*openclash" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*passwall" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*pushbot" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*qbittorrent*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*shadowsocks*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*ssr*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*transmission*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*trojan*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*turboacc" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*v2ray*" -type d | xargs rm -rf
find . -maxdepth 4 -iname "*xray*" -type d | xargs rm -rf

# 添加package
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns.git package/mosdns
git clone --depth=1 https://github.com/sbwml/v2ray-geodata.git package/geodata
git clone --depth=1 https://github.com/sirpdboy/luci-app-advanced.git package/luci-app-advanced
git clone --depth=1 https://github.com/sirpdboy/luci-app-autotimeset.git package/luci-app-autotimeset
git clone --depth=1 https://github.com/zzsj0928/luci-app-pushbot.git package/luci-app-pushbot
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-control-timewol package/luci-app-control-timewol
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-onliner package/luci-app-onliner
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-turboacc package/luci-app-turboacc
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wireguard package/luci-app-wireguard
svn export https://github.com/linkease/nas-packages-luci/trunk/luci/luci-app-ddnsto package/luci-app-ddnsto
svn export https://github.com/linkease/nas-packages/trunk/network/services/ddnsto package/ddnsto
svn export https://github.com/lisaac/luci-app-dockerman/trunk/applications/luci-app-dockerman package/luci-app-dockerman
svn export https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash

# 更改 Argon 主题背景
cp -f $GITHUB_WORKSPACE/images/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# samba解除root限制
sed -i 's/invalid users = root/#&/g' feeds/packages/net/samba4/files/smb.conf.template

# ttyd自动登录
sed -i "s?/bin/login?/usr/libexec/login.sh?g" feeds/packages/utils/ttyd/files/ttyd.config

# turboacc start_dnsproxy
sed -i 's|tls://9.9.9.9|https://1.12.12.12/dns-query|g' package/luci-app-turboacc/root/etc/init.d/turboacc
sed -i 's|tls://8.8.8.8|https://1.0.0.1/dns-query|g' package/luci-app-turboacc/root/etc/init.d/turboacc
sed -i 's|--cache-min-ttl=3600|--http3 --edns --cache-optimistic|g' package/luci-app-turboacc/root/etc/init.d/turboacc

# amlogic
sed -i "s|amlogic_firmware_repo.*|amlogic_firmware_repo 'https://github.com/v8040/AutoBuild-OpenWrt'|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|.img.gz|.img.xz|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|amlogic_kernel_path.*|amlogic_kernel_path 'https://github.com/ophub/kernel'|g" package/luci-app-amlogic/root/etc/config/amlogic

# 修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# 调整菜单
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/controller/*.lua
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/model/cbi/openclash/*.lua
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/view/openclash/*.htm
sed -i 's/services/control/g' feeds/luci/applications/luci-app-eqos/root/usr/share/luci/menu.d/*.json
sed -i 's/services/control/g' feeds/luci/applications/luci-app-nft-qos/luasrc/controller/*.lua
sed -i 's|admin/network|admin/control|g' feeds/luci/applications/luci-app-sqm/root/usr/share/luci/menu.d/*.json

# 修改插件名字
sed -i 's/"Alist 文件列表"/"Alist网盘"/g' `grep "Alist 文件列表" -rl ./`
sed -i 's/"Argon 主题设置"/"主题设置"/g' `grep "Argon 主题设置" -rl ./`
sed -i 's/"Aria2 配置"/"Aria2设置"/g' `grep "Aria2 配置" -rl ./`
sed -i 's/"Aria2"/"Aria2设置"/g' `grep "Aria2" -rl ./`
sed -i 's/"ChinaDNS-NG"/"ChinaDNS"/g' `grep "ChinaDNS-NG" -rl ./`
sed -i 's/"DDNS-Go"/"DDNSGO"/g' `grep "DDNS-Go" -rl ./`
sed -i 's/"DDNSTO 远程控制"/"DDNSTO"/g' `grep "DDNSTO 远程控制" -rl ./`
sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
sed -i 's/"NFS 管理"/"NFS管理"/g' `grep "NFS 管理" -rl ./`
sed -i 's/"QoS Nftables 版"/"QoS管理"/g' `grep "QoS Nftables 版" -rl ./`
sed -i 's/"Rclone"/"网盘挂载"/g' `grep "Rclone" -rl ./`
sed -i 's/"SQM QoS"/"SQM管理"/g' `grep "SQM QoS" -rl ./`
sed -i 's/"SQM 队列管理"/"SQM管理"/g' `grep "SQM 队列管理" -rl ./`
sed -i 's/"Socat"/"端口转发"/g' `grep "Socat" -rl ./`
sed -i 's/"SoftEther VPN 服务器"/"SoftEther"/g' `grep "SoftEther VPN 服务器" -rl ./`
sed -i 's/"TTYD 终端"/"终端"/g' `grep "TTYD 终端" -rl ./`
sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' `grep "Turbo ACC 网络加速" -rl ./`
sed -i 's/"UPnP"/"UPnP设置"/g' `grep "UPnP" -rl ./`
sed -i 's/"USB 打印服务器"/"USB打印"/g' `grep "USB 打印服务器" -rl ./`
sed -i 's/"WireGuard 状态"/"WiGd状态"/g' `grep "WireGuard 状态" -rl ./`
sed -i 's/"WireGuard"/"WiGd状态"/g' `grep "WireGuard" -rl ./`
sed -i 's/"miniDLNA"/"DLNA设置"/g' `grep "miniDLNA" -rl ./`
sed -i 's/"动态 DNS"/"动态DNS"/g' `grep "动态 DNS" -rl ./`
sed -i 's/"动态 DNS(DDNS)"/"动态DNS"/g' `grep "动态 DNS(DDNS)" -rl ./`
sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./`
sed -i 's/"挂载 SMB 网络共享"/"挂载共享"/g' `grep "挂载 SMB 网络共享" -rl ./`
sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`
sed -i 's/"联机用户"/"在线用户"/g' `grep "联机用户" -rl ./`
sed -i 's/"解除网易云音乐播放限制"/"音乐解锁"/g' `grep "解除网易云音乐播放限制" -rl ./`
sed -i 's/"迷你DLNA"/"DLNA设置"/g' `grep "迷你DLNA" -rl ./`
