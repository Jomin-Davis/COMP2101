#!/bin/bash

# Using echo command for blank line which is easiest way to print a blank line.
echo

# Getting hostname
hostname=$(hostname)
echo Report for $hostname

# Seperator by using echo command
echo ===============================

# Getting FQDN using the hostname command
fqdn=$(hostname --fqdn)
echo FQDN: $fqdn

# Getting Operating System name and version with the help of awk command.
name_and_version=$(lsb_release -a | awk '/Description:/{print $2, $3, $4}')
echo Operating System name and version: $name_and_version

# Getting IP address of the machine which is used by computer for sending or receiving data.
ip_address=$(hostname -I)
echo IP Address: $ip_address

# Getting free space
free_space=$(df -h / | grep dev | awk '{print $4}')
echo Root Filesystem Free Space: $free_space

# Seperator by using echo command
echo ===============================

# Using echo command for blank line which is easiest way to print a blank line.
echo
