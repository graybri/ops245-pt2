#!/usr/bin/env bash

# Test for sudo
user=$(whoami)
if [ $user != "root" ]
then
    echo "You must run this script with root privileges. Please use sudo" >&2
    exit 1
fi

# Remove users
for account in $(grep ":x:100[1-9]:" /etc/passwd | cut -d: -f1)
do
    userdel -r $account > /dev/null 2>&1
done

# Reset storage
umount /mariadb
rm -rf /mariadb
lvremove -y -q vg_data
vgremove -y -q vg_data
pvremove -y -q /dev/vdb1
echo -e "d\nw\n" | fdisk /dev/vdb

# Restore files
cp /root/backups/hosts /etc/
cp /root/backups/fstab /etc/
cp /root/backups/sshd_config /etc/ssh/
cp /root/backups/ops245.bashrc ~ops245/.bashrc
chown ops245:ops245 ~ops245/.bashrc

# Restart ssh
systemctl restart ssh

# Restart interface 
# This adds the static IPv4 config
# When the starttest script runs it will return the interface to manual
ifdown enp1s0
cp /root/backups/interfaces.static /etc/network/interfaces
ifup enp1s0

# Remove crontab for ops245
crontab -r -u ops245 

# Flush/Reset iptables
iptables -F
iptables -P INPUT ACCEPT
rm /etc/iptables*
rm /etc/network/if-pre-up.d/*

# Remove vim
apt -y remove vim

# End message
echo "Test Reset"
echo "Shutdown the VM"
echo "Start the VM at the start of the test"



