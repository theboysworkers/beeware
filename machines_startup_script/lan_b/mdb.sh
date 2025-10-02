#!/bin/bash

# Add an IPv6 address to the network interface eth1
ip address add 2a04:0:0:1::3/64 dev eth1

# Set the default IPv6 gateway via 2a04:0:0:1::1 on interface eth1
ip -6 route add default via 2a04:0:0:0001::1 dev eth1

# Create a new user 'syserver' with a home directory and password '1Password!' hashed
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '1Password!') syserver

# Set the DNS resolver to IPv6 nameserver 2a04::4
echo "nameserver 2a04::4" > /etc/resolv.conf

# Test the main rsyslog configuration file
rsyslogd -N1 -f /etc/rsyslog.conf

# Test an additional rsyslog configuration for forwarding logs
rsyslogd -N1 -f /etc/rsyslog.d/20-forward-logs.conf

# Start the rsyslog service
systemctl start rsyslog

# Start the MariaDB service
service mariadb start

# Import SQL commands from /root/{manager,rsyslog}.sql into MySQL after start MariaDB server
mysql < /root/helpdesk.sql && rm /root/helpdesk.sql
mysql < /root/manager.sql && rm /root/manager.sql
mysql < /root/rsyslog.sql && rm /root/rsyslog.sql
mysql < /root/roundcube.sql && rm /root/roundcube.sql

# Append the rule that defines ListenAddress only on eth0
echo "ListenAddress fe80::200:ff:fe00:105%eth0" >> /etc/ssh/sshd_config

# Start the SSH service
systemctl start ssh


