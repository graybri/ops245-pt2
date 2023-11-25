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
rmdir /mariadb
lvremove -y -q vg_data
vgremove vg_data
pvremove /dev/vdb1
echo -e "d\n1\n" | fdisk /dev/vdb

echo "LVM Reset?"
exit


# Restore files
cp /root/backups/hosts /etc/
cp /root/backups/fstab /etc/
#cp /root/backups/group /etc/
#cp /root/backups/passwd /etc/
cp /root/backups/sshd_config /etc/ssh/
cp /root/backups/ops245.bashrc ~ops245/.bashrc
chown ops245:ops245 ~ops245/.bashrc

echo "Files restored?"
exit

# Restart interface 
ifdown enp1s0
cp /root/backups/interfaces.static /etc/network/interfaces
ifup enp1s0

echo 'Interface Static?'
exit

# Remove vim
apt remove vim

echo "vim removed?"
exit

# Remove crontab for ops245
crontab -r -u ops245 

echo "crontab reset?"
exit

# Flush/Reset iptables
iptables -F
iptables -P INPUT ACCEPT
rm /etc/iptables*
rm /etc/network/if-pre-up.d/*

echo "iptables reset? (reboot)"
exit

echo "Test Reset"
echo "Shutdown the VM"
echo "Start the VM at the start of the test"



