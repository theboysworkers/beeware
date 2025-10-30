#!/bin/bash

# Assign an IPv6 address to interface eth0
ip address add 2a04:0:0:1::5/64 dev eth1

# Add a default IPv6 route via the gateway
ip -6 route add default via 2a04:0:0:0001::1 dev eth1

# Create a new user 'syserver' with a home directory and password '1Password!' hashed
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '1Password!') syserver

# Set DNS resolver to IPv6 nameserver
echo "nameserver 2a04::4" > /etc/resolv.conf

# Test the main rsyslog configuration file
rsyslogd -N1 -f /etc/rsyslog.conf

# Test an additional rsyslog configuration for forwarding logs
rsyslogd -N1 -f /etc/rsyslog.d/20-forward-logs.conf

# Start the rsyslog service
systemctl start rsyslog

# Start the postfix service
service postfix start

# Start the dovecot service
service dovecot start

# service mariadb start
# service apache2 start

# Append the rule that defines ListenAddress only on eth0 (VLAN managed M1)
echo "ListenAddress fe80::200:ff:fe00:b4%eth0" >> /etc/ssh/sshd_config 

# Start the SSH service
systemctl start ssh

