#ceph osd crush rule create-replicated nvme_rule default host nvme

# One liner
# OSD=15 && ceph osd crush rm-device-class osd.$OSD && ceph osd crush set-device-class nvme osd.$OSD

ceph osd tree
read -p "Enter osd<number> to change class for: " osdnr
read -p "Enter class <hdd/ssd/nvme> to change to: " newclass

echo "*** Running ... ceph osd crush rm-device-class osd.$osdnr"
ceph osd crush rm-device-class osd.$osdnr

echo "*** Running ... ceph osd crush set-device-class $newclass osd.$osdnr"
ceph osd crush set-device-class $newclass osd.$osdnr
