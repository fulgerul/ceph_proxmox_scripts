#!/bin/sh
for i in `grep -l Gbps /sys/class/ata_link/*/sata_spd`; do
echo Link "${i%/*}" Speed `cat $i`
cat "${i%/*}"/device/dev*/ata_device/dev*/id | perl -nE 's/([0-9a-f]{2})/print chr hex $1/gie' | echo "    " Device `strings`
done

dmesg | grep 'ata[0-50]\+.[0-9][0-9]: ATA-' | sed 's/^.*\] ata//' | sort -n | sed 's/:.*//' | awk ' { a="ata" $1; printf("%10s is /dev/sd%c\n", a, 96+NR); }'
smartctl -x /dev/sdc | grep -E "^Model Family|^Device Model|^Serial Number|^Firmware Version|^User Capacity|^SATA Version"
hdparm -I /dev/sdb |grep -E "Model|speed|Serial"
lshw -class disk -class storage -short
lsblk -d -n -oNAME,RO | grep '0$' | awk {'print $1'}
