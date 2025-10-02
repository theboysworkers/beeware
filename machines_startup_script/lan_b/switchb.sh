#!/bin/bash

# Create a new Linux bridge called 'mainbridge'
ip link add name mainbridge type bridge

# Add network interfaces to the bridge
ip link set dev eth1 master mainbridge   # Interface connected to cisco
ip link set dev eth2 master mainbridge   # Interface connected to wsa1
ip link set dev eth3 master mainbridge   # Interface connected to mdb
ip link set dev eth4 master mainbridge   # Interface connected to smb
ip link set dev eth5 master mainbridge   # Interface connected to mxs

# Bring the bridge interface up
ip link set up dev mainbridge

# Set the bridge ageing time to 600 seconds
brctl setageing mainbridge 600

# Create a new user 'sysrouter' with a home directory and password '2Password!' hashed
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '2Password!') sysrouter

# Start the SSH service
systemctl start ssh
