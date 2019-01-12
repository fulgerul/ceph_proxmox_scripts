rados bench -p ceph_pool 30 write --no-cleanup && rados bench -p ceph_pool 30 seq && rados bench -p ceph_pool 30 rand && rados -p ceph_pool cleanup
rados bench -p ceph_pool 30 write
hdparm -t --direct /dev/sde
ceph tell osd.* bench
dd if=/dev/zero of=test.file bs=100M count=2 && rm test.file
