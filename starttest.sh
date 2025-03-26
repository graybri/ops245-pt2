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
stumail=""
profmail="brian.gray@senecapolytechnic.ca"
numdate="$(date +%s)"
section=""

# Backup existing testlog
if [ -f $testlog ]
then
    mv $testlog /root/backups/test-${numdate}.log
    rm $testlog
fi

# HEADERS
clear
echo "OPS245 Practical Final Test Start" | tee -a $testlog
echo "=================================" | tee -a $testlog
echo | tee -a $testlog
date +%c | tee -a $testlog

# Get email
until echo $stumail | egrep -q "myseneca.ca$|senecapolytechnic.ca$" 
do
    echo -n "Please enter your (complete) Seneca College Email Address: "
    read stumail
done
senecaacct=$(echo $stumail | cut -d'@' -f1)

# Get Section
until echo $section | egrep -q "^(NDD)$"
do
    echo -n "Please enter your section (NDD): "
    read section
done

# Change interface to maual
ifdown enp1s0
cp /root/backups/interfaces.start /etc/network/interfaces
ifup enp1s0    

echo | tee -a $testlog
echo "Seneca ID: $senecaacct" | tee -a $testlog
echo "Seneca Email: $stumail" | tee -a $testlog
echo "Section: $section" | tee -a $testlog
echo | tee -a $testlog

sleep 1

# Save Vars
echo "start=\"$(date +%c)\"" > $testvarfile
echo "stumail=$stumail" >> $testvarfile
echo "senecaacct=$senecaacct" >> $testvarfile
echo "section=$section" >> $testvarfile

echo "Please start your test"


