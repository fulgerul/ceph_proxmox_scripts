# PG location on OSDs
ceph pg dump | awk  '{print $1 "\t" $2 "\t" $15 "\t" $16}'

# Primary affinity <osd> <primary affinity>
ceph osd tree
ceph osd primary-affinity 0 1

# List disks
ceph-disk list
