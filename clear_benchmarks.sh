rados -p ceph_pool ls > ls.txt
cat ls.txt|grep 'benchmark_data'|xargs -n 1 rados -p ceph_data rm
rm ls.txt
