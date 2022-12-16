
# RBD
## 创建RBD
```bash
awkcreate <poolname> pg_num pgp_num {replicated|erasure}

#创建存储池,指定pg 和pgp 的数量，pgp 是对存在于pg 的数据进行组合存储，pgp 通常等于pg 的值
ceph osd pool create myrbd1 64 64
pool 'myrdb1' created
ceph osd pool --help

#对存储池启用RBD 功能
ceph osd pool application enable myrbd1 rbd
enabled application 'rbd' on pool 'myrdb1'
rbd -h

#通过RBD 命令对存储池初始化
rbd pool init -p myrbd1
```

## 验证image
```bash
rbd create myimg1 --size 5G --pool myrbd1
# 分层功能，和镜像快照相关
rbd create myimg2 --size 3G --pool myrbd1 --image-format 2 --image-feature layering

#列出指定的pool 中所有的img
rbd ls --pool myrbd1
#查看指定rdb 的信息
rbd --image myimg1 --pool myrbd1 info
rbd --image myimg2 --pool myrdb1 info
```

## 客户端用块存储
```bash
# 看使用情况
ceph df
apt install ceph-common
```
把配置conf和认证keyring复制过去。

## 客户端映射img
通过-p指定存储池myrbd1，映射myimg2
```bash
rbd -p myrbd1 map myimg2
rbd -p myrbd1 map myimg1
lsblk
fdisk -l /dev/rbd0
```
后续可以格式化磁盘，以供后续使用。

使用300M，看情况。
```bash
# buffer size是1MB
dd if=/dev/zero of=/data/ceph-test-file bs=1MB count=300
# 看写入速度
ceph -s
ll -h /data/ceph-test-file
ceph df
```

```bash
#删数据
rm -rf /data/ceph-test-file
#删完ceph df还占用比较多，因为空间还没回收。回收用fstrim命令
fstrim -v /data
#配置挂载选项discard，表示立即回收
rbd -p myrbd1 map myimg2
mount -t xfs -o discard /dev/rbd0 /data/
```

# 对象存储网关（RGW）
只用cephFS或block的场合，可不用启用radosgw。
```bash
apt-cache madison radosgw
apt intall radosgw=16.2.601focal
#覆盖目标主机的配置/etc/ceph/ceph.conf，不加会报错，提示目标主机已存在配置文件。
ceph-deploy --overwrite-conf rgw create ceph-mgr1
#7480口，可以访问到这个界面。
ps -aux | grep radosgw
ceph osd pool ls
```

# ceph-fs文件存储
https://docs.ceph.com/en/latest/cephfs/
需要meta data service的服务，也就是ceph-mds的daemon进程。
block只能被一个node占用，ceph-FS可以实现文件共享。
可以单独建，也可以建在mgr服务器。
```bash
apt-cache madison ceph-mds
apt install ceph-mds=16.2.601focal
ceph-deploy mds create ceph-mgr1
#看ceph使用情况，没初始化时，是standby的
ceph mds stat
#保存metadata的pool
ceph osd pool create cephfs-metadata 32 32
#保存数据的pool
ceph osd pool create cephfs-data 64 64
#看ceph情况
ceph -s
```
## 建cephfs验证
name: mycephfs metadatapool:cephfs-metadata, datapool: cephfs-data
```bash
ceph fs new mycephfs cephfs-metadata cephfs-data
ceph fs ls
#查看指定cephfs状态,active就是可用了
ceph fs status mycephfs
```
## 验证cephfs服务状态
```bash
#key就是后面用到的secret
cat ceph.client.admin.keyring
#把磁盘都挂载到/data目录
mount -t ceph ip:6789:/ /data -o name=admin,secret=$secret
```
## 验证挂载点
```bash
df -TH
#复制文件到/data目录
cp /var/log/syslog /data
dd if=/dev/zero of=/data/ceph-fs-testfile bs=4M count=25
ceph df
# 可以看到有ceph模块
lsmod | grep ceph
modinfo ceph
modinfo libceph
```

