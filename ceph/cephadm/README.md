以ubuntu为例。
# 旧版本二进制安装
curl --silent --remote-name --location https://github.com/ceph/ceph/raw/octopus/src/cephadm/cephadm
chmod +x cephadm
mkdir -p /etc/ceph
./cephadm bootstrap --mon-ip 114.115.144.163

## 所有服务器上安装docker和cephadm
```bash
apt install cephadm -y
cephadm install ceph-common
mkdir -p /etc/ceph
```

## host主机执行的命令
### 搭建集群
```bash
cephadm bootstrap --mon-ip 192.168.0.79
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
```bash
ssh-copy-id -f -i /etc/ceph/ceph.pub root@ecs-337800
ssh-copy-id -f -i /etc/ceph/ceph.pub root@ecs-91251
ssh-copy-id -f -i /etc/ceph/ceph.pub root@ceph-mon2
```

### 集群添加其它节点
```bash
ceph orch host add ecs-337800
ceph orch host add ecs-91251
ceph orch host add ceph-mon2
```

### 配置mon节点
配置特定ip的子网，如果是0.0.0.0/0，表示所有IP和网段，不推荐。
```bash
ceph config set mon public_network 0.0.0.0/0
ceph orch apply mon ecs-337800
ceph orch apply mon ecs-91251
ceph orch apply mon ceph-mon2
```

### 添加osd从节点，如果是网速很慢的两台云主机，比如1MB的，可能会花很长时间，可以第二天再看
ceph orch daemon add osd ceph-mon2:/dev/vdb

# cat /etc/ceph/ceph.conf
# minimal ceph.conf for f2b6c5ae-805e-11ed-b5c1-61b685e79979
[global]
        fsid = f2b6c5ae-805e-11ed-b5c1-61b685e79979
        mon_host = [v2:192.168.0.79:3300/0,v1:192.168.0.79:6789/0]

cat /etc/ceph/ceph.client.admin.keyring
[client.admin]
        key = AQDypaFjiCkuDRAAfgvzCp4EHrqtnF8lY3Moqg==
        caps mds = "allow *"
        caps mgr = "allow *"
        caps mon = "allow *"
        caps osd = "allow *"


Ceph Dashboard is now available at:

             URL: https://localhost.vm:8443/
            User: admin
        Password: hjui40u6im

Enabling client.admin keyring and conf on hosts with "admin" label
Enabling autotune for osd_memory_target
You can access the Ceph CLI with:

        sudo /usr/sbin/cephadm shell --fsid f2b6c5ae-805e-11ed-b5c1-61b685e79979 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring

Please consider enabling telemetry to help improve Ceph:

        ceph telemetry on

For more information see:

        https://docs.ceph.com/docs/master/mgr/telemetry/

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

