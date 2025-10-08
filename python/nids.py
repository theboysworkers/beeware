# NIDS - Network Intrusion Detection System
from meta import lab

suricata = lab.new_machine("suricata", image="theb0ys/suricata", bridged=True)
suricata.add_meta("sysctl", "net.ipv6.conf.eth0.accept_ra=2")
suricata.add_meta("sysctl", "net.ipv6.conf.eth1.accept_ra=2")
suricata.add_meta("sysctl", "net.ipv6.conf.eth2.accept_ra=2")
suricata.add_meta("sysctl", "net.ipv6.conf.eth3.accept_ra=2")
suricata.add_meta("sysctl", "net.ipv6.conf.eth4.accept_ra=2")
suricata.add_meta("sysctl", "net.ipv6.conf.eth5.accept_ra=2")
lab.connect_machine_to_link("suricata", "A", machine_iface_number = 0)
lab.connect_machine_to_link("suricata", "B", machine_iface_number = 1)
lab.connect_machine_to_link("suricata", "C", machine_iface_number = 2)
lab.connect_machine_to_link("suricata", "S", machine_iface_number = 3) 
lab.connect_machine_to_link("suricata", "D", machine_iface_number = 4) 
lab.connect_machine_to_link("suricata", "O", machine_iface_number = 5) 
lab.get_machine("suricata").create_file_from_path("machines_configurations/suricata/suricata.yaml", "/etc/suricata/suricata.yaml")
lab.get_machine("suricata").create_file_from_path("machines_configurations/suricata/suricata.rules", "/etc/suricata/rules/suricata.rules")
lab.create_startup_file_from_path(suricata, "machines_startup_script/suricata.sh")
