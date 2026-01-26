#!/bin/bash
#script to deploy to vector cause github is a fucking asshole

if [ "$1" == "" ]; then
 echo "GIVE THE FUCKING SCRIPT A FUCKING IP"
 exit 1
else
 ssh -i ../go/ssh_root_key root@"$1" 'mount -o rw,remount /'
 scp -i ../go/ssh_root_key purplpkg.sh root@"$1":/sbin/purplpkg
fi

