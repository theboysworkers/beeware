#!/bin/bash

# Assign an IPv6 address to interface eth1
ip address add 2a04:0:0:2::2/64 dev eth1

# Add a default IPv6 route through the gateway
ip -6 route add default via 2a04:0:0:0002::1 dev eth1

# Create a new user 'sisersyserverver' and password '1Password!' (hashed)
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '1Password!') syserver

# Set DNS resolver to IPv6 nameserver
echo "nameserver 2a04::4" > /etc/resolv.conf

# Test the main rsyslog configuration for syntax errors
rsyslogd -N1 -f /etc/rsyslog.conf

# Test the forwarding configuration for syntax errors
rsyslogd -N1 -f /etc/rsyslog.d/20-forward-logs.conf

# Restart the rsyslog service
systemctl restart rsyslog

# Set permissions to web root
chown -R www-data:www-data /var/www/html
chmod 770 -R /var/www/html/*

# Start the Apache web server
systemctl start apache2

# Start the MariaDB service
service mariadb start

# Import SQL commands from zenglish.sql into MySQL after start MariaDB server
mysql < /var/www/html/zenglish/zenglish.sql && rm /var/www/html/zenglish/zenglish.sql

# Append the rule that defines ListenAddress only on eth0 (VLAN managed M1)
echo "ListenAddress fe80::200:ff:fe00:c1%eth0" >> /etc/ssh/sshd_config

# Start the SSH service
systemctl start ssh

# Add capability to allow /bin/python3.11 to change user ID (setuid)
setcap cap_setuid+ep /bin/python3.11
