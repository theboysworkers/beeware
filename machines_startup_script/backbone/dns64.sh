#!/bin/bash

# Assign a global IPv6 address to eth0
ip address add fd00:dead:beef::200/48 dev eth0

# Add routes for tayga
ip route add 2001:db8:64:ff9b::/96 via fd00:dead:beef::1 dev eth0  metric 1024
ip route add default via fd00:dead:beef::1 dev eth0  metric 1024 

# Set the IPv6 nameserver
echo "fd00:dead:beef::200" >> /etc/resolv.conf

# Start the BIND9 DNS server
named -c /etc/bind/named.conf -g
