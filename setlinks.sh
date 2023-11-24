#!/usr/bin/env bash

# Test for sudo
user=$(whoami)
if [ $user != "root" ]
then
    echo "You must run this script with root privileges. Please use sudo" >&2
    exit 1
fi

ln -s /root/.bin/ops245-pt2/resettest.sh /usr/local/bin/resettest
ln -s /root/.bin/ops245-pt2/starttest.sh /usr/local/bin/starttest
ln -s /root/.bin/ops245-pt2/testsetup.sh /usr/local/bin/testsetup
ln -s /root/.bin/ops245-pt2/neton.sh /usr/local/bin/neton
ln -s /root/.bin/ops245-pt2/netoff.sh /usr/local/bin/netoff
ln -s /root/.bin/ops245-pt2/setlinks.sh /usr/local/bin/setlinks


