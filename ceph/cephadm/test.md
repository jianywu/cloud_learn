
# 创建pool
```bash
root ceph osd pool create mypool 32 32
root ceph pg ls-by-pool mypool | awk '{print $1, $2, $15}'
ceph osd map mypool msg1
```

# 上传下载
```bash
rados ls --pool=mypool
rados put msg1 /var/log/syslog --pool=mypool
rados ls --pool=mypool
rados get msg1 --pool=mypool /tmp/1.txt
rados put msg1 /etc/passwd --pool=mypool
rados get msg1 --pool=mypool /tmp/2.txt
```

# 删除pool
```bash
rados rm msg1 --pool=mypool
rados ls --pool=mypool
```

# 看集群mon状态
```bash
ceph quorum_status --format json-pretty
```

# rbd的pool测试
```bash
ceph osd pool create myrbd1 64 64
ceph osd pool application enable myrbd1 rbd
rbd -h
rbd pool init -p myrbd1
rbd create myimg1 --size 5G --pool myrbd1
rbd create myimg2 --size 3G --pool myrbd1 --image-format 2 --image-feature layering
rbd ls --pool myrbd1
rbd --image myimg1 --pool myrbd1 info
```

# rbd的img测试
```bash
rbd -p myrbd1 map myimg2
lsblk
mkfs.xfs /dev/rbd0
dd if=/dev/zero of=/data/ceph-test-file bs=1MB count=300
ceph df
rm -rf /data/ceph-test-file

#测试img
mkdir /data_test
mount -t xfs -o discard /dev/rbd0 /data_test
#看osd的统计
ceph df detail
ceph osd stat
ceph osd dump
ceph osd tree
```


