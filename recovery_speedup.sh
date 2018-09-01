ceph -s 
ceph daemon osd.0 config get osd_max_backfills
ceph daemon osd.0 config get osd_recovery_max_active
read -p "Speed? " answer
ceph tell 'osd.*' injectargs "--osd-max-backfills $answer" && ceph tell 'osd.*' injectargs "--osd-recovery-max-active $answer"
ceph -s | grep recovery
