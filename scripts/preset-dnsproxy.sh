#!/bin/bash

REPO="AdguardTeam/dnsproxy"
LATEST_VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | cut -d '"' -f 4)
URL="https://github.com/$REPO/releases/latest/download/dnsproxy-linux-${1}-$LATEST_VERSION.tar.gz"
curl -fsSL $URL | tar xz
mkdir -p files/usr/bin
mv -f ./linux*/dnsproxy files/usr/bin/dnsproxy
chmod +x files/usr/bin/dnsproxy

mkdir -p files/etc/init.d
cat > files/etc/init.d/dnsproxy << 'EOF'
#!/bin/sh /etc/rc.common

USE_PROCD=1
START=90

start_service() {
    if [ -f /etc/config/dnsproxy ]; then
        cmd="/usr/bin/dnsproxy --config-path=/etc/config/dnsproxy"
    else
        cmd="/usr/bin/dnsproxy -l 127.0.0.1 -p 5353 -b quic://223.6.6.6 -u quic://223.5.5.5 -f quic://94.140.14.140 --edns --cache-optimistic"
        echo "Warning: Configuration file /etc/config/dnsproxy does not exist. Start with default configuration."
    fi
    procd_open_instance
    procd_set_param command $cmd
    procd_set_param respawn
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_close_instance
}

stop_service() {
    :
}
EOF
chmod +x files/etc/init.d/dnsproxy

echo -e "\e[32m$0 [DONE]\e[0m"