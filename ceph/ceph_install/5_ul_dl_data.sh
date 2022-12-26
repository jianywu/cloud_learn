#!/bin/bash

# 在ceph的cluster节点执行
ceph osd pool create mypool 32 32
ceph pg ls-by-pool mypool | awk '{print $1,$2,$15}'
ceph osd pool ls

# 修改和上传命令类似，msg1不变，换掉syslog文件即可
sudo rados put msg1 /var/log/syslog --pool=mypool
# 下载命令
sudo rados get msg1 --pool=mypool /tmp/my.txt
head /tmp/my.txt

# 看osd的map关系
ceph osd map mypool msg1

# 删数据
sudo rados rm msg1 --pool=mypool
rados ls --pool=mypool

