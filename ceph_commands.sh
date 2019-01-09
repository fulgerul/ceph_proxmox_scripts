# PG location on OSDs
ceph pg dump | awk  '{print $1 "\t" $2 "\t" $15 "\t" $16}'

# OSD -> PG allocation
ceph osd df plain | sort -rn -k 8

# Primary affinity <osd> <primary affinity>
ceph osd tree
ceph osd primary-affinity 0 1

# Update the WEIGHT of an OSD
ceph osd crush reweight osd.13 1.36497 # 1.4 tb

# Update the REWEIGHT of an OSD
ceph osd reweight osd.13 1.36497 # 1.4 tb

# Check performance stats on OSD
ceph daemon osd.7 perf dump | grep cache

# db_used_bytes = 0 & slow_used_bytes = high number = The DB is to small!
ceph daemon osd.2 perf dump | grep "db_used_bytes\|slow_used_bytes\|bluestore_compressed"

      # Same as above but nicer syntax! apt-get install jq -y
      ceph daemon osd.2 perf dump | jq -r '.bluefs'

# List disks
ceph-disk list


# Use following commands to see where the space is in Proxmox
Code:
pvs
vgs
lvs


## Moving from a larger HDD to an SSD Proxmox
# Dont have the OS HDD connected, LVM will error out "with A volume group called pve already exists"
# Upgrade BIOS to boot from external USB
# Get a different name (we will change it later)

# on client (mac) - edit out the old ssh key
vi .ssh/known_hosts
