## 初始化mon节点
```bash
mkdir ceph-cluster
cd !$
# 查看deploy的帮助文档
ceph-deploy --help
```
安装python2
```bash
sudo apt install python2.7 -y
sudo ln -sv /usr/bin/python2.7 /usr/bin/python2
```
部署集群
```bash
ceph-deploy new --cluster-network 192.168.0.0/21 --public-network 172.31.0.0/21 ceph-mon1.example.local
cd ceph-cluster
# 更新ceph的配置文件
vi ceph.conf
```
### ceph-mon服务
各节点分别运行这些脚本。邮件的默认即可。
```bash
apt-cache madison ceph-mon
apt install ceph-mon -y
```

#### 添加ceph-mon服务
```bash
ceph-deploy mon create-initial
```
#### 验证mon节点
```bash
ps -ef | grep ceph-mon
```

### 分发admin秘钥
推送后，在/etc/ceph目录就有这些文件了，其中keyring只有root用户能读。
```bash
sudo apt install ceph-common
ceph-deploy admin ceph-node1 ceph-node2 ceph-node3 ceph-node4
```
#### 节点验证秘钥
各node都增加这个秘钥，授权cephadmin执行权限，默认只有root能执行。
```bash
setfacll -m u:cephadmin:rw /etc/ceph/ceph.clent.admin.keyring
```
需要读/etc/ceph目录中的配置文件。
