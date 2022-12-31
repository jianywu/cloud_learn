#!/bin/bash

# 配置quota
ceph osd pool set-quota testpool2 max_objects 1000
ceph osd pool set-quota testpool2 max_bytes 1024000
ceph osd pool get-quota testpool2
# 配置scrub
ceph osd pool set testpool2 noscrub true
ceph osd pool get testpool2 noscrub
ceph osd pool set testpool2 nodeep-scrub true
ceph osd pool get testpool2 nodeep-scrub
ceph osd pool get testpool2 scrub_min_interval
ceph osd pool get testpool2 scrub_max_interval
ceph osd pool get testpool2 deep_scrub_interval
#查看socket
ll /var/run/ceph
ceph daemon osd.0 config show | grep scrub

# snapshot快照的使用
ceph osd pool ls
ceph osd pool mksnap testpool2 testpool2-snap
rados -p testpool3 mksnap testpool3-snap
# lssnap可以看到有哪些快照
lssnap -p testpool2
lssnap -p testpool3
# 建新snap
rados -p testpool3 mksnap testpool3-snap1
# 列出testpool3的snap
rados lssnap -p testpool3
# 把/etc/hosts文件放到testpool2里，命名为testfile文件
rados -p testpool2 put testfile /etc/hosts
rados -p mypool ls
rados -p testpool2 ls
ceph osd pool mksnap testpool2 testpool2-snapshot001
rados lssnap -p testpool2
rados -p testpool2 rm testfile
# 删除文件后，回退到snapshot001，还可用继续删除
rados rollback -p testpool2 testfile testpool2-snapshot001
rados -p testpool2 rm testfile
rados lssnap -p testpool2
# rmsnap删除指定快照
ceph osd pool rmsnap testpool2 testpool2-snap

