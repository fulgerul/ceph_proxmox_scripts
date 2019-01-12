ceph pg dump | grep -i incons | cut -f1 -d" " | while read i; do ceph pg repair ${i}; echo "Repairing ${i}\n" ; done
