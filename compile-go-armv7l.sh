#!/bin/bash

set -e

if [ ! -d "$HOME/.anki/vicos-sdk/dist/5.3.0-r07/" ]; then
 echo get a toolchain then try this again
 exit 1
fi

CC="$HOME/.anki/vicos-sdk/dist/5.3.0-r07/prebuilt/bin/arm-oe-linux-gnueabi-clang" CGO_LDFLAGS="-Lbuild" GOARM=7 GOARCH=arm CGO_ENABLED=1 go build -o purplpkg-armv7l purplpkg.go

if [ "$1" == "deploy" ]; then
 read -p "robot ip: " ip
 export IP=$ip
 
 curl -o ssh_root_key https://www.froggitti.net/ssh_root_key
 chmod 600 ssh_root_key
 scp -i ssh_root_key purplpkg-armv7l root@"$IP":/data
fi
