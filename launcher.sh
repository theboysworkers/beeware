#!/bin/bash
# Script to add Tayga route, update /etc/hosts, and rebuild the Kathara lab
# Each step is printed for better debugging and tracking

# --- STEP 1: Add Tayga route if it doesn't exist ---
GATEWAY="172.17.0.2"
ROUTE="172.17.0.128/25"
# ROUTE="193.110.0.0/24"
IFACE="docker0"

# Add Tayga route to host
if ! ip route show | grep -q "$ROUTE"; then
    echo "Route $ROUTE not found. Adding $ROUTE via $GATEWAY dev $IFACE"
    sudo ip route add $ROUTE via $GATEWAY dev $IFACE
    echo "✅ Route added."
else
    echo "✅ Route $ROUTE via $GATEWAY dev $IFACE already exists."
fi

# Update /etc/hosts with the specified domains ---
HOSTS_FILE="/etc/hosts"
IPV4="$GATEWAY"

DOMAINS=("helpdesk.theboys.it" "mail.theboys.it" "manager.theboys.it" "sysloghub.theboys.it"        # wsa1's virtual host
         "ecopulse.theboys.it" "invest.theboys.it" "quix.theboys.it" "techsolve.theboys.it"         # wsa2's virtual host
         "agency.theboys.it" "blackhoney.theboys.it" "myrecipe.theboys.it" "puffcats.theboys.it")   # wsn's virtual host

echo "✅ Updated /etc/hosts with ip <-> domain"
if ! grep -q  "Beeware hosts" "$HOSTS_FILE"; then
    cat <<EOF >> "$HOSTS_FILE"
####################################
#           Beeware hosts          #
####################################
# wsa2
172.17.0.134   blackhoney.theboys.it
172.17.0.134   invest.theboys.it
172.17.0.134   quix.theboys.it
172.17.0.134   techsolve.theboys.it
# wsn
172.17.0.135   agency.theboys.it
172.17.0.135   ecopulse.theboys.it
172.17.0.135   myrecipe.theboys.it
172.17.0.135   puffcats.theboys.it
EOF
fi

# for domain in "${DOMAINS[@]}"; do
#     if ! grep -q "$domain" "$HOSTS_FILE"; then
#         echo "$IPV4 $domain" >> "$HOSTS_FILE"
#     fi
# done

# Clean the Kathara lab ---
kathara wipe -f && echo "✅ Kathara lab cleaned."

# Run the main Python script ---
python3 python/main.py && echo "✅ Python script completed."
