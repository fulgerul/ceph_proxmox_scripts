## Move docker image repo to ceph - to avoid disk full on docker hosts
sudo vi /etc/docker/daemon.json
{
    "storage-driver": "devicemapper",
    "data-root":"/mnt/ceph/docker-images/docker_data" # original /var/lib/docker
}
sudo service docker stop
sudo rsync -aP /var/lib/docker /mnt/ceph/docker-images/docker_data
sudo mv /var/lib/docker /var/lib/docker.orig
sudo service docker start


# 2021-05-21 
# This didn't work as expected (disk io errors! goes for both gluster and ceph, might be devicemapper) 
# and I was forced to move to a periodic crontab cleaning of img repo

# Periodic cleanup every day at 5
* 5 * * * sudo docker image prune --all --force