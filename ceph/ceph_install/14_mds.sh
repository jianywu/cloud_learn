#!/bin/bash


# cephfs
apt-cache madison ceph-mds
apt install ceph-mds
# 部署mds服务
ceph-deploy mds create ceph-mgr1
# 建cephfs metadata和data存储池
ceph osd pool create cephfs-metadata 32 32
ceph osd pool create cephfs-data 64 64
ceph -s
ceph fs new mycephfs cephfs-metadata cephfs-data
ceph fs ls
ceph fs status mycephfs
# 在ceph服务器端，创建客户端账户
ceph auth add client.jianywu1 mon 'allow r' mds 'allow rw' osd 'allow rwx pool=cephfs-data'
ceph auth get client.jianywu1
ceph auth get client.jianywu1 -o ceph.client.jianywu1.keyring
# 只会存key的内容
ceph auth print-key client.jianywu1 > jianywu1.key
grep . ceph.client.jianywu1.keyring jianywu1.key
scp ceph.conf ceph.client.jianywu1.keyring jianywu1.key root@:/etc/ceph

# 客户端1
apt install ceph-common -y
ceph --user jianywu1 -s
mkdir /data/cephfs_test
# 通过secretfile来挂载
mount -t ceph 192.168.0.2:6789,172.16.0.2:6789,10.0.0.2:6789:/ /data/cephfs_test -o name=jianywu1,secretfile=/etc/ceph/jianywu1.key

cp /etc/issue /data/cephfs_test/
dd if=/dev/zero of=/data/cephfs_test/testfile bs=1M count=100

tail /etc/ceph/jianywu1.key
umount /data/cephfs_test

# 客户端2
mkdir -p /data/cephfs_test1
mount -t ceph 192.168.0.2:6789,172.16.0.2:6789,10.0.0.2:6789:/ /data/cephfs_test1 -o name=jianywu1,secret=AQBYaq5j7OoNIxAAQbZJE7yE3MFGL/qjQlaQcg==
journalctl > /data/cephfs_test1/j_test1
vi /data/cephfs_test1/j_test1
stat -f /data/cephfs_test1/
# 增加一行
# 192.168.0.2:6789,172.16.0.2:6789,10.0.0.2:6789:/ /data/cephfs_test1 ceph defaults,name=jianywu1,secretfile=/etc/ceph/jianywu1.key,_netdev 0 0
vi /etc/fstab
# 不重启，直接mount
mount -a

# mds
ceph-deploy mds create mds1
ceph-deploy mds create mds2
ceph fs get mycephfs
ceph fs set mycephfs max_mds 2
# 分配ceph的mon和mgr
ceph-deploy --overwrite-conf config push ceph-mon3
ceph-deploy --overwrite-conf config push ceph-mon2
ceph-deploy --overwrite-conf config push ceph-mgr1
systemctl restart ceph-mds@ceph-mon3.service
systemctl restart ceph-mds@ceph-mon2.service
systemctl restart ceph-mds@ceph-mgr1.service

#获得zone的realm领域信息，日志信息，存储池信息
radosgw-admin zone get --rgw-zone=default --rgw-zonegroup=default
#看某个pool的配置，crush，size，pgp/pg num
ceph osd pool get default.rgw.log crush_rule
ceph osd pool get default.rgw.log size
ceph osd pool get default.rgw.log pgp_num
ceph osd pool get default.rgw.log pg_num
# 列出pool
ceph osd lspools

#[client.rgw.ceph-mgr2]
#rgw_host = ceph-mgr2
#rgw_frontends = civetweb port=9900
vi /etc/ceph/ceph.conf
systemctl restart ceph-radosgw@rgw.ceph-mgr2.service

# 配置反向代理
vi /etc/haproxy/haproxy.cfg
新增内容是：
#listen ceph-rgw-80
#        bind 192.168.0.2:80
#        mode tcp
#        server 192.168.0.2 192.168.0.2:9900 check inter 3s fail 3 rise 5
#        server 172.16.0.2 172.16.0.2:9900 check inter 3s fail 3 rise 5
#listen ceph-rgw-443
#        bind 192.168.0.2:443
#        mode tcp
#        server 192.168.0.2 192.168.0.2:9443 check inter 3s fail 3 rise 5
#        server 172.16.0.2 172.16.0.2:9443 check inter 3s fail 3 rise 5
vi /etc/haproxy/haproxy.cfg
systemctl restart haproxy
systemctl status haproxy.service

openssl genrsa -out civetweb.key 2048
openssl req -new -x509 -key civetweb.key -out civetweb.crt -subj "/CN=rgw.magedu.net"
cat civetweb.key civetweb.crt > civetweb.pem
# 配置ceph
#[client.rgw.ceph-mgr1]
#rgw_host = ceph-mgr1
#rgw_frontends = "civetweb port=9900+9443s ssl_certificate=/etc/ceph/certs/civetweb.pem"
#error_log_file=/var/log/radosgw/civetweb.error.log
#access_log_file=/var/log/radosgw/civetweb.access.log
#request_timeout_ms=30000
#num_threads=200
#rgw_dns_name=rgw.magedu.net
vi /etc/ceph/ceph.conf
systemctl restart ceph-radosgw@rgw.ceph-mgr1.service
ss -tnlp
lsof -i :9443
# 加入rgw.magedu.net，解析为本地IP地址
vi /etc/hosts

curl -k https://localhost:9443
curl -k http://localhost:9900

#S3的访问
radosgw-admin user create --uid="user1" --display-name="user1"
#记录下用户的key
            #"user": "user1",
            #"access_key": "Z4JPCATOSZ46AR197954",
            #"secret_key": "MHXR4RSoMHhmZdxo69ARlotHJlwgCHh2c6Cqg1VC"
apt-cache madison s3cmd
apt install s3cmd -y
s3cmd --help
s3cmd --configure
cat /root/.s3cfg

# 创建bucket
s3cmd mb s3://mybucket
s3cmd mb s3://css
s3cmd mb s3://images

wget https://img1.jcloudcs.com/portal/brand/2021/fl1-2.jpg
s3cmd put fl1-2.jpg s3://test-s3cmd/
s3cmd put fl1-2.jpg s3://images/jpg/
s3cmd ls s3://images/
s3cmd ls s3://images/jpg/
s3cmd get s3://images/fl1-2.jpg /tmp/
ceph osd pool stats

s3cmd rm s3://images/fl1-2.jpg

