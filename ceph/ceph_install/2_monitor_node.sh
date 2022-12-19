#!/bin/bash

set -x

# 需要以cephadmin账户执行, 手动输入切换用户后，再运行脚本
# su - cephadmin
mkdir -p ~/ceph-cluster
cd ~/ceph-cluster
# 查看deploy的帮助文档
ceph-deploy --help

# 安装python2
sudo apt install python2.7 -y
sudo ln -sv /usr/bin/python2.7 /usr/bin/python2
sudo add-apt-repository universe
sudo apt update -y
# 或者可以执行本目录下的get-pip.py文件
# 官网的手动下载也可以，如果下载的不全，会出现ERROR: This script does not work on Python 2.7 The minimum supported Python version is 3.6.
# curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
#sudo python2 get-pip.py
#pip2 --version

# 部署集群
# 如果提示module 'platform' has no attribute 'linux_distribution'，需要编译安装。
# 需要配置cluster-network，否则会报错。同时也无法生成配置文件。
# ceph-deploy new --cluster-network 192.168.0.0/21 --public-network 125.124.0.0/21 ceph-mon1.example.local
ceph-deploy new --cluster-network 192.168.1.0/21 --public-network 192.168.1.0/21 ceph-mon1.example.local
cd ~/ceph-cluster

# 上一步执行后，会自动生成ceph的配置文件，以及ceph的log
cat ceph.conf

# ceph-mon服务
# 各节点分别运行这些脚本。
# 先通过apt-cache madison搜索有哪些可用版本
apt-cache madison ceph-mon
sudo apt install ceph-mon -y
# 如果有些包有异常，可以修复安装
# sudo apt --fix-broken install

# 添加ceph-mon服务
ceph-deploy mon create-initial

# 验证mon节点
ps -ef | grep ceph-mon

# 分发admin秘钥
sudo apt install ceph-common
ceph-deploy admin ceph-node1 ceph-node2 ceph-node3

# 节点验证秘钥，各node都增加这个秘钥，授权cephadmin执行权限，默认只有root能执行。
setfacll -m u:cephadmin:rw /etc/ceph/ceph.clent.admin.keyring
# 需要读/etc/ceph目录中的配置文件。
