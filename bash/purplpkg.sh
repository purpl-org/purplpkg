#!/usr/bin/env bash

#purplpkg - a simple package manager for the Vector robot

set -e

BIN_DIR="/data/purplpkg"
VERSION_TRACKING_DIR="/data/purplpkg/versions"
FILE_TRACKING_DIR="/data/purplpkg/files"
MIRROR_TRACKING_FILE="/data/purplpkg/mirrorlist"

if [ ! -d "/data/purplpkg" ]; then 
  mkdir -p "/data/purplpkg"
fi

if [ ! -d "/data/purplpkg/files" ]; then 
  mkdir -p "/data/purplpkg/files"
fi

if [ ! -d "/data/purplpkg/versions" ]; then 
  mkdir -p "/data/purplpkg/versions"
fi

if [ ! -f "/data/purplpkg/mirrorlist" ]; then
  curl --silent -o "/data/purplpkg/mirrorlist" https://raw.githubusercontent.com/purpl-org/purplpkg/refs/heads/rewrite/bash/mirrorlist
fi

if [ "$1" == "" ]; then
  echo "purplpkg: missing function"
  echo "Try: purplpkg --help" 
fi

if [ "$1" == "--help" ]; then
  echo "purplpkg - Package manager for Vector"
  echo "Functions:"
fi

########################## Functions ##########################

function checkavailable {
  for i in ${@:1}; do
    if curl --fail --silent "$(head -n 1 "$MIRROR_TRACKING_FILE")/$i/$i.ppkg" > /dev/null; then
      echo "Package exists on main mirror"
      SELECTED_MIRROR="$(sed -n '1p' "$MIRROR_TRACKING_FILE")"
    else
      echo "Package not found on main mirror, trying secondary"
      if curl --fail --silent "$(sed -n '2p' "$MIRROR_TRACKING_FILE")/$i/$i.ppkg" > /dev/null; then
       echo "Package exists on secondary mirror"
       SELECTED_MIRROR="$(sed -n '2p' "$MIRROR_TRACKING_FILE")"
      else
       echo "Packages don't exist on primary or secondary mirror."
       exit 1
      fi
    fi
  done
}

function update {
  echo "To be implemented"
  exit 0
}

function download {
  for i in ${@:1}; do
    curl -o "$BIN_DIR/$i.ppkg" $SELECTED_MIRROR/$i/$i.ppkg
  done
}

function install {
  echo "To be implemented"
  exit 0
}

###############################################################

if [ "$1" == "install" ]; then
  if [ "$2" == "" ]; then
   echo "Error: Missing package name"
   exit 1
  else
   checkavailable "${@:2}"
   download "${@:2}"
  fi
fi