#https://forum.proxmox.com/threads/changing-ceph-public-network.33083/
## NOT TESTED YET, ONLY A STUB!
cd /etc/pve/proxmox_custom_conf
monmaptool  --create  --add  pve11 172.16.1.11:6789 --add pve12 172.16.1.12:6789 --add pve13 172.16.1.13:6789 monmap | monmaptool --print monmap
then stop the monitors
# and reload the monmap into the ceph configuration (on all monitors - be sure to match the right mon-id):
# i = is the mon-id
ceph-mon -i 2 --inject-monmap monmap



# change the configs
vi /etc/ceph.conf
vi /etc/storage.conf
# start the monitors and wait a few seconds. the cluster should be OK then with the new IPs.
systemctl start mon

# Restart everything
systemctl stop ceph\*.service ceph\*.target
systemctl start ceph.target
