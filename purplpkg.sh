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
fi

if [ "$2" == "" ]; then
 echo No package given
 exit 1
fi

if [ "$2" == "anki-*" ]; then
 echo Package is anki
 echo Stop robot
 rm /data/purplpkg/an*
 systemctl stop anki-robot.target
fi

echo Installing package "$2" from "$BASE_URL"
curl -o /data/purplpkg/"$2".tar.gz "$BASE_URL"/"$2".tar.gz

if [ "$2" == "anki-*" ]; then
 echo Package is an anki folder
 echo Curl verison
 curl -o /data/purplpkg/anki.verison "$BASE_URL"/"$2".version
 cat /data/purplpkg/"$2".version
 echo Function unfinished for now
fi

if [ "$2" == "anki-*" ]; then
 mount -o rw,remount / 
 #rm /data/purplpkg/anki*
 echo Package is an anki folder     
 echo Uncompress anki folder
 gunzip /data/purplpkg/anki.tar.gz
 tar -xvf /data/purplpkg/anki.tar
 #mount -o rw,remount /
 rm -rf /anki
 mv /data/purplpkg/anki /anki
 echo Done
 systemctl start anki-robot.target
fi
