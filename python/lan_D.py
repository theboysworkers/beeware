from meta import lab

# LAN D
switchd = lab.new_machine("switchd", image="theb0ys/base")
lab.connect_machine_to_link("switchd", "M2", machine_iface_number = 0, mac_address="00:00:00:00:02:09")
lab.connect_machine_to_link("switchd", "D", machine_iface_number = 1)
lab.connect_machine_to_link("switchd", "D1", machine_iface_number = 2)
lab.create_startup_file_from_path(switchd, "machines_startup_script/switchd.sh")

pc1d = lab.new_machine("thinkpad", image="theb0ys/ubuntu-desktop")
lab.connect_machine_to_link("thinkpad", "D1", machine_iface_number = 0)
lab.create_startup_file_from_path(pc1d, "machines_startup_script/ubuntu-desktop.sh")

pc2d = lab.new_machine("thinkpad2", image="theb0ys/base")
lab.connect_machine_to_link("thinkpad2", "D1", machine_iface_number = 0)
pc2d.add_meta("sysctl", "net.ipv6.conf.eth0.accept_ra=2")
lab.create_startup_file_from_path(pc2d, "machines_startup_script/pcd.sh")
