#!/usr/bin/env bash


# Test for sudo
user=$(whoami)
if [ $user != "root" ]
then
    echo "You must run this script with root privileges. Please use sudo" >&2
    exit 1
fi

# Check /dev/vd*

echo "Virtual Disks"
ls /dev/vd*
echo

# Adding symlinks
echo "Adding symlinks"
/root/.bin/ops245-pt2/setlinks.sh

cat << EOT
Please check that you can login to matrix.senecapolytechnic.ca 
with your Seneca ID via ssh.

If successful run the command 'sudo resettest'
and shutdown this VM
EOT


