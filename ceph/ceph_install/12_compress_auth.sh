#!/bin/bash

# 压缩算法，不建议打开
ceph osd pool set testpool3 compression_algorithm snappy
ceph osd pool get testpool3 compression_algorithm
ceph osd pool set testpool3 compression_mode aggressive
ceph osd pool get testpool3 compression_mode

# 认证机制
ceph osd pool ls
ceph osd pool create mypool 32 32
# 创建用户tom
ceph auth add client.tom mon 'allow r' osd 'allow rwx pool=testpool2'
ceph auth get client.tom
# 创建用户jack
ceph auth get-or-create client.jack mon 'allow r' osd 'allow rwx pool=mypool'
ceph auth get client.jack

# mon读权限，osd读写执行都可以
ceph auth get-or-create-key client.jack mon 'allow r' osd 'allow rwx pool=mypool'
ceph auth print-key client.jack
# 修改权限
ceph auth caps client.jack mon 'allow r' osd 'allow rw pool=mypool'

# keyring
# 单个keyring文件
# 建空keyring文件
ceph-authtool --create-keyring ceph.client.user1.keyring
cat ceph.client.user1.keyring
file ceph.client.user1.keyring
# -o写入keyring
ceph auth get client.user1 -o ceph.client.user1.keyring
cat ceph.client.user1.keyring
ceph auth del client.user1
ceph auth get client.user1
# 从keyring文件恢复用户
ceph auth import -i ceph.client.user1.keyring
ceph-authtool --create-keyring ceph.client.user.keyring
# 多个keyring文件
# 加user1的key
ceph-authtool ./ceph.client.user.keyring --import-keyring ./ceph.client.user1.keyr
ing
# 加admin的key
ceph-authtool ./ceph.client.user.keyring --import-keyring /etc/ceph/ceph.client.ad
min.keyring
# 列出keyring文件内容
ceph-authtool --list ./ceph.client.user.keyring

