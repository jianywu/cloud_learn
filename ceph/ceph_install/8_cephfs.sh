#!/bin/bash

# cephFS
apt-cache madison ceph-mds
apt install ceph-mds=16.2.10-1bionic
# 会启动/usr/bin/ceph-mds -f --cluster ceph --id ceph-mgr1 --setuser ceph --setgroup ceph
ceph-deploy mds create ceph-mgr1

ceph osd pool create cephfs-metadata 32 32
#Error ERANGE:  pg_num 64 size 3 would mean 891 total pgs, which exceeds max 750 (mon_max_pg_per_osd 250 * num_in_osds 3)
#ceph osd pool create cephfs-data 64 64
ceph osd pool create cephfs-data 16 16

# 挂载测试，可以看到多了100M，会需要一定时间同步，因为先写到主，再复制到备
mount -t ceph 192.168.0.2:6789:/ /mnt -o name=admin,secret=AQBhiqljg1aTBRAAG60I1LrIqaqwGvsx0fN5zw==
# 效果和上面的命令一样
#mount -t ceph 192.168.0.2:6789,176.16.0.2:6789,10.0.0.2:6789:/ /mnt -o name=admin,secret=AQBhiqljg1aTBRAAG60I1LrIqaqwGvsx0fN5zw==
df -Th
ceph df
dd if=/dev/zero of=/mnt/ceph-fs-testfile bs=4M count=25
ceph df detail
lsblk -f | grep -B1 ceph
