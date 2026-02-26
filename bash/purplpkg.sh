#!/usr/bin/env bash

#purplpkg - a simple package manager for the Vector robot

set -e

BIN_DIR="/data/purplpkg"
VERSION_TRACKING_DIR="/data/purplpkg/files"
FILE_TRACKING_DIR="/data/purplpkg/versions"
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
  curl -o "/data/purplpkg/mirrorlist" https://raw.githubusercontent.com/purpl-org/purplpkg/refs/heads/rewrite/bash/mirrorlist
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
    curl --silent --fail $(head -n 1 "$MIRROR_TRACKING_FILE")
  done
}

function update {
  echo "To be implemented"
  exit 0
}

function download {
  for i in ${@:1}; do
    curl -o "$BIN_DIR/$i.ppkg" 
  done
  exit 0  
}

function install {
  echo "To be implemented"
  exit 0
}

