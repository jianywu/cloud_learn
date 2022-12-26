#!/bin/bash

# 基于ubuntu安装
cat /etc/issue

# 配置mon需要的firewalld的service
apt install firewalld -y
systemctl status firewalld
systemctl enable firewalld
firewall-cmd --zone=public --add-port=1-65535/tcp --permanent
firewall-cmd --zone=public --add-port=1-65535/udp --permanent

# 加repo
wget -q -O- 'https://mirrors.tuna.tsinghua.edu.cn/ceph/keys/release.asc' | sudo apt-key add -
echo "deb http://mirrors.tuna.tsinghua.edu.cn/ceph/debian-pacific bionic main" >> /etc/apt/sources.list
apt update -y
apt install python-pip -y
pip2 install ceph-deploy
# 返回2.0.1版本及以上才是匹配的
ceph-deploy --version

# 内容比较多，如果装不下，可以先删除一些docker的image，docker image prune -af。
# 装依赖库
apt install -y apt-transport-https ca-certificates curl software-properties-common radosgw --allow-unauthenticated
# 后面这两个是可选的
apt install -y ceph-base ceph-common ceph-fuse ceph-mds ceph-mon ceph-osd --allow-unauthenticated

# 免密钥登录，先在/etc/hosts里加上各主机的解析。Here Document的cat << EOF方式重定向即可。也可以直接echo
ip1="192.168.0.2" #ecs-211060
ip2="172.16.0.2" #ecs-337800
ip3="10.0.0.2" #ecs-91251
(
cat << EOF
$ip1 ceph-deploy.example.local ceph-deploy
$ip1 ceph-mon1.example.local ceph-mon1
$ip2 ceph-mon2.example.local ceph-mon2
$ip3 ceph-mon3.example.local ceph-mon3
$ip1 ceph-mgr1.example.local ceph-mgr1
$ip2 ceph-mgr2.example.local ceph-mgr2
$ip1 ceph-node1.example.local ceph-node1
$ip2 ceph-node2.example.local ceph-node2
$ip3 ceph-node3.example.local ceph-node3
EOF
) >> /etc/hosts

# 新建用户和组
groupadd -r -g 2088 cephadmin && useradd -r -m -s /bin/bash -u 2088 -g 2088 cephadmin && echo cephadmin:123456 | chpasswd
# 允许sudo执行特权命令。
# vim /etc/sudoers加一行cephadm ALL=(ALL) NOPASSWD: ALL
echo "cephadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


# 时区同步
ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
bash -c "echo 'Asia/Shanghai' > /etc/timezone"
apt-get install -y ntpdate
# 如果提示ntp的socket在使用，就
systemctl stop ntp
# 或者ntpdate ntp1.aliyun.com
ntpdate time1.aliyun.com

echo "Ceph common part install finish!"

echo "please generate and copy key to other ceph machines."

echo "\n
su - cephadmin
# ssh-keygen -m PEM -t rsa -b 4096
# here use cephadmin password
ssh-copy-id $ip1
ssh-copy-id $ip2
ssh-copy-id $ip3
"

# 参考资料：极客时间，马哥教育，https://cloud.tencent.com/developer/article/1577952
