## Cannot use Gluster in Proxmox as migrations can only be done in ceph
## Cannot use more than 2 hosts in fstab (1 configured down below!) on clients
# Can use Gluster for docker-image repository
# Due to faster transfer rate - maybe use Glusterx2/stripe as primary and Cephx3 as backup
# Need to test stripes + nvme cache first 

gluster volume set gv0 cluster.min-free-disk 10% # Dont panic when at 100% capacity

gluster volume set gv0 performance.cache-size 25GB # Read-cache size
gluster volume set gv0 performance.cache-max-file-size 128MB

gluster volume set gv0 performance.flush-behind on # default, ack the flush()-yes-i-have-written-to-disk RAM
# Small file performance - in the client cache
# gluster volume set <volname> performance.cache-invalidation on
# gluster volume set <volname> features.cache-invalidation on
# gluster volume set <volname> performance.qr-cache-timeout 600 --> 10 min recommended setting
# gluster volume set <volname> cache-invalidation-timeout 600 --> 10 min recommended setting

# Stats!
gluster volume profile gv0 [start|info|stop] # get stats!
gluster volume top gv0 [read-perf|write-perf] # get stats!

## gstatus 
curl -LO https://github.com/gluster/gstatus/releases/download/v1.0.6/gstatus
chmod +x ./gstatus
sudo mv ./gstatus /usr/local/bin/gstatus
gstatus --all

## Install client
sudo add-apt-repository ppa:gluster/glusterfs-9
sudo apt update
sudo apt upgrade
sudo apt install glusterfs-client
sudo mount -t glusterfs 192.168.1.161:/gv0 /mnt/gluster
nano /etc/fstab -> 192.168.1.161:/gv0 /mnt/gluster glusterfs defaults,_netdev 0 0 # OBS! SPOF!

# untested
gluster volume set gv0 nfs.disable on # if we dont use nfs
performance.write-behind-window-size
performance.cache-refresh-timeout 1
performance.read-ahead off
