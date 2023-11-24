#!/usr/bin/env bash


# Test for sudo
user=$(whoami)
if [ $user != "root" ]
then
    echo "You must run this script with root privileges. Please use sudo" >&2
    exit 1
fi

ifdown enp1s0
cp /root/backups/interfaces.static /etc/network/interfaces
ifup enp1s0
