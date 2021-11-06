# Default: 180000
ceph osd pool set cache_pool target_max_objects 1

ceph osd pool get cache_pool hit_set_period
ceph osd pool get cache_pool hit_set_fpp
ceph osd pool get cache_pool hit_set_count
ceph osd pool get cache_pool min_read_recency_for_promote
ceph osd pool get cache_pool min_write_recency_for_promote

ceph osd pool get cache_pool cache_target_dirty_ratio
ceph osd pool get cache_pool cache_target_dirty_high_ratio
ceph osd pool get cache_pool cache_target_full_ratio
ceph osd pool get cache_pool target_max_objects
ceph osd pool get cache_pool cache_min_flush_age
ceph osd pool get cache_pool cache_min_evict_age
ceph osd pool get cache_pool target_max_bytes

# ceph osd pool set cache_pool hit_set_period 1800
# ceph osd pool set cache_pool target_max_bytes 190000000000 # 190gb
# ceph osd pool set cache_pool min_write_recency_for_promote 8
# ceph osd pool set cache_pool min_read_recency_for_promote 8

# ceph osd pool set foo-hot cache_target_dirty_ratio .9
# ceph osd pool set foo-hot cache_target_dirty_high_ratio .8
# ceph osd pool set foo-hot cache_target_full_ratio .9
# ceph osd pool set cache_pool target_max_objects 100000

# ceph osd pool set cache_pool cache_min_flush_age 600
# ceph osd pool set cache_pool cache_min_evict_age 1800
