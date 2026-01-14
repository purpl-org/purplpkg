#!/usr/bin/env bash

set -e

INSTALL_DIR="/data/purplpkg"

if [ ! -d /data/purplpkg ]; then
 mkdir -p /data/purplpkg
fi

BASE_URL="https://www.froggitti.net/vector-mirror/"

if [ "$1" == "" ]; then
 echo "Usage: purplpkg <action> <package>"
 exit 1
fi

if [ "$1" == "update" ]; then
 echo Update implementation not finished yet
 exit
fi

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

echo Installing package "$2" from "$BASE_URL"
curl -o /data/purplpkg/"$2".tar.gz "$BASE_URL"/"$2".tar.gz
gunzip /data/purplpkg/"$2".tar.gz
mkdir "$2"
mv "$2".tar "$2"/
cd "$2"
tar -xvf "$2".tar
mv * /sbin
cd ..
echo "Cleaning up..."
rm -rf "$2"
echo "Package "$2" installed in /sbin"
exit

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
 mv /data/purplpkg/"$2" /anki
 echo Done
 systemctl start anki-robot.target
fi
