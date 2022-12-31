#!/bin/bash

# 安装包
apt-cache madison ceph-mgr-dashboard
apt install ceph-mgr-dashboard
# 查看帮助
ceph mgr module -h
# 列出模块
ceph mgr module ls


