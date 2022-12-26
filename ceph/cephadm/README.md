以ubuntu为例。
# 旧版本二进制安装
```bash
curl --silent --remote-name --location https://github.com/ceph/ceph/raw/octopus/src/cephadm/cephadm
chmod +x cephadm
mkdir -p /etc/ceph
./cephadm bootstrap --mon-ip 114.115.144.163
```

## 所有服务器上安装docker和cephadm
注意cephadm需要20.04以上版本，最好是22.04版本。
```bash
apt install cephadm -y
cephadm install ceph-common
mkdir -p /etc/ceph
```

## 时钟同步
```bash
ntpdate time1.aliyun.com
chronyc sources
```

## host主机执行的命令
### 搭建集群
第一步在ecs-211060服务器执行。
```bash
#cephadm bootstrap --mon-ip 192.168.0.2
#可以指定初始用户名密码，方便后续访问。如果是云主机，这里需要用私网IP才可以。
cephadm bootstrap --mon-ip 10.0.0.2 --initial-dashboard-user ceph --initial-dashboard-password ceph
```
1. 会创建mon和mgr进程。生成密钥
2. 添加到/root/.ssh/authrized_kyes文件中。
3. 生成配置文件/etc/ceph/ceph.conf
4. 生成keyring
5. 公钥放/etc/ceph/ceph.pub

### 安装ceph
```bash
cephadm install ceph-common
# 或alias ceph='cephadm shell -- ceph'
ceph -s
```

### 复制key到从机
注意这里必须要用主机名才可以，/etc/hosts里用非主机的alias是不行的。
这里的ecs-337800和ecs-91251是云主机，可用私网地址，也可用公网地址，都是通的。但最好用私网地址，这样vpc通信比较快。
```bash
ssh-copy-id -f -i /etc/ceph/ceph.pub root@ecs-211060
ssh-copy-id -f -i /etc/ceph/ceph.pub root@ecs-337800
ssh-copy-id -f -i /etc/ceph/ceph.pub root@ecs-91251
ssh-copy-id -f -i /etc/ceph/ceph.pub root@ceph-mon2
```

### 复制配置到从机
复制配置后，从机也可以执行ceph -s了。
```bash
scp -r /etc/ceph/ceph.conf /etc/ceph/ceph.client.admin.keyring ecs-211060:/etc/ceph/
scp -r /etc/ceph/ceph.conf /etc/ceph/ceph.client.admin.keyring ecs-337800:/etc/ceph/
scp -r /etc/ceph/ceph.conf /etc/ceph/ceph.client.admin.keyring ecs-91251:/etc/ceph/
scp -r /etc/ceph/ceph.conf /etc/ceph/ceph.client.admin.keyring ceph-mon2:/etc/ceph/
```

### 使能firewalld，打开端口
因为后续的mon和crash的service会用到firewalld的service，必须要打开才行。
```bash
systemctl start firewalld && systemctl enable firewalld.service
firewall-cmd --zone=public --add-port=1-65535/tcp --permanent
firewall-cmd --zone=public --add-port=1-65535/udp --permanent
```

### 集群添加其它节点
会启动node_exporter,还有ceph-crash的容器
```bash
ceph orch host add ecs-211060
ceph orch host add ecs-337800
ceph orch host add ecs-91251
ceph orch host add ceph-mon2
#看有哪些host注册了，集群中任意机器执行都可以
ceph orch host ls
```

### 配置mon节点
在/var/log/ceph/cephadm.log里可看到日志，可查找出错的log。
配置特定ip的子网，如果是0.0.0.0/0，表示所有IP和网段，不推荐，更推荐某个特定的网段。
```bash
# 不加这一条，后面的mon就不会启动，因为指定了默认的网段是前24位的，Setting mon public_network to 10.0.0.0/24
# 发现使用公网IP也不行，必须使用0.0.0.0/0才行
ceph config set mon public_network 0.0.0.0/0
ceph orch apply mon ecs-211060
ceph orch apply mon ecs-337800
ceph orch apply mon ecs-91251
ceph orch apply mon ceph-mon2
```

