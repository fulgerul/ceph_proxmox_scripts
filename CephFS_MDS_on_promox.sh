#
# Install Ceph MDS on Proxmox 5.2
#

## On MDS Node 1 (name=pve11 / ip 192.168.1.11)
apt-get install ceph-mds -y
mkdir -p /var/lib/ceph/mds/ceph-$HOSTNAME
chown -R ceph:ceph /var/lib/ceph/mds/ceph-$HOSTNAME
ceph --cluster ceph --name client.bootstrap-mds --keyring /var/lib/ceph/bootstrap-mds/ceph.keyring auth get-or-create mds.$HOSTNAME osd 'allow rwx' mds 'allow' mon 'allow profile mds' -o /var/lib/ceph/mds/ceph-$HOSTNAME/keyring

vi /etc/ceph/ceph.conf

[mds]
         mds data = /var/lib/ceph/mds/ceph-$id
         keyring = /var/lib/ceph/mds/ceph-$id/keyring
[mds.pve11]
        host = 192.168.1.11

systemctl start ceph-mds@$HOSTNAME
# Status should read started
systemctl status ceph-mds@$HOSTNAME
# Enable at start
systemctl enable ceph-mds@$HOSTNAME

## On MDS Node 2 (name=pve12 / ip 192.168.1.12)

# Define slave node name
apt install ceph-mds -y
mkdir -p /var/lib/ceph/mds/ceph-$HOSTNAME
chown -R ceph:ceph /var/lib/ceph/mds/ceph-$HOSTNAME
ceph --cluster ceph --name client.bootstrap-mds --keyring /var/lib/ceph/bootstrap-mds/ceph.keyring auth get-or-create mds.$HOSTNAME osd 'allow rwx' mds 'allow' mon 'allow profile mds' -o /var/lib/ceph/mds/ceph-$HOSTNAME/keyring

vi /etc/ceph/ceph.conf

[mds]
         mds data = /var/lib/ceph/mds/ceph-$id
         keyring = /var/lib/ceph/mds/ceph-$id/keyring
[mds.pve11]
        host = 192.168.1.11
[mds.pve12]
        host = 192.168.1.12

systemctl start ceph-mds@$HOSTNAME
# Status should read started
systemctl status ceph-mds@$HOSTNAME
# Enable at start
systemctl enable ceph-mds@$HOSTNAME


# Useful commands on the MDSes
ceph auth ls
ceph fs status






## Mounting the CephFS from Ubuntu 16

# Add authorization on ceph server

# Print master key (WARNING: This is read/write to all!)
ceph-authtool --name client.admin /etc/ceph/ceph.client.admin.keyring --print-key


# On client
sudo apt install ceph-common ceph-fs-common -y
sudo apt-get install ceph-fuse

sudo mkdir /etc/ceph
sudo vi /etc/ceph/admin.secret
# Paste master key

# Persistent CEPH FS mount
mkdir /mnt/ceph/
sudo vi /etc/fstab
192.168.1.11:6789,192.168.1.12:6789:/ /mnt/ceph/ ceph _netdev,name=admin,secretfile=/etc/ceph/admin.secret 0 0

# TODO: Authorize per folder instead of giving full access
