# On the client machine - clear old IP ssh key
vi .ssh/known_hosts

# Swap to free distroupgrade
echo -e "deb http://ftp.se.debian.org/debian stretch main contrib\n\n# security updates\ndeb http://security.debian.org stretch/updates main contrib\ndeb http://download.proxmox.com/debian stretch pve-no-subscription" > /etc/apt/sources.list
echo "" > /etc/apt/sources.list.d/pve-enterprise.list

apt-get update
apt-get dist-upgrade -y
apt-get upgrade -y
apt-get install iperf3 net-tools nmon -y

reboot

# Make sure the network cards are setup!

# .11 is one of the cluster nodes
pvecm add 192.168.1.11

## Full reset of cluster - run on all nodes
# systemctl stop pve-cluster
# systemctl stop corosync
# pmxcfs -l
## Backup
# cp -R /etc/pve etcpve/
# rm /etc/pve/corosync.conf
# rm -R /etc/corosync/*
# killall pmxcfs
# rm -R /var/lib/corosync/*
# systemctl start pve-cluster
# pvecm create HOMELAB

# In case of ""* this host already contains virtual guests"
# "Check if node may join a cluster failed!""
# pvecm add 192.168.1.11 -force
pveceph install --version luminous

# edit ceph.conf
pveceph createmon & pveceph createmgr
PS1='\[\e]2;\u@\H \w\a${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# .bashrc
# /etc/sysctl.conf
# /etc/apt/sources.list
# /etc/apt/sources.list.d/pve-enterprise.list
# zap_disk.sh
# iperf -s
# iperf3 -P 20 -c 172.16.1.13
# /etc/network/interfaces

# create a bond of 2 nics with broadcast on 2 slave ports
#
# iface ens1 inet manual
#
# iface ens1d1 inet manual
#
# auto bond0
# iface bond0 inet static
#        address  172.16.1.11
#        netmask  255.255.0.0
#        slaves ens1 ens1d1
#        bond_miimon 100
#        bond_mode broadcast
#        mtu 9000

# cat /proc/net/bonding/bond0
# /etc/init.d/networking stop && /etc/init.d/networking start
