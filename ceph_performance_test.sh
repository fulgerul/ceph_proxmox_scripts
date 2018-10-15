rados bench -p ceph_pool 30 write
hdparm -t --direct /dev/sde
ceph tell osd.* bench
