
#!/bin/bash

TAYGA_CONF_PREFIX="2001:db8:64:ff9b::/96"
TAYGA_CONF_DYNAMIC_POOL="172.17.0.128/25"

# ip scope global eth0
ip -6 address add fd00:dead:beef::1/48 dev eth0

# Create Tayga directories.
mkdir -p /var/db/tayga 

# Setup Tayga networking
tayga -c /etc/tayga.conf --mktun
ip link set nat64 up

# Add routes for tayga
ip route add ${TAYGA_CONF_DYNAMIC_POOL} dev nat64
ip route add ${TAYGA_CONF_PREFIX} dev nat64

# Add nameserver
echo 'nameserver 2a04::4' >> /etc/resolv.conf

# Start the NGINX server
systemctl start nginx

# Run Tayga as the last because interrept others proceses
tayga -c /etc/tayga.conf -d

