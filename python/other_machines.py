from meta import lab

# Red hornet
red_hornet = lab.new_machine("red_hornet", image = "theb0ys/red-hornet:latest")
red_hornet.add_meta("sysctl", "net.ipv6.conf.eth0.accept_ra=2")
# Connect the machine 'red_hornet' to a specific link for testing
lab.connect_machine_to_link("red_hornet", "A", machine_iface_number = 0)
lab.create_startup_file_from_path(red_hornet, "machines_startup_script/redhornet.sh")


# Wireshark
# wireshark = lab.new_machine("wireshark", image = "lscr.io/linuxserver/wireshark", bridged = True)
# wireshark.add_meta("sysctl", "net.ipv6.conf.eth0.accept_ra=2")
# wireshark.add_meta("port", "3000:3000/tcp")
# # Connect the machine 'wireshark' to a specific link for testing
# lab.connect_machine_to_link("wireshark", "A", machine_iface_number = 0)

# Suricata - Network Intrusion Detection System (NIDS)
# suricata = lab.new_machine("suricata", image="theb0ys/suricata", bridged=True)
# suricata.add_meta("sysctl", "net.ipv6.conf.eth0.accept_ra=2")
# suricata.add_meta("sysctl", "net.ipv6.conf.eth1.accept_ra=2")
# suricata.add_meta("sysctl", "net.ipv6.conf.eth2.accept_ra=2")
# suricata.add_meta("sysctl", "net.ipv6.conf.eth3.accept_ra=2")
# suricata.add_meta("sysctl", "net.ipv6.conf.eth4.accept_ra=2")
# suricata.add_meta("sysctl", "net.ipv6.conf.eth5.accept_ra=2")
# lab.connect_machine_to_link("suricata", "A", machine_iface_number = 0)
# lab.connect_machine_to_link("suricata", "B", machine_iface_number = 1)
# lab.connect_machine_to_link("suricata", "C", machine_iface_number = 2)
# lab.connect_machine_to_link("suricata", "S", machine_iface_number = 3) 
# lab.connect_machine_to_link("suricata", "D", machine_iface_number = 4) 
# lab.connect_machine_to_link("suricata", "O", machine_iface_number = 5) 
# lab.get_machine("suricata").create_file_from_path("machines_configurations/suricata/suricata.yaml", "/etc/suricata/suricata.yaml")
# lab.get_machine("suricata").create_file_from_path("machines_configurations/suricata/suricata.rules", "/etc/suricata/rules/suricata.rules")
# lab.create_startup_file_from_path(suricata, "machines_startup_script/suricata.sh")
