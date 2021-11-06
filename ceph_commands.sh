# PG location on OSDs
ceph pg dump | awk  '{print $1 "\t" $2 "\t" $15 "\t" $16}'

# OSD -> PG allocation
ceph osd df plain | sort -rn -k 8

# Order a reweight by utilization
ceph osd reweight-by-utilization

# Primary affinity <osd> <primary affinity>
ceph osd tree
ceph osd primary-affinity 0 1

# Check performance stats on OSD
ceph daemon osd.7 perf dump | grep cache
