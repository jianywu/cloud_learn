#!/bin/bash

# radosgw
apt-cache madison radosgw
apt install radosgw=16.2.10-1bionic
# 会启动进程/usr/bin/radosgw -f --cluster ceph --name client.rgw.ceph-mgr1 --setuser ceph --setgroup ceph
ceph-deploy rgw create ceph-mgr1

