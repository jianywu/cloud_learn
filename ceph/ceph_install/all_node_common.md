# 环境准备
## 集群主机的配置
时间同步(各服务器时间必须一致)。
关闭firewalld和iptables，打开主机间的安全组。
配置主机域名解析或通过DNS解析。可以加到/etc/hosts里，域名解析比较方便。

## 部署RADOS集群
以ubuntu的debian系统作为例子。ceph采用pacific的版本。首先配置镜像源。
```bash
# 安装需要的软件
apt install -y apt-transport-https ca-certificates curl software-properties-common
# 加key文件
wget -q -O- 'https://mirrors.tuna.tsinghua.edu.cn/ceph/keys/release.asc' | sudo apt-key add -
```
### 增加ceph的清华镜像源
部署ceph的存储节点时，需要使用。
```bash
# 如果22.04是jammy，而20.04是focal。
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ceph/debian-pacific focal main" >> /etc/apt/sources.list
apt update
```
### 配置用户
cephadmin用于部署集群，cephuser用于使用集群。
```bash
groupadd -r -g 2088 cephadmin && useradd -r -m -s /bin/bash -u 2088 -g 2088 cephadmin && echo cephadmin:123456 | chpasswd
# 允许sudo执行特权命令。
# vim /etc/sudoers加一行cephadm ALL=(ALL) NOPASSWD: ALL
echo "cephadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
```
### 免密钥登录
先在/etc/hosts里加上各主机的解析。
```bash
124.223.157.166 ceph-deploy.example.local ceph-deploy
125.124.238.46 ceph-mon1.example.local ceph-monx
42.51.17.66 ceph-mgr1.example.local ceph-mgrx
114.115.144.163 ceph-node1.example.local ceph-node1
114.115.154.84 ceph-node2.example.local ceph-node2
114.115.221.236 ceph-node2.example.local ceph-node3
```
生成特定的key
```bash
su - cephadmin
# 加-m PEM和-b 4096，在ubuntu兼容低版本或其它低版本软件，比如jenkins
ssh-keygen -m PEM -t rsa -b 4096
ssh-copy-id cephadmin@ceph_server1
```
安装ceph部署工具。
```bash
apt install python-pip
pip2 install ceph-deploy
apt-cache madison ceph-deploy
sudo apt install ceph-deploy
```
