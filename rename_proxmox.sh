# https://pve.proxmox.com/wiki/Renaming_a_PVE_node
## NOT TESTED YET, ONLY A STUB!

hostname <new_host_name>
hostname --ip-address
vi /etc/hostname
vi /etc/ceph/ceph.conf
vi /etc/corosync/corosync.conf
vi /etc/hosts
vi /etc/mailname
vi /etc/postfix/main.cf

mv /etc/pve/nodes/<old_host_name>/lxc/* /etc/pve/nodes/<new_host_name>/lxc
mv /etc/pve/nodes/<old_host_name>/qemu-server/* /etc/pve/nodes/<new_host_name>/qemu-server
# rm -r /etc/pve/nodes/<old_host_name>

mv /etc/pve/nodes/<oldnode>/qemu-server/*.conf /etc/pve/nodes/<newnode>/qemu-server

pvecm delnode OLDNODE

# You must also change the paths in /etc/pve
