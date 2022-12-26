#!/bin/bash

# 命令都在ceph-mon1执行即可，除非明确标注所有主机

set -x

# 需要以cephadmin账户执行, 手动输入切换用户后，再运行脚本
# su - cephadmin
# 需要在~/ceph-cluster目录执行后续命令
mkdir -p ~/ceph-cluster
cd ~/ceph-cluster
# 查看deploy的帮助文档
ceph-deploy --help

# 部署集群
ceph-deploy new --cluster-network 0.0.0.0/0 --public-network 0.0.0.0/0 ceph-mon1.example.local ceph-mon2.example.local ceph-mon3.example.local

# 上一步执行后，会自动生成ceph的配置文件，以及ceph的log
cat ceph.conf

# 初始化node节点
ceph-deploy install --no-adjust-repos --nogpgcheck ceph-node1 ceph-node2 ceph-node3

# ceph-mon服务
# 各节点分别运行这些脚本。
# 先通过apt-cache madison搜索有哪些可用版本
apt-cache madison ceph-mon
sudo apt install ceph-mon -y
# 如果有些包有异常，可以修复安装
# sudo apt --fix-broken install

# 添加ceph-mon服务
ceph-deploy --overwrite-conf mon create-initial

# 验证mon节点
ps -ef | grep ceph-mon

# 分发admin秘钥
sudo apt install ceph-common -y
ceph-deploy --overwrite-conf admin ceph-node1 ceph-node2 ceph-node3
ls -l /etc/ceph

# 节点验证秘钥，各node都增加这个秘钥，授权cephadmin执行权限，默认只有root能执行, setfacl是配置访问控制列表。
sudo setfacl -m u:cephadmin:rw /etc/ceph/ceph.client.admin.keyring
# 需要读/etc/ceph目录中的配置文件。
