ceph osd tree
read -p "Enter phantom OSD to be killed: " answer

ceph osd out $answer
ceph osd crush remove osd.$answer
ceph auth del osd.$answer
ceph osd rm $answer

ceph osd tree
