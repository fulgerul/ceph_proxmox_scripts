#!/bin/sh -e


# /etc/rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# fix for proxmox kernel swappiness problem, yes, it must be executed twice
for i in `/usr/bin/find /sys /var/lib 2>/dev/null | /bin/grep slice | /bin/grep swappiness` ; do /bin/echo 0 >"${i}" ; done
for i in `/usr/bin/find /sys /var/lib 2>/dev/null | /bin/grep slice | /bin/grep swappiness` ; do /bin/echo 0 >"${i}" ; done

exit 0

# Dont forget: chmod +x /etc/rc.local
# swapoff -a

# cat /sys/fs/cgroup/memory/system.slice/pvedaemon.service/memory.swappiness
# should be 0

# free -m
# Should say Swap used: 0

# grep "Hugepagesize:" /proc/meminfo
# Should say 2048 or 4096


# In /etc/sysctl.conf
# vm.swappiness=0
# vm.vfs_cache_pressure=50
# vm.dirty_background_ratio = 5
# vm.dirty_ratio = 10
# vm.min_free_kbytes=2097152
# vm.zone_reclaim_mode=1
# vm.nr_hugepages = 4300
