#!/bin/bash

mount -o rw,remount /
curl -o /sbin/purplpkg https://raw.githubusercontent.com/purpl-org/purplpkg/refs/heads/main/bash/purplpkg.sh
chmod +x /sbin/purplpkg
echo
echo "purplpkg has been installed!"
if [[ ! "$(cat /etc/profile)" == *"purplpkg"* ]]; then
    echo 'export PATH=$PATH:/data/purplpkg' >> /etc/profile
    echo "Exit and relogin to be able to use installed packages."
fi
