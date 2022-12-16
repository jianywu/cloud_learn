## 准备环境
运行all_node_common.md的内容。

## 配置manager节点
```bash
ceph-deploy mgr --help
apt install ceph-mgr
ceph-deploy mgr create ceph-mgr1
```
## 验证manager节点
```bash
# 看ceph-mgr是否起来了
ps -ef | grep ceph
```
管理ceph集群
```bash
apt install ceph-common -y
# 推送证书给自己
ceph-deploy admin ceph-deploy
# 测试ceph命令，先授权
sudo setfacl -m u:cephadmin:rw /etc/ceph/ceph.client.admin.keyring
# 再测试，可以看到mgr的进程
ceph -s
# 配置mon，动态调整，重启后也有效，禁用reclaim
ceph config set mon auth_allow_insecure_global_id_reclaim false
ceph -s
```
health里，可以看到OSD count 0 < osd_pool_default_size 3，挂载磁盘就好了。
