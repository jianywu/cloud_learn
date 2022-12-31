#!/bin/bash

# 安装包
apt-cache madison ceph-mgr-dashboard
apt install ceph-mgr-dashboard
# 查看帮助
ceph mgr module -h
# 列出模块
ceph mgr module ls
ceph mgr module enable dashboard --force
ceph config set mgr mgr/dashboard/ssl false
ceph config set mgr mgr/dashboard/ceph-mgr1/server_addr 192.168.0.2
ceph config set mgr mgr/dashboard/ceph-mgr1/server_port 9009

ceph dashboard create-self-signed-cert
ceph config set mgr mgr/dashboard ssl true
# 这个命令可以看到mgr访问所需的IP和端口
ceph mgr services
	    #"dashboard": "http://172.16.0.2:9009/"

