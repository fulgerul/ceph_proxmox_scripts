lsblk
read -p "Enter /dev/HDD<name> to be zapped: " devname

ceph osd tree

read -p "Enter osd.<nr> to be zapped: " osdnr


echo "*** Running ...\tsystemctl stop ceph-osd@$osdnr"
systemctl stop ceph-osd@$osdnr

echo "*** Running ...\tumount /var/lib/ceph/osd/ceph-$osdnr"
umount /var/lib/ceph/osd/ceph-$osdnr

echo "*** Running ...\tdd if=/dev/zero of=/dev/$devname bs=1M count=2048"
dd if=/dev/zero of=/dev/$devname bs=1M count=2048

echo "*** Running ...\tsgdisk -Z /dev/$devname\n" 
sgdisk -Z /dev/$devname

echo "*** Running ...\tsgdisk -g /dev/$devname\n"
sgdisk -g /dev/$devname

echo "*** Running ...\tpartprobe"
partprobe /dev/$devname

echo "*** Running ...\tceph osd out $osdnr\n"
ceph osd out $osdnr

echo "*** Running ...\tceph osd crush remove osd.$osdnr\n"
ceph osd crush remove osd.$osdnr

echo "*** Running ...\tceph auth del osd.$osdnr\n"
ceph auth del osd.$osdnr

echo "*** Running ...\tceph osd rm $osdnr\n"
ceph osd rm $osdnr

echo "*** Running ...\trmdir /var/lib/ceph/osd/ceph-$osdnr"
rmdir /var/lib/ceph/osd/ceph-$osdnr


echo "*** Running ...\tpartprobe\n"
partprobe /dev/$devname

echo "*** Running ...\tlsblk\n"
lsblk
