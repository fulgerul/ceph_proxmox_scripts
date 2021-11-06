Ceph on ZFS
Rationale:
Wanting to get the most of my Samsung PM983 Enterprise NVMEs, and more speed in ceph I wanted to 
test ceph on top of a non-raidz ZFS to make use of the ARC, SLOG and L2ARC 

Prerequisites:
Proxmox (or Debian)
Working ceph installation (MON, MGR) 

/dev/sda = Spinning rust 12TB
/dev/sdb = Spinning rust 4TB
/dev/nvme01n1 = Samsung PM983 PLP 1TB



# Prepare the Nvme for special (metadata) 33gb , SLOG 10gb (not used when sync is on!) and cache
parted /dev/nvme0n1
mklabel gpt
mkpart primary 0 33GB
- mkpart primary 33GB 43GB # OPTIONAL SLOG 10gb (not used when sync is on!)
mkpart primary 33GB 256GB

# Clean the spinning disks
sgdisk --zap-all /dev/sda
sgdisk --zap-all /dev/sdb

# Clean any remaining ZFSes
zpool list
zpool destroy TestZFS

# Create a singular ZFS pool in GUI names ZFS-ceph

# Add more disks in cmdline - advantage of non-raidz is that sizes do not have to match on the drives. 
# But then you have no redundancy (we leave that to ceph!)
zpool add ZFS-ceph /dev/sdb

zpool add ZFS-ceph special /dev/nvme0n1p1
zpool add ZFS-ceph log /dev/nvme0n1p2 # OPTIONAL SLOG 10gb (not used when sync is on!)
zpool add ZFS-ceph cache /dev/nvme0n1p2

zfs set sync=disabled ZFS-ceph
zfs set atime=off ZFS-ceph
zfs set checksum=off ZFS-ceph # Leave the checksuming/scrubbing to ceph
zfs set xattr=sa ZFS-ceph

# Create volume device chunks from the pool. You should now get /dev/zd0 and /dev/zd16 etc
# They are all 2T to enable uniform distribution in ceph, but this might change as the 
# ceph OSDs chug 4gb per device! 
zfs create -V 2T ZFS-ceph/ceph-osd1 && ls /dev/zd* && zfs list
zfs create -V 2T ZFS-ceph/ceph-osd2 && ls /dev/zd* && zfs list
...


# ZAP and Create the ceph OSDs on top of the zd* devices. MAKE NOTE of the assigned OSD nr as 
# you will need those numbers to start them later
ls /dev/zd*  && ceph-volume lvm zap /dev/zd0
ceph-volume raw prepare --data /dev/zd0 --bluestore --no-tmpfs --crush-device-class hdd && ls /dev/zd*  
ceph-volume raw activate --device /dev/zd0 --no-tmpfs --no-systemd && ls /dev/zd*  

# Start the ceph OSD and add to start after reboot
systemctl start ceph-osd@0
systemctl enable ceph-osd@0

# Run Once - Tell udev to run ceph activate ceph everytime /dev/zd* comes online , otherwise ceph osd
# Also ensure that zd* is owned by ceph user
# will not start again after a reboot of the host due to /dev/zd shifting UUIDs
echo 'KERNEL=="zd*" SUBSYSTEM=="block" ACTION=="add|change" RUN+="ceph-volume raw activate --device /dev/%k --no-tmpfs --no-systemd"' >> /etc/udev/rules.d/99-perm.rules
echo 'KERNEL=="zd*" SUBSYSTEM=="block" ACTION=="add|change" OWNER="ceph", GROUP="ceph"' >> /etc/udev/rules.d/99-perm.rules
# Run Once - Turn off write cache on all disks
echo 'ACTION=="add", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", RUN+="/usr/sbin/smartctl -s wcache,off $kernel"' >> /etc/udev/rules.d/99-perm.rules


# DONE!

## TODO
- Remove a disk member from the ZFS pool
- Tuning of ARC 

########### Random commands

# Turn off write cache on all disks - will not persist a reboot until UDEV is coerced
for disk in /dev/sd{a..l}; do hdparm -W $disk && hdparm -W0 $disk; done

# Mount point 
zfs list
zfs get all ZFS-ceph/ceph-osd

zfs destroy ZFS-ceph/ceph-osd2

zfs set dedup=on ZFS-ceph # Crippled my system :(
zpool status -D
zpool list

ls -al /dev/zvol

udevadm control --reload
udevadm test /block/zd0









############# WARNING - HERE BE DRAGONS! #####################
45Drives Autotier on Gluster on ZFS - WARNING of DATALOSS!!!

Rationale:
Wanting to get the most of my Samsung PM983 Enterprise NVMEs, and more speed.

Prerequisites:
Proxmox (or Debian)
Working ceph installation (MON, MGR) 

/dev/sda = Spinning rust 12TB
/dev/sdb = Spinning rust 4TB
/dev/nvme01n1 = Samsung PM983 PLP 1TB

Gluster

/gluster
apt-get install glusterfs-server glusterfs-client
systemctl start glusterd
systemctl enable glusterd
gluster peer probe 172.16.1.22
gluster volume add-brick gfs-volume-proxmox replica 3 172.16.1.21:/autotier/ force
In Proxmox web interface select "Datacenter" > "Storage" > "Add" > "GlusterFS"
ID and two of the three server IP addresses (i.e from above)
Volume name from above (i.e. "gfs-volume-proxmox")
zfs set acltype=posixacl gfs-volume-proxmox

	/autotier 
wget https://github.com/45Drives/autotier/releases/download/v1.1.6/autotier_1.1.6-3bullseye_amd64.deb
apt install ./autotier_1.1.6-3bullseye_amd64.deb
cp /etc/pve/proxmox_custom_conf/autotier.conf /etc/autotier.conf
mkdir /autotier/
manually: # autotierfs /autotier/ -o allow_other,default_permissions
vi /etc/fstab: /usr/bin/autotierfs /autotier fuse allow_other,default_permissions 0 0
autotier status

		/PVE_ZFS
		/PVE_NVME
		sg-disk —zap-all /nvme01n1
	 	Create ZFS in pveGUI

REMOVE
gluster v status
gluster volume remove-brick gfs-volume-proxmox replica 3 172.16.1.24:/TestZFS force
apt-get remove autotier
apt-get remove glusterfs-server
rm /etc/autotier.conf
remove from /etc/fstab as well!



