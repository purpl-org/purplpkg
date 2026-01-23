#!/bin/bash

set -e

if [ ! -d "$HOME/.anki/vicos-sdk/dist/5.3.0-r07/" ]; then
 echo get a toolchain then try this again
 exit 1
fi

CC="$HOME/.anki/vicos-sdk/dist/5.3.0-r07/prebuilt/bin/arm-oe-linux-gnueabi-clang" CGO_LDFLAGS="-Lbuild" GOARM=7 GOARCH=arm CGO_ENABLED=1 go build -ldflags="-s -w" -o purplpkg-armv7l purplpkg.go

if [ "$1" == "deploy" ]; then
 if [ "$2" == "" ]; then
  read -p "robot ip: " ip
  export IP=$ip
  scp -i ssh_root_key purplpkg-armv7l root@"$IP":/data
 else
  scp -i ssh_root_key purplpkg-armv7l root@"$2":/data
 fi
fi
