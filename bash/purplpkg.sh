#!/usr/bin/env bash

#purplpkg - a simple package manager for the Vector robot
#by purpl organization.

# Raise CPU frequency for faster downloads/installs
echo 1267200 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq

BASE_URL="https://www.froggitti.net/vector-mirror/"
BASE_URL_2=""

MIRROR_URL="https://www.froggitti.net/vector-mirror/"

if [ ! -d /data/purplpkg ]; then
 mkdir -p /data/purplpkg
fi

if [ ! -d /data/purplpkg/versions ]; then
 mkdir -p /data/purplpkg/versions
fi

if [ ! -d /data/purplpkg/files ]; then
 mkdir -p /data/purplpkg/files
fi

#export PATH="$INSTALL_DIR:$PATH"

set -e

cd /data/purplpkg

if [ "$1" == "" ]; then
    echo purplpkg by purpl
    echo -------------------
    echo Usage:
    echo install: Installs a package
    echo update: Updates an installed package
    echo remove: Removes an installed package
    echo package-list: Lists currently available packages
    echo mirror-list: Lists currently available mirrors
    exit 0
fi

if [ "$1" != "package-list" ] && [ "$1" != "install" ] && [ "$1" != "mirror-list" ] && [ "$1" != "update" ] && [ "$1" != "remove" ]; then
    echo Unknown action "$1"
    exit 1
fi

if [ "$1" == "package-list" ]; then
    curl https://www.froggitti.net/vector-mirror/package.list
    exit 0
fi

if [ "$1" == "mirror-list" ]; then
  if [ "$BASE_URL_2" == "" ]; then
    echo Primary mirror: "$BASE_URL"
    echo Secondary mirror undefined.
    exit 0
  else
    echo Primary mirror: "$BASE_URL"
    echo Secondary mirror: "$BASE_URL_2"
    exit 0
 fi
fi

if [ "$1" == "remove" ]; then
 if [ "$2" == "" ]; then
  echo "Package not specified"
  exit 1
 elif [ ! -f /data/purplpkg/files/"$2" ]; then
  echo "Package "$2" isn't installed."
  exit 1
 fi
 echo "Removing package "$2""
 rm $(cat /data/purplpkg/files/"$2")
 rm /data/purplpkg/files/"$2"
 rm /data/purplpkg/versions/"$2" 
 echo "Package "$2" removed." 
 exit 0
fi

if [ "$1" == "update" ]; then
   if [ ! -f versions/"$2" ]; then
     echo No such package "$2"
     exit 1
   else
     echo Installed version of package "$2" is $(cat versions/"$2")
    if [ $(curl --silent "$MIRROR_URL"/"$2".version) == $(cat versions/"$2") ]; then
     echo Package "$2" already up to date.
     exit 0
    else
     export VERSION=$(curl --silent "$MIRROR_URL"/"$2".version)
     rm $(cat /data/purplpkg/files/"$2")
     echo Downloading updated package "$2" from "$MIRROR_URL" with version "$VERSION"
     curl -o /data/purplpkg/"$2".ppkg "$MIRROR_URL"/"$2".ppkg
     curl --silent -o /data/purplpkg/versions/"$2" "$MIRROR_URL"/"$2".version
     curl --silent -o /data/purplpkg/files/"$2" "$MIRROR_URL"/"$2".flist
     echo "Updating..."
     tar -xzf "$2".ppkg
     echo "Cleaning up..."
     rm "$2".ppkg
     echo "Package "$2" updated with version "$VERSION""
     #Lower frequency back to "balanced" wire_d preset
     echo 533333 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
     exit 0
  fi
 fi
fi

if [ "$2" == "" ]; then
    echo No package given
    exit 1
fi

if [ ! "$PWD" == /data/purplpkg ]; then
    echo "We are in the wrong directory. Exiting..."
    exit 1
fi

export VERSION=$(curl --silent "$MIRROR_URL"/"$2".version)

echo Downloading package "$2" from "$MIRROR_URL" with version "$VERSION"
curl -o /data/purplpkg/"$2".ppkg "$MIRROR_URL"/"$2".ppkg
curl --silent -o /data/purplpkg/versions/"$2" "$MIRROR_URL"/"$2".version
curl --silent -o /data/purplpkg/files/"$2" "$MIRROR_URL"/"$2".flist

if grep -q "<head><title>404 Not Found</title></head>" "$2".ppkg; then
    echo "Package is a 404. Deleting."
    rm "$2".ppkg
    rm versions/"$2"
    echo "Check the package name and try again."
    exit 1
else
    echo "Installing..."
    tar -xzf "$2".ppkg
    echo "Cleaning up..."
    rm "$2".ppkg
    echo "Package "$2" installed with version "$VERSION""
    #Lower frequency back to "balanced" wire_d preset
    echo 533333 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    exit 0
fi

