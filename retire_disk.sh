ceph osd tree
read -p "Enter OSD <number> to be removed (rebalanced out): " answer

ceph osd crush reweight osd.$answer 0
