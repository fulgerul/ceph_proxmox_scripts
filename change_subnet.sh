#https://forum.proxmox.com/threads/changing-ceph-public-network.33083/
## NOT TESTED YET, ONLY A STUB!

# While the mon is running on the old IP
ceph mon getmap -o monmap.txt && monmaptool --print monmap.txt

# Remove current monitor from the monmap file
monmaptool --rm $HOSTNAME monmap.txt

# Add monitor with new ip to the monmap file
monmaptool  --add  $HOSTNAME 10.0.0.x:6789  monmap.txt && monmaptool --print monmap.txt

systemctl stop ceph-mon@*

# Inject this new monmap into the hurrent monitor
ceph-mon -i $HOSTNAME --inject-monmap monmap.txt

reboot


# change the configs
vi /etc/ceph.conf
vi /etc/storage.conf
# start the monitors and wait a few seconds. the cluster should be OK then with the new IPs.
systemctl start mon

# Restart everything
systemctl stop ceph\*.service ceph\*.target
systemctl start ceph.target
