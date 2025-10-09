#!/bin/bash

# Assign an IPv6 address to interface eth0
ip address add 2a04:0:0:10::3/64 dev eth1

# Add a default IPv6 route via the gateway
ip -6 route add default via 2a04:0:0:0010::1 dev eth1

# Add static hostname mappings for local services
# Lan A
echo 'fe80::200:ff:fe00:a1 oldap.local'   >> /etc/hosts
echo 'fe80::200:ff:fe00:a2 syslog.local'  >> /etc/hosts
echo 'fe80::200:ff:fe00:a3 bind1.local'   >> /etc/hosts
# Lan B
echo 'fe80::200:ff:fe00:b1 wsa1.local'  >> /etc/hosts
echo 'fe80::200:ff:fe00:b2 mdb.local'   >> /etc/hosts
echo 'fe80::200:ff:fe00:b3 smb.local'   >> /etc/hosts
echo 'fe80::200:ff:fe00:b4 mxs.local'   >> /etc/hosts
# Lan C
echo 'fe80::200:ff:fe00:c1 wsa2.local'  >> /etc/hosts
echo 'fe80::200:ff:fe00:c2 wsn.local'   >> /etc/hosts
echo 'fe80::200:ff:fe00:c3 ovpn.local'  >> /etc/hosts
echo 'fe80::200:ff:fe00:c4 bind2.local' >> /etc/hosts
# Lan S
echo 'fe80::200:ff:fe00:111 pc1s.local'  >> /etc/hosts

# Configure DNS resolver
echo "nameserver 2a04::4" > /etc/resolv.conf


