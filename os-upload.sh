#!/usr/bin/env bash

set -e

read -p "version: " version

VERSION="$version"

read -p "os: " os

OS="$os"

#./build/build.sh

echo Staging /anki files...
./project/victor/scripts/stage.sh

echo Files staged at "$PWD"/_build/staging/Release

cd "$PWD"/_build/staging/Release

tar -cvf anki-"$OS".tar anki

pigz anki-"$OS".tar

scp anki-"$OS".tar.gz root@frogmain:/servers/drive2/froggitti-net/froggitti-net-main/vector-mirror

echo "$VERSION" > anki-"$OS".version

scp anki-"$OS".version root@frogmain:/servers/drive2/froggitti-net/froggitti-net-main/vector-mirror
