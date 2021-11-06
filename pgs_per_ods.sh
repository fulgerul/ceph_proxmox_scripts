#set -x
#
# Show information about the PGs in a ceph cluster.
# Especially show the PGs per OSD and the number of primary PGs per OSD.
# This script does not fix primary PG balancing issues but it displays valuable information
# The important number that shows imbalance issues is the Max/Ave ratio for primary PGs per OSD
#
# Usage: $0 [pool_name] [ceph_bin_dir]
# ======
#
# Written by Mark Kogan and Josh Salomon, Red Hat, 2019
#

if [[ $($CEPH pg dump 2>/dev/null | egrep -c "incomplete") -gt 0 ]]; then
  echo "inclomplete pgs found, please fix and restart"
  exit 1
fi

CEPH_DIR=${2:-"./bin"}
if [ -f "$CEPH_DIR/ceph" ]; then
	CEPH="$CEPH_DIR/ceph"
else
	CEPH=ceph
fi

echo "CEPH: $CEPH"
POOL=${1:-default.rgw.buckets.data}
POOL_NUM=$($CEPH osd pool stats ${POOL} 2>/dev/null | head -1 | awk "{print \$4}")
date
echo "# POOL=${POOL} , POOL_NUM=${POOL_NUM}"
echo "# ceph -s"
$CEPH -s 2>/dev/null
$CEPH osd df 2>/dev/null
echo
TMPF=$(mktemp /tmp/pgdump.XXXXXX)
$CEPH pg dump pgs_brief 2>/dev/null > $TMPF

if [[ "$POOL_NUM" -eq "" ]]; then
  echo "ERROR: Did not find a pool named $POOL, exiting now."
  echo
  echo "Usage: $0 [pool_name] [ceph_bin_dir]"
  echo
  rm $TMPF
  exit 2
fi

echo -e "\n# PRIMARY PGs number per OSD sorted descending:"
for OSD in $($CEPH osd ls 2>/dev/null); do printf "osd.$OSD\tPGs number: " ; printf "% 3d\n" "$(cat $TMPF | grep "^$POOL_NUM\." | awk '{print $4}' | grep -w $OSD | wc -l)" ; done | sort -n -r -k 4,4
#rm $TMPF
echo

SIZE=$($CEPH osd dump 2>/dev/null | grep "pool $POOL_NUM" | awk '{ print $6 }')
SORTC=$(( SIZE + 4 ))
NDEVS=`$CEPH osd ls 2>/dev/null | wc -l`
echo -e "\n# PRIMARY and Replicated/EC PGs number per OSD sorted by total descending:"
#$CEPH pg dump brief_pgs 2>/dev/null | grep "^$POOL_NUM\." | awk "{ \ ===
cat $TMPF | grep "^$POOL_NUM\." | awk "{ \
  seps[1]=\",\"; split(substr(\$3, 2, length(\$3)-2), res, seps[1]); \
  for (s = 1 ; s <= $SIZE ; s++) { dist[s][res[s]]++; }
} END { \
  min=65535; max=0; sump=0; \
  for (i = 0 ; i < $NDEVS ; i++) {
    printf(\"osd.%d\tPGs: \", i); \
    tot = 0; \
    for (s = 1 ; s <= $SIZE ; s++) { printf(\"% 5d \", dist[s][i]); tot+=dist[s][i]; }
    printf(\" ,total=% 5d\n\", tot)
    if (min > dist[1][i]) {min = dist[1][i]} \
    if (max < dist[1][i]) {max = dist[1][i]} \
    sump+=dist[1][i]; \
  }; \
  ratio=\"NaN\"; \
  if (min > 0){ratio=max/min}; \
  printf( \" Primary: Min=%d Max=%d Ratio=%s Average=%s Max/Ave=%s\n\", min,max,ratio,sump/$NDEVS,max/(sump/$NDEVS) )
}" | sort -n -r -k 3,3 | sort -n -r -s -k $SORTC,$SORTC

rm $TMPF