## 命令总结
```bash
#显示存储池
ceph osd pool ls
#列出存储池，显示ID
ceph osd lspool
#查看pg状态
ceph pg stat
#查看pool状态
ceph osd pool stats
ceph osd pool stats mypool
#集群状态
ceph df
ceph df detail
#osd状态
ceph osd stat
ceph osd dump
# osd和节点的关系，weight是权重，越大，表示存的内容越多
ceph osd tree
#看osd对应的硬盘
lsblk -f | grep -B1 ceph
ll /var/lib/ceph/osd/ceph-13/block
#mon节点状态
ceph mon stat
#dump更多信息
ceph mon dump
```

# ceph集群维护
http://docs.ceph.org.cn/rados/
```bash
ll /var/run/ceph
scp ceph.client.admin.keyring root@172.31.6.101:/etc/ceph
#admin-socket帮助
ceph --admin-socket /var/run/ceph/ceph-osd.0.asok --help
#admin-daemon帮助
ceph --admin-daemon /var/run/ceph/ceph-mon.ceph-mon1.asok help
ceph --admin-daemon /var/run/ceph/ceph-mon.ceph-mon1.asok mon_status
ceph --admin-daemon /var/run/ceph/ceph-mon.ceph-mon1.asok config show
```
## 停止或重启
```bash
#noout关闭服务后不会提出ceph集群外
ceph osd set noout
#启动后取消noout
ceph osd unset noout
```
添加服务器
```bash
#加仓库
ceph-deploy install --release pacific ceph-nodex
#擦除磁盘
ceph-deploy disk zap ceph-nodex /dev/sdx
#添加osd
sudo ceph-deploy osd create ceph-nodex --data /dev/sdx
```
删除osd
```bash
ceph osd out 1
ceph osd rm 1
```
删除服务器
```bash
#从crush删除ceph-node1
ceph osd crush rm ceph-node1
```

# 存储池、PG与CRUSH
PG(placement group)归置组。每个PG有3个OSD(数据三个副本)。
PGP(placement group for placement purpose)归置组的组合。
CRUSH算法把每个对象映射到PG。
https://docs.ceph.com/en/mimic/rados/configuration/pool-pg-config-ref/
```bash
#创建纠删码池
ceph osd pool create erasure-testpool 16 16 erasure
ceph osd erasure-code-profile get default
#写数据
sudo rados put -p erasure-testpool testfile1 /var/log/syslog
#验证数据
ceph osd map erasure-testpool testfile1
#验证pg状态
ceph pg ls-by-pool erasure-testpool | awk '{print $1,$2,$15}'
#测试获取数据
rados --pool erasure-testpool get testfil1 -
sudo rados get -perasure-testpool testfile1 /tmp/testfile1
```

创建osd的pool，数量需要是2的整数倍，比如下面这几个命令，会有提示，non-power-of-two_pg_num。
```bash
cep osd pool create testpoo2 60 60
cep osd pool create testpoo3 40 30
cep osd pool create testpoo4 45 45
```
pg的pool情况。
```bash
ceph pg ls-by-pool mypool
ceph pg ls-by-pool mypool | awk '{print $1,$2,$15}'
```

## PG状态
Peering，正在同步。
Activating，Peering完成。
Clean，PG的Acting Set和Up Set为同一组OSD，且内容一致。
Active，可以处理client的读写请求。正常集群就是Active+Clean状态的。
Degraded，降级状态。在OSD标记为down以后。
State，过期状态。
undersized，副本数小于定义值。
scrubbing，数据的清洗状态，保证数据完整性的。
recovering，恢复状态，正迁移或同步对象和他们的副本。
backfilling，后台填充。
backfill-toofull，OSD可用空间不足。

## ceph pool操作
http://docs.ceph.org.cn/rados/
```bash
#看pool
ceph osd pool ls
ceph osd lspool
#看事件
ceph osd pool stats mypool
#用量
rados df
```
删除
```bash
#建测试pool
ceph osd pool create mypool2 32 32
#不能删除
ceph osd pool get mypool2 nodelete
ceph osd pool set mypool2 nodelete true
#可删除
ceph osd pool get mypool2 nodelete false
```
集群范围的配置参数。
```bash
ceph tell mon.*injectargs --mon-allow-pool-delete=true
ceph osd pool rm mypool2 mypool2 --yes-i-really-mean-it
ceph tell mon.*injectargs --mon-allow-pool-delete=false
```
## 存储池配额
```bash

```
