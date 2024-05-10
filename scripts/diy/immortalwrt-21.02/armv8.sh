#!/bin/bash

# 修改默认IP和hostname
sed -i 's/192.168.1.1/10.10.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/OpenWrt/g' package/base-files/files/bin/config_generate

# 修改opkg源
echo "src/gz openwrt_kiddin9 https://dl.openwrt.ai/latest/packages/aarch64_cortex-a53/kiddin9" >> package/system/opkg/files/customfeeds.conf

rm_package() {
    find ./ -maxdepth 4 -iname "$1" -type d | xargs rm -rf
}

rm_package "*alist"
rm_package "*ddns-go"
rm_package "*smartdns"
rm_package "*sqm*"
rm_package "minidlna"
rm_package "miniupnpd"
rm_package "zerotier"

git_sparse_clone() {
    branch="$1" repourl="$2" repodir="$3"
    git clone -b $branch --depth=1 --filter=blob:none --sparse $repourl package/cache
    git -C package/cache sparse-checkout set $repodir
    mv -f package/cache/$repodir package
    rm -rf package/cache
}

git_sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-alist
git_sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-ddns-go
git_sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-minidlna
git_sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-smartdns
git_sparse_clone master https://github.com/immortalwrt/luci.git applications/luci-app-sqm
git_sparse_clone master https://github.com/immortalwrt/packages.git multimedia/minidlna
git_sparse_clone master https://github.com/immortalwrt/packages.git net/alist
git_sparse_clone master https://github.com/immortalwrt/packages.git net/ddns-go
git_sparse_clone master https://github.com/immortalwrt/packages.git net/miniupnpd
git_sparse_clone master https://github.com/immortalwrt/packages.git net/smartdns
git_sparse_clone master https://github.com/immortalwrt/packages.git net/sqm-scripts
git_sparse_clone master https://github.com/immortalwrt/packages.git net/zerotier

sed -i 's|admin/network|admin/control|g' package/luci-app-sqm/root/usr/share/luci/menu.d/*.json

replace_text() {
  search_text="$1" new_text="$2"
  sed -i "s/$search_text/$new_text/g" $(grep "$search_text" -rl ./)
}

replace_text "DDNS-Go" "DDNSGO"