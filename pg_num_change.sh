ceph osd lspools

read -p "Enter pool name: " pool_name

ceph osd pool get $pool_name pg_num
ceph osd pool get $pool_name pgp_num

read -p "Enter PG num: " pg_num


ceph osd pool set $pool_name pg_num $pg_num
ceph osd pool set $pool_name pgp_num $pg_num

ceph -s