### 添加osd从节点，如果是网速很慢的两台云主机，比如1MB的，可能会花很长时间，可以第二天再看
```bash
#执行命令后，会建一个容器/usr/sbin/ceph-volum
#如报错mkfs失败，可以先mkfs.xfs /dev/vdb，然后wipefs -a /dev/vdb，其实就擦除了4字节，再试下
#如已建过osd，可先删除，dmsetup remove -f /dev/mapper/ceph-*，再mkfs，再wipefs
#注意3个命令都要在host执行
ceph orch daemon add osd ecs-211060:/dev/vdb
ceph orch daemon add osd ecs-337800:/dev/vdb
ceph orch daemon add osd ecs-91251:/dev/vdb
ceph orch daemon add osd ceph-mon2:/dev/vdb
#查看osd配置情况
ceph osd tree
ceph -s

# 清除集群
```bash
# deployment节点
ceph orch pause
# 或者docker ps看容器名字里的fsid也可以
# 或者cat /etc/ceph/ceph.conf
ceph fsid
# 所有节点
#cephadm rm-cluster --force --zap-osds --fsid <fsid>
cephadm rm-cluster --force --fsid 80b05f70-813e-11ed-9d92-fa163e87c045
```

# 测试记录
Ceph Dashboard is now available at:

             URL: https://localhost.vm:8443/
            User: ceph
        Password: ceph

Enabling client.admin keyring and conf on hosts with "admin" label
Enabling autotune for osd_memory_target
You can access the Ceph CLI with:

        sudo /usr/sbin/cephadm shell --fsid 9ea8ef74-8364-11ed-b5c1-61b685e79979 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring

Please consider enabling telemetry to help improve Ceph:

        ceph telemetry on

For more information see:

        https://docs.ceph.com/docs/master/mgr/telemetry/

Bootstrap complete.

# ceph -s
  cluster:
    id:     f2b6c5ae-805e-11ed-b5c1-61b685e79979
    health: HEALTH_WARN
            OSD count 0 < osd_pool_default_size 3

  services:
    mon: 1 daemons, quorum ecs-211060 (age 9m)
    mgr: ecs-211060.znkmyr(active, since 7m)
    osd: 0 osds: 0 up, 0 in

  data:
    pools:   0 pools, 0 pgs
    objects: 0 objects, 0 B
    usage:   0 B used, 0 B / 0 B avail
    pgs:

#  ceph orch host ls
HOST        ADDR             LABELS  STATUS
ecs-91251  114.115.221.236
ecs-211060 192.168.0.2      _admin
ecs-337800 114.115.154.84
3 hosts in cluster

ceph现在都是docker的方式运行的。
# docker ps
CONTAINER ID   IMAGE                                     COMMAND                  CREATED          STATUS          PORTS     NAMES
fe4f84281426   quay.io/prometheus/alertmanager:v0.23.0   "/bin/alertmanager -…"   8 minutes ago    Up 8 minutes              ceph-f2b6c5ae-805e-11ed-b5c1-61b685e79979-alertmanager-ecs-211060
90755e45fc1b   quay.io/ceph/ceph-grafana:8.3.5           "/bin/sh -c 'grafana…"   8 minutes ago    Up 8 minutes              ceph-f2b6c5ae-805e-11ed-b5c1-61b685e79979-grafana-ecs-211060
74b472e8cc11   quay.io/prometheus/prometheus:v2.33.4     "/bin/prometheus --c…"   8 minutes ago    Up 8 minutes              ceph-f2b6c5ae-805e-11ed-b5c1-61b685e79979-prometheus-ecs-211060
e3dca1e21af3   quay.io/prometheus/node-exporter:v1.3.1   "/bin/node_exporter …"   9 minutes ago    Up 9 minutes              ceph-f2b6c5ae-805e-11ed-b5c1-61b685e79979-node-exporter-ecs-211060
07bded2c8485   quay.io/ceph/ceph                         "/usr/bin/ceph-crash…"   10 minutes ago   Up 10 minutes             ceph-f2b6c5ae-805e-11ed-b5c1-61b685e79979-crash-ecs-211060
7675a9eba27f   quay.io/ceph/ceph:v17                     "/usr/bin/ceph-mgr -…"   11 minutes ago   Up 11 minutes             ceph-f2b6c5ae-805e-11ed-b5c1-61b685e79979-mgr-ecs-211060-znkmyr
b2c41e1e55b7   quay.io/ceph/ceph:v17                     "/usr/bin/ceph-mon -…"   11 minutes ago   Up 11 minutes             ceph-f2b6c5ae-805e-11ed-b5c1-61b685e79979-mon-ecs-211060

QA:
Q1: RuntimeError: cephadm exited with an error code: 1, stderr:ERROR: fsid does not match ceph.conf
A1:
在deploy服务器上：
ceph-osd --cluster=ceph --show-config-value=fsid
f2b6c5ae-805e-11ed-b5c1-61b685e79979
获得fsid，然后写到osd的node节点/etc/ceph/ceph.conf即可。

Q2: RuntimeError: Device /dev/vdb has a filesystem.
A2: wipefs -a /dev/vdb，删除这个设备的fs即可。

