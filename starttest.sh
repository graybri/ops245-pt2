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
stumail=""
profmail="brian.gray@senecacollege.ca"
numdate="$(date +%s)"
section=""

# Backup existing testlog
if [ -f $testlog ]
then
    mv $testlog /root/backups/test-${numdate}.log
fi

# HEADERS
clear
echo "OPS245 Practical Final Test Start" | tee -a $testlog
echo "=================================" | tee -a $testlog
echo | tee -a $testlog
date +%c | tee -a $testlog

# Get email
until echo $stumail | egrep -q "myseneca.ca$|senecacollege.ca$" 
do
    echo -n "Please enter your (complete) Seneca College Email Address: "
    read stumail
done
senecaacct=$(echo $stumail | cut -d'@' -f1)

# Get Section
until echo $section | egrep -q "^(NAA|NBB)$"
do
    echo -n "Please enter your section (NAA or NBB): "
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
echo "start=$(date +%c)" > /tmp/.testvars
echo "stumail=$stumail" >> /tmp/.testvars
echo "senecaacct=$senecaacct" >> /tmp/.testvars
echo "section=$section" >> /tmp/.testvars

echo "Please start your test"


