#!/bin/bash

# Assign an IPv6 address to interface eth1
ip address add 2a04:0:0:2::4/64 dev eth1

# Add a default IPv6 route through the gateway
ip -6 route add default via 2a04:0:0:2::1 dev eth1

# Create a new user 'sisersyserverver' and password '1Password!' (hashed)
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '1Password!') syserver

# Set DNS resolver to IPv6 nameserver
echo "nameserver 2a04::4" > /etc/resolv.conf

# Test the main rsyslog configuration file
rsyslogd -N1 -f /etc/rsyslog.conf

# Test an additional rsyslog configuration for forwarding logs
rsyslogd -N1 -f /etc/rsyslog.d/20-forward-logs.conf

# Start the rsyslog service
systemctl start rsyslog

# Append the rule that defines ListenAddress only on eth0
echo "ListenAddress fe80::200:ff:fe00:110%eth0" >> /etc/ssh/sshd_config

# Start the SSH service
systemctl start ssh


#!/bin/bash
set -e

# ========================================
# OpenVPN + Easy-RSA Automated Setup Script (for Docker/LXC)
# ========================================

EASYRSA_DIR="/etc/openvpn/easy-rsa"
PKI_DIR="$EASYRSA_DIR/pki"
OVPN_CLIENT_DIR="/etc/openvpn/client-configs"

# echo "🔧 Installing dependencies..."
# apt update -y
# apt install -y openvpn easy-rsa iptables

mkdir -p "$EASYRSA_DIR" "$OVPN_CLIENT_DIR"
cd "$EASYRSA_DIR"

# Initialize PKI
/usr/share/easy-rsa/easyrsa init-pki

# Configure vars
cat > "$PKI_DIR/vars" <<EOF
set_var EASYRSA_ALGO      ec
set_var EASYRSA_CURVE     secp521r1
set_var EASYRSA_DIGEST    sha512
set_var EASYRSA_REQ_COUNTRY    "IT"
set_var EASYRSA_REQ_PROVINCE   "RM"
set_var EASYRSA_REQ_CITY       "Rome"
set_var EASYRSA_REQ_ORG        "TheB0ysVPN"
set_var EASYRSA_REQ_EMAIL      "admin@theboys.it"
set_var EASYRSA_REQ_OU         "Security"
set_var EASYRSA_BATCH          "1"
EOF

echo "🔐 Building CA..."
/usr/share/easy-rsa/easyrsa --batch build-ca nopass

echo "🖥 Generating server certificate..."
/usr/share/easy-rsa/easyrsa --batch gen-req server nopass
/usr/share/easy-rsa/easyrsa --batch sign-req server server

echo "👤 Generating client certificate..."
/usr/share/easy-rsa/easyrsa --batch gen-req client1 nopass
/usr/share/easy-rsa/easyrsa --batch sign-req client client1

echo "🔑 Generating DH and TLS key..."
/usr/share/easy-rsa/easyrsa gen-dh
openvpn --genkey --secret ta.key

echo "📁 Organizing certificates..."
cp pki/ca.crt /etc/openvpn/
cp pki/issued/server.crt /etc/openvpn/
cp pki/private/server.key /etc/openvpn/
cp pki/issued/client1.crt /etc/openvpn/
cp pki/private/client1.key /etc/openvpn/
cp pki/dh.pem /etc/openvpn/
cp ta.key /etc/openvpn/

# Create server.conf
cat > /etc/openvpn/server.conf <<EOF
port 1194
proto udp
dev tun

ca ca.crt
cert server.crt
key server.key
dh dh.pem
tls-crypt ta.key

server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 8.8.8.8"

keepalive 10 120
cipher AES-256-GCM
tls-version-min 1.2
ecdh-curve secp521r1
user nobody
group nogroup
persist-key
persist-tun
verb 3
EOF

echo "🌐 Enabling IPv4 forwarding..."
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# NAT (container-level, only if needed)
# Note: if container uses --network host, this may not be necessary.
echo "⚙️ Setting up basic NAT..."
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE || true

echo "🚀 Starting OpenVPN..."
systemctl enable openvpn@server
systemctl start openvpn@server

CLIENT_OVPN="$OVPN_CLIENT_DIR/client1.ovpn"
cat > "$CLIENT_OVPN" <<EOF
client
dev tun
proto udp
remote YOUR_SERVER_IP 1194
resolv-retry infinite
nobind
persist-key
persist-tun
cipher AES-256-GCM
tls-version-min 1.2
remote-cert-tls server
key-direction 1
verb 3

<ca>
$(cat /etc/openvpn/ca.crt)
</ca>

<cert>
$(cat /etc/openvpn/client1.crt)
</cert>

<key>
$(cat /etc/openvpn/client1.key)
</key>

<tls-crypt>
$(cat /etc/openvpn/ta.key)
</tls-crypt>
EOF

echo "✅ OpenVPN setup complete!"
echo "Client config: $CLIENT_OVPN"