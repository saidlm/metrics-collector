#!/bin/sh

echo -n "$USER:$PASS" | chpasswd
echo "$PUBKEY" > /$USER/.ssh/authorized_keys

exec /usr/sbin/sshd -D -e "$@"
