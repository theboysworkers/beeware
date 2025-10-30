#!/bin/bash

# Create a new Linux bridge named 'mainbridge'
ip link add name mainbridge type bridge

# Add network interfaces to the bridge
ip link set dev eth1 master mainbridge   # Interface connected to cisco
ip link set dev eth2 master mainbridge   # Interface connected to oldap
ip link set dev eth3 master mainbridge   # Interface connected to syslog
ip link set dev eth4 master mainbridge   # Interface connected to bind1

# Bring the bridge interface up
ip link set up dev mainbridge

# Set the bridge ageing time to 600 seconds
brctl setageing mainbridge 600

# Create a new user 'siserver' and password '2Password!' encrypted with crypt()
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '2Password!') sysrouter

# Append the rule that defines ListenAddress only on eth0 (VLAN managed M2)
echo "ListenAddress fe80::200:ff:fe00:f1%eth0" >> /etc/ssh/sshd_config

# Start the SSH service
systemctl start ssh
