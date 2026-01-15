#!/usr/bin/env bash

if [ ! -d /data/purplpkg ]; then
 mkdir -p /data/purplpkg
fi

if [ ! -d /data/purplpkg/versions ]; then
 mkdir -p /data/purplpkg/versions
fi

export PATH="/data/purplpkg:$PATH"

set -e
#mount -o rw,remount /
#rm -rf /data/purplpkg/*
cd /data/purplpkg

BASE_URL="https://www.froggitti.net/vector-mirror/"
#https://purplpkg.net-3.froggitti.net/ will be a backup/secondary mirror - still need to set it up
BASE_URL_2="https://purplpkg.net-3.froggitti.net/"

MIRROR_URL="https://www.froggitti.net/vector-mirror/"

if [ "$1" == "package-list" ]; then
 curl https://www.froggitti.net/vector-mirror/package.list
 exit 0
fi

# Made this but never ended up using it...
#INSTALL_DIR="/data/purplpkg"

if [ "$1" == "" ]; then
 echo purplpkg by purpl
 echo -------------------
 echo Usage:
 echo install: Installs a package
 echo package-list: Lists currently available packages
 exit 0
fi

#if [ "$1" == "update" ]; then
# echo Update implementation not finished yet
# exit 1
#fi

#if [ "$1" == "remove" ]; then
#  if [ ! -f /sbin/"$2" ]; then
#   echo "Package \"$2\" doesn't exist."
#   exit 1
#  else 
#   rm /sbin/$2* 2>/dev/null || true  
#   echo "Package \"$2\" removed."
#  exit 0
# fi
#fi

if [ "$2" == "" ]; then
 echo No package given
 exit 1
fi

echo $PWD

if [ ! "$PWD" == /data/purplpkg ]; then
 echo "We are in the wrong directory. Exiting..."
 exit 1
fi

if [[ "$2" == anki-* ]]; then
 rm /data/purplpkg/*.tar
fi

# Raise CPU frequency for faster downloads/installs
echo 1267200 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq

export VERSION=$(curl https://www.froggitti.net/vector-mirror/"$2".version)

echo Downloading package "$2" from "$MIRROR_URL" with version "$VERSION"
curl -o /data/purplpkg/"$2".tar.gz "$MIRROR_URL"/"$2".tar.gz
curl -o /data/purplpkg/versions/"$2" "$MIRROR_URL"/"$2".version

if [[ ! "$2" == anki-* ]]; then
 echo "Installing..."
 gunzip /data/purplpkg/"$2".tar.gz
 tar -xf "$2".tar
 echo "Cleaning up..."
 rm -rf "$2".tar
 echo "Package "$2" installed with version "$VERSION""
 exit
fi

if [[ "$2" == anki-* ]]; then
 echo "Package is an anki folder"
 echo "Stop robot"
 systemctl stop anki-robot.target
 echo "Decompress anki folder"
 gunzip /data/purplpkg/"$2".tar.gz
 tar -xf /data/purplpkg/"$2".tar
 rm -rf /anki
 echo "Install /anki folder"
 mv /data/purplpkg/anki /anki
 echo "Done"
 systemctl start anki-robot.target
fi

#Lower frequency back to "balanced" wire_d preset
echo 533333 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
