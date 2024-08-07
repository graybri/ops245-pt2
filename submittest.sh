#!/usr/bin/env bash


# Test for sudo
user=$(whoami)
if [ $user != "root" ]
then
    echo "You must run this script with root privileges. Please use sudo" >&2
    exit 1
fi

# Variables
testlog=/var/log/ops245.log
testvarfile=/var/log/.testvars
semester="s24"
profacct="brian.gray"
profmail="brian.gray@senecapolytechnic.ca"
numdate="$(date +%s)"
source $testvarfile
submitfile="${senecaacct}-${section}-${numdate}.log"
matrixpath="/home/${profacct}/ops245/pt2/${semester}/${section}/"
suser=${SUDO_USER:-$USER}

# Adding .testvars contents
echo | tee -a $testlog
echo "TESTVARS" | tee -a $testlog
cat $testvarfile | tee -a $testlog
echo "SRAVTSET" | tee -a $testlog

# passwd 
echo | tee -a $testlog
echo "PASSWD" | tee -a $testlog
tail -5 /etc/passwd | tee -a $testlog
echo "DWSSAP" | tee -a $testlog

# group 
echo | tee -a $testlog
echo "GROUP" | tee -a $testlog
tail -5 /etc/group | tee -a $testlog
grep "^sudo" /etc/group | tee -a $testlog
echo "DWSSAP" | tee -a $testlog

# alias 
echo | tee -a $testlog
echo "ALIAS" | tee -a $testlog
grep "alias" ~ops245/.bash* /home/${suser}/.bash* | tee -a $testlog
echo "SAILA" | tee -a $testlog

# vim 
echo | tee -a $testlog
echo "VIM" | tee -a $testlog
dpkg -l vim | tail -1 | tee -a $testlog
echo "MIV" | tee -a $testlog

# DISK 
echo | tee -a $testlog
echo "DISK" | tee -a $testlog
fdisk -l /dev/vdb | tee -a $testlog
echo "KSID" | tee -a $testlog

# LVM 
echo | tee -a $testlog
echo "LVM" | tee -a $testlog
(lvs;vgs;pvs) | tee -a $testlog
echo "MVL" | tee -a $testlog

# Mount 
echo | tee -a $testlog
echo "MOUNT" | tee -a $testlog
df -h | grep "/dev" | tee -a $testlog
echo "TNUOM" | tee -a $testlog

# FSTAB 
echo | tee -a $testlog
echo "FSTAB" | tee -a $testlog
grep "^/dev" /etc/fstab | tee -a $testlog
echo "BATSF" | tee -a $testlog

# crontab 
echo | tee -a $testlog
echo "CRON" | tee -a $testlog
crontab -l -u ops245 | grep -v "^#" | tee -a $testlog
crontab -l -u $senecaacct | grep -v "^#" | tee -a $testlog
echo "NORC" | tee -a $testlog

# interfaces 
echo | tee -a $testlog
echo "INTERFACE" | tee -a $testlog
grep -vE "^#|^$" /etc/network/interfaces | tee -a $testlog
echo "ECAFRETNI" | tee -a $testlog

# hosts 
echo | tee -a $testlog
echo "HOSTS" | tee -a $testlog
grep -vE "^#|^$" /etc/hosts | tee -a $testlog
echo "STSOH" | tee -a $testlog

# ports 
echo | tee -a $testlog
echo "PORTS" | tee -a $testlog
ss -atnp | tee -a $testlog
echo "STROP" | tee -a $testlog

# sshd_config 
echo | tee -a $testlog
echo "SSHD" | tee -a $testlog
grep -E "Permit|Port" /etc/ssh/sshd_config | tee -a $testlog
echo "DHSS" | tee -a $testlog

# iptables 
echo | tee -a $testlog
echo "IPTABLES" | tee -a $testlog
iptables -L INPUT | tee -a $testlog
echo "SELBATPI" | tee -a $testlog

# iptables save 
echo | tee -a $testlog
echo "IPTSAVE" | tee -a $testlog
grep -H "INPUT" /etc/iptables* | tee -a $testlog
echo "EVASTPI" | tee -a $testlog

# iptables load 
echo | tee -a $testlog
echo "IPTLOAD" | tee -a $testlog
grep -H ".*" /etc/network/if-pre-up.d/* | tee -a $testlog
echo "DAOLTPI" | tee -a $testlog

# Save submit file
cp $testlog ~/backups/$submitfile

### Copy submit file to matrix

# Change interface to static
ifdown enp1s0
cp /root/backups/interfaces.static /etc/network/interfaces
ifup enp1s0

# Reset iptables
iptables -F
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT

# scp to matrix
scp ~/backups/$submitfile $senecaacct@matrix.senecapolytechnic.ca:$matrixpath


