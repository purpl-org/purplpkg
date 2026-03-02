#!/usr/bin/env bash

#purplpkg - a simple package manager for the Vector robot

###############################################################

set -e

BIN_DIR="/data/purplpkg"
FILE_TRACKING_DIR="/data/purplpkg/files"
VERSION_TRACKING_DIR="/data/purplpkg/versions"
MIRROR_TRACKING_FILE="/data/purplpkg/mirrorlist"
MIRROR_TRACKING_FILE_SOURCE="https://raw.githubusercontent.com/purpl-org/purplpkg/refs/heads/rewrite/bash/mirrorlist"

if [ ! -d "$BIN_DIR" ] || [ ! -d "$FILE_TRACKING_DIR" ] || [ ! -d "$VERSION_TRACKING_DIR" ]; then
  clear
  echo "First use detected. Making directories..."
  mkdir -p "$BIN_DIR" "$FILE_TRACKING_DIR" "$VERSION_TRACKING_DIR"
  sleep 1s
fi

cd "$BIN_DIR"

if [ ! -f "$MIRROR_TRACKING_FILE" ]; then
  curl --silent -o "$MIRROR_TRACKING_FILE" "$MIRROR_TRACKING_FILE_SOURCE"
fi

if [ "$1" == "" ]; then
  echo "purplpkg: missing operation"
  echo "Try: purplpkg --help" 
fi

if [ "$1" == "--help" ]; then
  echo "usage: purplpkg <command> [PACKAGE]"
  echo ""
  echo "Commands:"
  echo "  install <package>    Install a package"
  echo "  remove <package>     Remove a package"
  echo "  update               Update the mirror list"
  echo "  upgrade              Updates all installed packages"
  echo ""
  echo "Options:"
  echo "  --help               Show this message"
fi

########################## Functions ##########################

function checkavailable {
  for i in ${@:1}; do
    if curl -L --fail --silent "$(head -n 1 "$MIRROR_TRACKING_FILE")/$i/$i.ppkg" > /dev/null; then
      SELECTED_MIRROR="$(sed -n '1p' "$MIRROR_TRACKING_FILE")"
    else
      echo "Package not found on main mirror, trying secondary"
      if curl -L --fail --silent "$(sed -n '2p' "$MIRROR_TRACKING_FILE")/$i/$i.ppkg" > /dev/null; then
       echo "Package exists on secondary mirror."
       SELECTED_MIRROR="$(sed -n '2p' "$MIRROR_TRACKING_FILE")"
      else
       echo "Packages don't exist on primary or secondary mirror."
       echo "-----------------------------------"
       cat "$MIRROR_TRACKING_FILE"
       echo "-----------------------------------"
       echo "Please find the URL of the mirror you have verified to have the package you want and paste it below."
       echo "Or, if you have your own mirror that is not in the mirrorlist you can use that."
       read -p "Enter mirror URL: " cmirror
       SELECTED_MIRROR="$cmirror"
      fi
    fi
  done
}

function download {
  for i in ${@:1}; do
    echo "Downloading package $i..."
    curl -L -o "$BIN_DIR/$i.ppkg" "$SELECTED_MIRROR/$i/$i.ppkg"
    curl --silent -L -o "$VERSION_TRACKING_DIR/$i" "$SELECTED_MIRROR/$i/$i.version"
    curl --silent -L -o "$FILE_TRACKING_DIR/$i" "$SELECTED_MIRROR/$i/$i.flist"
  done
}

function install {
  for i in ${@:1}; do
    tar -xzf "$i".ppkg
    rm "$i".ppkg
    echo "Package $i installed."
  done
}

function update {
  echo "Updating..."
  curl --silent -o "$MIRROR_TRACKING_FILE" "$MIRROR_TRACKING_FILE_SOURCE"
  echo "Mirror list updated."
  exit 0
}

function upgrade {
  for i in $(ls "$FILE_TRACKING_DIR"); do
    checkavailable "$i"
    download "$i"
    install "$i"
  done
}

function remove {
  for i in ${@:1}; do
    if [ ! -f "$FILE_TRACKING_DIR/$i" ]; then
      echo "Package $i is not installed."
    else
      rm $(cat "$FILE_TRACKING_DIR/$i")
      rm "$FILE_TRACKING_DIR/$i"
      rm "$VERSION_TRACKING_DIR/$i"
    fi
  done
}

###############################################################

if [ "$1" == "install" ]; then
  if [ "$2" == "" ]; then
   echo "Error: Missing package"
   exit 1
  else
   checkavailable "${@:2}"
   download "${@:2}"
   install "${@:2}"
  fi
fi

if [ "$1" == "update" ]; then
  update
fi

if [ "$1" == "upgrade" ]; then
  echo "Performing an all-package upgrade"  
  upgrade
fi

if [ "$1" == "remove" ]; then
  remove "${@:2}"
fi

###############################################################