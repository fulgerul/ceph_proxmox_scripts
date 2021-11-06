# Get all disks health data from ceph

# Dep: smartctl 6.7+
# Dep: ceph mgr module enable diskprediction_local
# Dep: ceph device monitoring on
# Dep: ceph device scrape-health-metrics
# Dep: ceph config set global device_failure_prediction_mode local/cloud (need account!)
# Dep: apt-get install jq
for n in $( ceph -f json-pretty device ls | jq -r '.[].devid' ); do echo $n; ceph device predict-life-expectancy "$n"; done
