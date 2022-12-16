## 扩展ceph-mon节点
节点通常需要是奇数。
```bash
# 查看deploy的帮助文档
apt install -y ceph-mon
ceph-deploy mon add ceph-mon2
ceph-deploy mon add ceph-mon3
```
验证ceph-mon状态。
mon服务器本身就是高可用的。
```bash
ceph quorum_status
# 可以看到当前的leader，当前node的等级rank，以及名称name，监听地址addr。
ceph quorum_status --format json-pretty
# 看集群状态
ceph -s
```
端口是3300，还有6789.
## 扩展mgr节点
```bash
apt install ceph-mgr
ceph-deploy admin mgr
ceph -s
```

mon服务器。需要和OSD频繁交互。
读写挂载点的数据。
