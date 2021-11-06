
# Install OpenCAS on Proxmox (6.3)
# Goal: Add Nvme AND RAM disk to a big slow device
apt install pve-headers

git clone https://github.com/Open-CAS/open-cas-linux
cd open-cas-linux
git submodule update --init
./configure

# apt install debhelper devscripts dkms
# make deb
# apt install ./packages/open-cas-linux*.deb
# This is an attempt to make a cleaner install but it fails with:
# --- Building binary DEB packages
#  dpkg-buildpackage -us -uc -ui -b
# dpkg-buildpackage: info: source package open-cas-linux
# dpkg-buildpackage: info: source version 21.03.0.0495.master-1
# dpkg-buildpackage: info: source distribution trusty
# dpkg-buildpackage: info: source changed by Rafal Stefanowski <rafal.stefanowski@intel.com>
#  dpkg-source --before-build .
# dpkg-buildpackage: info: host architecture amd64
# dpkg-checkbuilddeps: error: Unmet build dependencies: gawk libelf-dev linux-headers-generic
# dpkg-buildpackage: warning: build dependencies/conflicts unsatisfied; aborting
# dpkg-buildpackage: warning: (Use -d flag to override.)
# debuild: fatal error at line 1182:
# dpkg-buildpackage -us -uc -ui -b failed

make
make install
casadm -V

## NOTE: ZRAM - with LZ4 compresion - should run sooo fast. 
## But OpenCAS will not take it as the logical sector size is 
## HARDCODED to 4096 (which differs from a HDD that usually has 512!)
# Create the RAM disk https://pve.proxmox.com/wiki/Zram
# modprobe zram
# zramctl --size 16G /dev/zram0
# zramctl -a lz4 --size 16G  /dev/zram0
# Output:
# root@pve21:~/open-cas-linux# zramctl
# NAME       ALGORITHM DISKSIZE DATA COMPR TOTAL STREAMS MOUNTPOINT
# /dev/zram0 lz4            16G   0B    0B    0B      12

## Create a tmpfs RAM disk (tmpfs = size limit but might use swap. 
#ramfs = no RAM limit but...NO RAM LIMIT)
modprobe brd rd_size=15918884 rd_nr=1

# Make it persistant

# RAM disk CAS trick - https://github.com/Open-CAS/open-cas-linux/issues/679
ln -s /dev/ram0 /dev/disk/by-id/ramdisk0

# Get NVME disk/by-id
hwinfo --disk --only /dev/nvme0n1

# Write-Back cache
casadm -S -d /dev/devibyid/nvmen0n1 -i 1 -c wb --cache-line-size 64 --force && casadm -L

# Add HDD to the nvme cache device 1
casadm -A -d /dev/disk/by-id/wwn-0x5000cca26ff6b8ed -i 1

# Now create a RAM cache
casadm -S -d /dev/ram0 -i 2 -c wb --force

# Now move first nvme+hdd under this new RAM cache, nr 2
casadm -A -i 2 -d /dev/cas1-1

# Wipe cas2-1
gdisk /dev/cas2-1
x -> z -> y -> y
or
sgdisk --zap-all /dev/sdg

# In /etc/lvm/lvm.conf
 types = [ "cas", 16 ]

## Might need to run sh /mnt/pve/ceph_fs_proxmox/proxmox_custom_conf/zap_disk.sh first

# Manually create the OSD ontop of the RAM cache who has nvmen01+HDD under
# Check if it works with /dev/sda ?
ceph-volume lvm prepare --data /dev/cas2-1

systemctl start ceph-osd@{osd-num}

# Make small reads go to RAM, rest to NVME
casadm -X -n seq-cutoff -i 2 -j 1 -p always -t 4096
casadm --set-param --name promotion-nhit --cache-id 1 --threshold 2
casadm -X -n seq-cutoff -i 1 -j 1 -p never -t 4194181

# Set cache policy to aggresive
casadm -X -n cleaning -i 1 -p acp


## Set the cache into maintainance mode
casadm --set-cache-mode --cache-mode pt --cache-id 2 --flush-cache yes

## Set the cache BACK from maintainance mode
casadm --set-cache-mode --cache-mode wb --cache-id 1



# Fluuush
casadm --flush-cache --cache-id 2

# Start nvme after REBOOT
casadm -S -d /dev/disk/by-id/nvme-SAMSUNG_MZ1LB960HAJQ-00007_S435NA0MB02796 -i 1 -c wb --cache-line-size 64 --load

# CAS should now be ready to start. For example, to use block device /dev/nvme0n1 as a caching device:
casadm -S -d /dev/nvme0n1

# The output should return the cache instance number, use it to add a backend device. For example, to use block device /dev/sda1 as a backend device to cache instance 1:
casadm -A -d /dev/sda1 -i 1

# Verify CAS instance is operational with:
casadm -L
casadm --get-param --name promotion-nhit --cache-id 1
casadm --get-param --name seq-cutoff --cache-id 2 --core-id 1
casadm --stats --cache-id 1

# Enable autostart
systemctl enable open-cas
systemctl enable open-cas-shutdown
vi /etc/opencas/opencas.conf

# The output should state status is Running. Additionally, a command to list block devices such as lsblk should show the exported CAS device for example /dev/cas1-1

# To stop the cache device execute a command similar to casadm -T -i 1.

# casadm -S -d /dev/nvme2n1p1 -c wb   --force       // Create a new cache device, and return cache ID
# casadm -A -i -d /dev/sda                          // Add the backend device to the cache device and “merge” into a new CAS device
# casadm -L                                         // View current Open-CAS configuration information
// The configuration for each cache ID
# casadm -X -n seq-cutoff -i 1 -j 1 -p always -t 16   // seq-cutoff always and threshold 16KB

casadm --remove-core --cache-id 1 --core-id 1

# Remove a non-attached cache
casadm -T -i 1