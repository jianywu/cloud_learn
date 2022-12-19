#!/bin/bash

# 基于ubuntu安装
cat /etc/issue

# 内容比较多，如果装不下，可以先删除一些docker的image，docker image prune -af。
# 装依赖库
apt install -y apt-transport-https ca-certificates curl software-properties-common radosgw --allow-unauthenticated
# 后面这两个是可选的
apt install -y ceph-base ceph-common ceph-fuse ceph-mds ceph-mon ceph-osd --allow-unauthenticated

# 加key文件
#wget -q -O- 'https://mirrors.tuna.tsinghua.edu.cn/ceph/keys/release.asc' | sudo apt-key add -

# 如果22.04是jammy，而20.04是focal，通过lsb_release -sc查看。虚拟机需要，云主机可以不用，一般都默认配置了这个库。
# echo "deb https://mirrors.tuna.tsinghua.edu.cn/ceph/debian-pacific focal main" >> /etc/apt/sources.list
#echo "deb http://download.ceph.com/debian-jewel/ jammy main" >> /etc/apt/sources.list
#apt update -y

# 免密钥登录，先在/etc/hosts里加上各主机的解析。Here Document的cat << EOF方式重定向即可。也可以直接echo
ip1="42.51.17.66"
ip2="125.124.238.46"
ip3="114.115.144.163"
(
cat << EOF
$ip1 ceph-deploy.example.local ceph-deploy
$ip1 ceph-mon1.example.local ceph-mon1
$ip2 ceph-mon1.example.local ceph-mon2
$ip3 ceph-mon1.example.local ceph-mon3
$ip1 ceph-mgr1.example.local ceph-mgr1
$ip2 ceph-mgr1.example.local ceph-mgr2
$ip1 ceph-node1.example.local ceph-node1
$ip2 ceph-node2.example.local ceph-node2
$ip3 ceph-node2.example.local ceph-node3
EOF
) >> /etc/hosts

# 新建用户和组
groupadd -r -g 2088 cephadmin && useradd -r -m -s /bin/bash -u 2088 -g 2088 cephadmin && echo cephadmin:123456 | chpasswd
# 允许sudo执行特权命令。
# vim /etc/sudoers加一行cephadm ALL=(ALL) NOPASSWD: ALL
echo "cephadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# 安装ceph部署工具，ceph-deploy是官方的部署工具
apt install pip -y
pip install ceph-deploy
apt-cache madison ceph-deploy
sudo apt install ceph-deploy -y
# 如果上面的运行有问题，可以编译安装最新版本的ceph-deploy，但有风险，可能会导致版本和apt的不兼容，最好都用apt安装。
#mkdir /ceph-deploy-source
#cd /ceph-deploy-source
#git clone https://github.com/ceph/ceph-deploy.git
#cd ceph-deploy
#python3 setup.py install

# 时区同步
ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
bash -c "echo 'Asia/Shanghai' > /etc/timezone"
apt-get install -y ntpdate
# 如果socket在使用，就
systemctl stop ntp
# 或者ntpdate ntp1.aliyun.com
ntpdate time1.aliyun.com


# 生成特定的key
#su - cephadmin

# 加-m PEM和-b 4096，在ubuntu兼容低版本或其它低版本软件，比如jenkins
#ssh-keygen -m PEM -t rsa -b 4096
#ssh-copy-id cephadmin@ceph-mon1

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
