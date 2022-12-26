#!/bin/bash

# pg_num64, pgp_num64, 通常相等
ceph osd pool create myrbd1 64 64
# 启用rdb
ceph osd pool application enable myrbd1 rbd
# 初始化存储池
rbd pool init -p myrbd1

# 建img
rbd create myimg1 --size 5G --pool myrbd1
rbd create myimg2 --size 3G --pool myrbd1 --image-format 2
rbd ls --pool myrbd1
rbd --image myimg1 --pool myrbd1 info
rbd --image myimg2 --pool myrbd1 info
ceph df

# 删img
rbd remove --image myimg2 --pool myrbd1
# 低版本只用layering，否则无法映射img
cephadmin rbd create myimg2 --size 3G --pool myrbd1 --image-format 2 --image-feature layering

# root执行映射，否则提示rbd: map failed: (13) Permission denied
rbd -p myrbd1 map myimg2
dd if=/dev/zero of=/data/ceph-test-file bs=1MB count=300
ceph df

# 更新pg和pgp，防止不够用
ceph osd pool get myrbd1 pg_num
ceph osd pool get myrbd1 pgp_num

# Total PGs = ((Total_number_of_OSD * 100) / max_replication_count) / pool_count
# pgp_num == pg_num
ceph osd pool set myrbd1 pg_num 64
ceph osd pool set myrbd1 pgp_num 64
