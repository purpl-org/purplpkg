#!/usr/bin/env bash

if [ ! -d /data/purplpkg ]; then
 mkdir -p /data/purplpkg
fi

set -e

mount -o rw,remount /

rm -rf /data/purplpkg/*

cd /data/purplpkg

echo $PWD

if [ "$1" == "package-list" ]; then
 curl https://www.froggitti.net/vector-mirror/package.list
 exit 0
fi

# Raise CPU frequency for faster downloads/installs
echo 1267200 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq

# Made this but never ended up using it...
#INSTALL_DIR="/data/purplpkg"

BASE_URL="https://www.froggitti.net/vector-mirror/"

if [ "$1" == "" ]; then
 echo purplpkg by purpl
 echo -------------------
 echo Usage:
 echo install: Installs a package
 echo package-list: Lists currently available packages
 exit 1
fi

#if [ "$1" == "update" ]; then
# echo Update implementation not finished yet
# exit
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

if [[ "$2" == anki-* ]]; then
 echo Package is anki
 echo Stop robot
 rm -rf /data/purplpkg/an*
 systemctl stop anki-robot.target
fi

echo Downloading package "$2" from "$BASE_URL"
curl -o /data/purplpkg/"$2".tar.gz "$BASE_URL"/"$2".tar.gz

if [[ ! "$2" == anki-* ]]; then
 echo "Installing..."
 gunzip /data/purplpkg/"$2".tar.gz
 mkdir "$2"
 mv "$2".tar "$2"/
 cd "$2"
 tar -xf "$2".tar
 mv * /sbin
 cd ..
 echo "Cleaning up..."
 rm -rf "$2"
 echo "Package "$2" installed in /sbin"
 exit
fi

if [[ "$2" == anki-* ]]; then
 echo Package is an anki folder
 echo Curl version
 curl -o /data/purplpkg/"$2".version "$BASE_URL"/"$2".version
 cat /data/purplpkg/"$2".version
 echo Function unfinished for now
fi

if [[ "$2" == anki-* ]]; then
 mount -o rw,remount / 
 echo Package is an anki folder     
 echo Uncompress anki folder
 gunzip /data/purplpkg/"$2".tar.gz
 tar -xvf /data/purplpkg/"$2".tar
 rm -rf /anki
 mv /data/purplpkg/anki /anki
 echo Done
 systemctl start anki-robot.target
fi

#Lower frequency back to "balaned" wire_d preset
echo 533333 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
