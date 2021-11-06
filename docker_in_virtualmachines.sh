sed -i 's/.*ExecStart=/usr/bin/dockerd -H fd:\/\/.*/ExecStart=/usr/bin/dockerd -H -g /mnt/ceph/docker-images/docker_img_cache fd:\/\//' /lib/systemd/system/docker.service
systemctl stop docker
systemctl daemon-reload
rsync -aqxP /var/lib/docker/ /mnt/ceph/docker-images/docker_img_cache/
systemctl start docker
