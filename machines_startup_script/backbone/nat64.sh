
#!/bin/bash

# TAYGA_CONF_IPV4_ADDR="172.17.0.2"
TAYGA_CONF_IPV4_ADDR="193.110.0.1"
TAYGA_CONF_PREFIX="2001:db8:64:ff9b::/96"
# TAYGA_CONF_DYNAMIC_POOL="172.17.0.128/25"
TAYGA_CONF_DYNAMIC_POOL="193.110.0.0/24"
TAYGA_CONF_DATA_DIR="/var/db/tayga"
TAYGA_CONF_DIR="/etc"

# ip scope global filo A
ip -6 address add fd00:dead:beef::1/48 dev eth0

# Create Tayga directories.
mkdir -p ${TAYGA_CONF_DATA_DIR} ${TAYGA_CONF_DIR}

# Configure Tayga
cat >${TAYGA_CONF_DIR}/tayga.conf <<EOF
tun-device nat64
ipv4-addr ${TAYGA_CONF_IPV4_ADDR}
prefix ${TAYGA_CONF_PREFIX}
dynamic-pool ${TAYGA_CONF_DYNAMIC_POOL}
data-dir ${TAYGA_CONF_DATA_DIR}

# map ipv4 to ipv6
# Lan B
map 193.110.0.12    2a04:0:0:1::2   # wsa1
map 193.110.0.13    2a04:0:0:1::3   # mdb
map 193.110.0.14    2a04:0:0:1::4   # smb
map 193.110.0.15    2a04:0:0:1::5   # mxs
# Lan C
map 193.110.0.22    2a04:0:0:2::2   # wsa2
map 193.110.0.23    2a04:0:0:2::3   # wsn
map 193.110.0.24    2a04:0:0:2::4   # ovpn
map 193.110.0.25    2a04:0:0:2::5   # bind2
EOF

# Setup Tayga networking
tayga -c ${TAYGA_CONF_DIR}/tayga.conf --mktun
ip link set nat64 up

# echo "172.17.0.202    2a04::2    1760189567" >> /var/db/tayga/dynamic.map
# echo "172.17.0.203    2a04::3    1760189567" >> /var/db/tayga/dynamic.map
# echo "172.17.0.204    2a04::4    1760189567" >> /var/db/tayga/dynamic.map

ip route add ${TAYGA_CONF_DYNAMIC_POOL} dev nat64
ip route add ${TAYGA_CONF_PREFIX} dev nat64

# ###########
# #####LOL
# ###########
# echo 'net.ipv6.conf.all.disable_ipv6=0' >> /etc/sysctl.conf
# echo 'net.ipv6.conf.all.forwarding=1' >> /etc/sysctl.conf
# sysctl -p


# Add nameserver
echo 'nameserver 2a04::4' >> /etc/resolv.conf

# Start the NGINX server
systemctl start nginx

# Run Tayga as the last because interrept others proceses
tayga -c ${TAYGA_CONF_DIR}/tayga.conf -d

