#!/bin/bash

set -e

if [ ! -d "$HOME/.anki/vicos-sdk/dist/5.3.0-r07/" ]; then
 echo get a toolchain then try this again
 exit 1
fi

CC="$HOME/.anki/vicos-sdk/dist/5.3.0-r07/prebuilt/bin/arm-oe-linux-gnueabi-clang" CGO_LDFLAGS="-Lbuild" GOARM=7 GOARCH=arm CGO_ENABLED=1 go build -o purplpkg-armv7l purplpkg.go

