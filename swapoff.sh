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

