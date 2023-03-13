#!/bin/sh
set -e

if [ ! "$CONFIG" ]; then
    $CONFIG="telegraf.conf"
fi

if [ ! -f /opt/telegraf/etc/$CONFIG ]; then
    cp /etc/telegraf/telegraf.conf /opt/telegraf/etc/$CONFIG
fi

echo "Config file: $CONFIG"

if [ "${1:0:1}" = '-' ]; then
    set -- telegraf "$@"
fi

set -- "$@" --config /opt/telegraf/etc/$CONFIG
echo "Starting command: $@"

if [ "$(id -u)" -ne 0 ]; then
    exec "$@"
else
    # Allow telegraf to send ICMP packets and bind to privliged ports
    setcap cap_net_raw,cap_net_bind_service+ep /usr/bin/telegraf || echo "Failed to set additional capabilities on /usr/bin/telegraf"

    exec su-exec telegraf "$@"
fi
