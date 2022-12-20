#!/bin/bash

# 查看deploy的帮助文档
ceph-deploy install --release pacific ceph-node1
ceph-deploy install --release pacific ceph-node2
ceph-deploy install --release pacific ceph-node3
# 列出节点磁盘
ceph-deploy disk list ceph-node1
ceph-deploy disk list ceph-node2
ceph-deploy disk list ceph-node3
# 磁盘擦除，如果install没装需要的软件，这一步会失败
ceph-deploy disk zap ceph-node2 /dev/vdb

# 添加OSD节点的磁盘
ceph-deploy osd --help
# 添加OSD节点的磁盘，这个是node1的例子，node2，3也是类似的操作
ceph-deploy osd create ceph-node1 --data /dev/vdb
ceph health

