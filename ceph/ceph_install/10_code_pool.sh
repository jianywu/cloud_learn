#!/bin/bash

# 测试pool上传和下载数据
ceph osd pool create erasure-testpool 16 16 erasure
ceph osd erasure-code-profile get default
sudo rados put -p erasure-testpool testfile1 /var/log/syslog
ceph osd map erasure-testpool testfile1
ceph pg ls-by-pool erasure-testpool | awk '{print $1,$2,$15}'
rados --pool erasure-testpool get testfile1 -
rados --pool erasure-testpool get testfile1 /tmp/testfile1

# 建测试pool，pg要求2的幂次方，pgp和pg一般相等
ceph osd pool create testpool2 30 30
ceph osd pool create testpool3 20 15
ceph osd pool create testpool4 20 20
# 会提示[WRN] POOL_PG_NUM_NOT_POWER_OF_TWO: 3 pool(s) have non-power-of-two pg_num和pool 'testpool2' pg_num 30 is not a power of two。
ceph health detail
ceph pg ls-by-pool testpool2 | awk '{print $1,$2,$15}'
rados df
ceph osd pool create mypool2 32 32
# 看nodelete的配置
ceph osd pool get testpool2 nodelete
ceph osd pool set testpool2 nodelete false
ceph osd pool get testpool2 nodelete

# 删除pool
# 先配置允许删除, 注意mon.*后面有空格，表示所有的mon，注入参数
ceph tell mon.* injectargs --mon-allow-pool-delete=true
# 注意有两个really
ceph osd pool rm mypool mypool --yes-i-really-really-mean-it
