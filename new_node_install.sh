apt-get update
apt full-upgrade
apt-get install iperf3
apt-get install net-tools
pveceph install --version luminous
pveceph createmon
pveceph createmgr
pvecm add 192.168.1.12
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

# Reinstall of a node member
# ssh-keygen -f "/etc/ssh/ssh_known_hosts" -R "192.168.1.23"
# vi .ssh/known_hosts
# On the cluster: vi /etc/pve/corosync.conf
# Address to a working cluster node: pvecm add 192.168.1.21
