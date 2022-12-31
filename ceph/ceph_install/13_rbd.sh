#!/bin/bash

# 建rbd的数据pool
ceph osd pool create rbd-data1 32 32
ceph osd pool ls
ceph osd pool application enable rbd-data1 rbd
rbd pool init -p rbd-data1
rbd help create
# 建2个image，放在同一个rbd的pool
rbd create data-img1 --size 3G --pool rbd-data1 --image-format 2 --image-feature l
rbd create data-img2 --size 5G --pool rbd-data1 --image-format 2 --image-feature l
# 列出image
rbd ls --pool rbd-data1 -l
#NAME       SIZE   PARENT  FMT  PROT  LOCK
#data-img1  3 GiB            2
#data-img2  5 GiB            2
rbd --image data-img2 --pool rbd-data1 info
rbd --image data-img1 --pool rbd-data1 info
rbd ls --pool rbd-data1 -l --format json --pretty-format


# 使能feature
rbd feature enable exclusive-lock --pool rbd-data1 --image data-img1
rbd feature enable object-map --pool rbd-data1 --image data-img1
rbd feature enable fast-diff --pool rbd-data1 --image data-img1
rbd --image data-img1 --pool rbd-data info

# 禁用fast-diff，在rbd-data1的pool里的data-img1镜像
rbd feature disable fast-diff --pool rbd-data1 --image data-img1
rbd --image data-img1 --pool rbd-data info
rbd feature disable rbd-data1/data-img1 object-map
rbd -p rbd-data1 map data-img1
rbd -p rbd-data1 map data-img2


docker run -it -p 3306:3306 -e MYSQL_ROOT_PASSWORD="12345678" -v /data/mysql:/var/lib/mysql mysql:5.6.46
#另一台主机登录mysql:
mysql -uroot -p12345678 -h114.115.144.163
#>show databases;
#>create database mydatabase

ceph auth add client.jianywu mon 'allow r' osd 'allow rwx pool=rbd-data1'
ceph auth get client.jianywu
ceph-authtool --create-keyring ceph.client.jianywu.keyring
ceph auth get client.jianywu -o ceph.client.jianywu.keyring
# 复制用户keyring到另一台主机
scp ceph.conf ceph.client.jianywu.keyring 42.51.17.66:/etc/ceph/

rbd --id jianywu -p rbd-data1 map data-img2

rbd ls -p rbd-data1 -l
rbd resize --pool rbd-data1 --image data-img2 --size 6G

rbd --id jianywu -p rbd-data1 map data-img2
mount /dev/rdb1 /data/test3
#查看当前的映射关系
rbd showmapped
df -TH
#rbd trash的使用
rbd trash move --pool rbd-data1 --image data-img2
# 删除这个镜像
root rbd trash move --pool rbd-data1 --image data-img2
# 看trash里有哪些镜像
rbd trash list --pool rbd-data1
# 完全删除这个镜像
rbd trash remove --pool rbd-data1 8659a3691aec
# 恢复这个镜像
rbd trash restore --pool rbd-data1 --image data-img1 --image-id 3fd1cb6a5013

# snap的使用
rbd snap create --pool rbd-data1 --image data-img1 --snap img1-snap-20201215
rbd snap list --pool rbd-data1 --image data-img1
# 取消某个映射关系
rbd unmap /dev/rbd0
rbd snap rollback --pool rbd-data1 --image data-img1 --snap img1-snap-20201215
# 删除快照
rbd snap remove --pool rbd-data1 --image data-img1 --snap img1-snap-20201215
rbd snap list --pool rbd-data1 --image data-img1
# 加快照数量限制
rbd snap limit set --pool rbd-data1 --image data-img1 --limit 30
rbd snap limit set --pool rbd-data1 --image data-img1 --limit 15
# 清楚快照数量限制
rbd snap limit clear --pool rbd-data1 --image data-img1

