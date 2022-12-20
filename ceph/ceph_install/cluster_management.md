
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
ceph osd pool get-quota mypool
# 最大1000个对象
ceph osd pool set-quota mypool max_objects 1000
# 最大10GB，10737418240B
ceph osd pool set-quota mypool max_bytes 10737418240
# 看pool的配置
ceph osd pool get-quota mypool
```

## 存储可用参数
```bash
# 默认一主两备三副本。min是2，size是3
ceph osd pool get mypool size
ceph osd pool get mypool min_size
ceph osd pool get mypool pg_num
ceph osd pool get mypool crush_rule
ceph osd pool get mypool nodelete
ceph osd pool get mypool nopgchange
# 修改指定pool的pg数量
ceph osd pool set mypool pg_num 64
# 是否可更改存储池大小
ceph osd pool get mypool nosizechange
ceph osd pool get-quota mypool
# 最大20GB
ceph osd pool set-quota mypool max_bytes 21474836480
ceph osd pool set-quota mypool max_objects 1000
ceph osd pool get-quota mypool
# 轻量扫描
ceph osd pool get mypool noscrub
ceph osd pool set mypool noscrub true
ceph osd pool get mypool noscrub
# 深度扫描
ceph osd pool get mypool nodeep-scrub
ceph osd pool set mypool nodeep-scrub true
ceph osd pool get mypool nodeep-scrub
# 清理的最大最小间隔
ceph osd pool get mypool scrub_min_interval
ceph osd pool get mypool scrub_max_interval
# 深层整理，默认值没有配置
ceph osd pool get mypool deep_scrub_interval
# 看扫描的配置
ceph daemon osd.3 config show | grep scrub
```

## 存储池快照
```bash
ceph osd pool ls
ceph osd pool mksnap mypool mypool-snap
rados -p mypool mksnap mypool-snap2
# 验证快照
rados lssnap -p mypool
# 回滚快照
# 上传
rados -p mypool put testfile /etc/hosts
# 验证
raods -p mypool ls
# 创建
ceph osd pool mksnap mypool mypool-snapshot001
rados lssnap -p mypool
# 删除
rados -p mypool rm testfile
# 还原
rados rollback -p mypool test file mypool-snapshot001
# 删除快照
rados lssnap -p mypool
ceph osd pool rmsnap mypool mypool-snap
rados lssnap -p mypool
```
## 数据压缩
```bash
# 指定算法为snappy
ceph osd pool get mypool compression_algorithm
ceph osd pool set mypool compression_algorithm snappy
# 指定压缩模式为agreesive，还有none，passive和force
ceph osd pool get mypool compression_mode
ceph osd pool set mypool compression_mode aggressive
# 到节点验证
ceph daemon osd.0 config show | grep compression
```

## ceph认证机制
```bash
# 需要看到caps mds,mgr,mon,osd为allow*
cat /etc/ceph/ceph.client.admin.keyring
# 列出指定用户信息
ceph auth get osd.0
ceph auth get client.admin
ceph auth list
# 配置存到某文件
ceph auth list -o 123.key
# 验证key
ceph auth add client.tom mon 'allow r' osd 'allow rwx pool=mypool'
ceph auth get client.tom
# 可以多次创建，有key就返回原来的key
ceph auth get-or-create client.jack mon 'allow r' osd 'allow rwx pool=mypool'
ceph auth get client.jack
ceph auth print-key client.jack
# 修改用户权限
ceph auth caps client.jack mon 'allow r' osd 'allow rw pool=mypool'
# 删除用户
ceph auth del client.tom
# 导出用户认证信息到keyring文件
ceph auth get-or-create client.user1 mon 'allow r' osd 'allow * pool=mypool'
ceph auth get client.user1
# 建空的keyring文件
ceph-authtool --create-keyring ceph.client.user1.keyring
# 导出keyring到指定文件
ceph auth get client.user1 -o ceph.client.user1.keyring
cat ceph.client.user1.keyring
# 恢复认证
ceph auth del client.user1
ceph auth get client.user1
ceph auth import -i ceph.client.user1.keyring

```
