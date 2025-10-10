#!/usr/bin/python

from Kathara.manager.Kathara import Kathara
from Kathara.model.Machine import Machine
from Kathara.setting.Setting import Setting
from meta import lab

Setting.get_instance().enable_ipv6 = True

import backbone
import lan_A
import lan_B
import lan_C
import lan_S
import lan_D
import lan_O
# import pentesting
import nids

Kathara.get_instance().deploy_lab(lab)


from collections import defaultdict

stats = next(Kathara.get_instance().get_machines_stats(lab_name=lab.name))

interface_map = defaultdict(list)

# Build the interface -> machines map
for _, machine_info in stats.items():
    name = machine_info.name
    interfaces = machine_info.interfaces
    iface_list = [part.split(':')[1] for part in interfaces.split(', ')]

    for iface in iface_list:
        interface_map[iface].append(name)

# Neatly formatted and compact output
print("=== INTERFACE → MACHINES TOPOLOGY ===\n")
for iface in sorted(interface_map.keys()):
    machines_str = ' '.join(sorted(interface_map[iface]))
    print(f"{iface:<8} → {machines_str}")


#                      [NOTES]
#
# Networks M1 and M2 are two management networks used by system administrators 
# to connect remotely via SSH. To ensure that the hosts always maintain 
# the same IP address, MAC addresses are forced deterministically.
#
# The I, E, F1, F2, and F3 networks are used for routing. To ensure
# the proper operation of the routes, the routers connected to these 
# interfaces have link-local addresses set statically, enforced through 
# the configuration of MAC addresses.
#
#                        RADVD
# add_meta("sysctl", "net.ipv6.conf.eth0.accept_ra=2"
# Set the sysctl value to accept Router Advertisements on eth0 
# /proc/sys/net/ipv6/conf/eth0/accept_ra