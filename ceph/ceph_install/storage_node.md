## 初始化OSD节点
```bash
# 查看deploy的帮助文档
ceph-deploy install --release pacific ceph-node1
ceph-deploy install --release pacific ceph-node2
ceph-deploy install --release pacific ceph-node3
# 列出节点磁盘
ceph-deploy disk list ceph-node1
# 磁盘擦除，如果install没装需要的软件，这一步会失败
ceph-deploy disk zap ceph-node1
```
添加OSD节点的磁盘
```bash
ceph-deploy osd --help
# 添加OSD节点的磁盘，这个是node1的例子，node2，3也是类似的操作
ceph-deploy osd create ceph-node1 --data /dev/sdb
ceph-deploy osd create ceph-node1 --data /dev/sdc
ceph-deploy osd create ceph-node1 --data /dev/sdd
ceph-deploy osd create ceph-node1 --data /dev/sde
```
对应关系是：
ceph-node1 /dev/sdb 0
ceph-node2 /dev/sdc 0
ceph-node3 /dev/sdd 0
ceph-node4 /dev/sde 0
设置OSD服务自启动，重启后，看OSD是否会自动启动。
在health里的clock skew表示需要同步时间。如果socket在用，就systemctl stop ntp，把ntp服务停掉。
```bash
# 看ceph的配置情况
ceph -s
ps -ef | grep osd
# 验证ceph集群
ceph health
# 移除OSD
ceph osd out {osd-num}
systemctl stop ceph-osd@{osd-num}
# 不建议加--force
ceph osd purge {id} --yes-i-really-mean-it
# ceph.conf配置文件，需要管理员删除osd之后，手动删除
```
需要依次手动执行如下步骤，删除osd设备。
```bash
ceph osd crush remove {name}
ceph auth del osd.{osd-num}
ceph osd rm {osd-num}
```
测试上传与下载数据。其中需要用到rados命令。
```bash
ceph -h
# 客户端命令
rados -h
```
创建pool：
```bash
ceph osd pool create mypool 32 32
# 验证PG与PGP组合
ceph pg ls-by-pool mypool | awk '{print $1, $2, $15}'
```
查看pool：
```bash
ceph osd pool ls
# 或
rados lspools
```
访问ceph对象存储的功能。
```bash
# 上传文件
sudo rados put msg1 /var/log/syslog --pool=mypool
# 列出文件
rados ls --pool=mypool
# 文件信息，可以看到object, pg映射关系内容，是否up
ceph osd map mypool msg1
```
下载文件。
```bash
sudo rados get msg1 --pool=mypool /opt/my.txt
ll /opt
head /opt/my.txt
```
修改文件。
```bash
sudo rados put msg1 /etc/passwd --pool=mypool
sudo rados get msg1 --pool=mypool /opt/2.txt
tail /opt/2.txt
```
删除文件。
```bash
sudo rados rm msg1 --pool=mypool
sudo rados ls --pool=mypool
```
