echo "dm_cache" >> /etc/initramfs-tools/modules
echo "dm_cache_mq" >> /etc/initramfs-tools/modules
echo "dm_persistent_data" >> /etc/initramfs-tools/modules
echo "dm_bufio" >> /etc/initramfs-tools/modules

update-initramfs -u
