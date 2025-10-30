#!/bin/bash

# Create a new Linux bridge called "mainbridge"
ip link add name mainbridge type bridge

# Attach interfaces to the bridge
ip link set dev eth1 master mainbridge   # Interface connected to cisco-s
ip link set dev eth2 master mainbridge   # Interface connected to pc1s
ip link set dev eth3 master mainbridge   # Interface connected to pc2s

# Bring the bridge interface up
ip link set up dev mainbridge

# Set bridge MAC address aging time to 600 seconds
brctl setageing mainbridge 600

# Create a new user 'sirouter' with home directory and password '2Password!'
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '2Password!') sirouter

# Append the rule that defines ListenAddress only on eth0 (VLAN managed M2)
echo "ListenAddress fe80::200:ff:fe00:f4%eth0" >> /etc/ssh/sshd_config

# Start the SSH service
systemctl start ssh
