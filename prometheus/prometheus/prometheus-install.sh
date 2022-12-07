#!/bin/bash
#Author: "Zhang ShiJie"
#Email: "rooroot@aliyun.com"
#Date: 20220903

VERSION="2.40.5"
PKG="prometheus-${VERSION}.linux-amd64.tar.gz"
S_DIR="prometheus-${VERSION}.linux-amd64"

wget https://github.com/prometheus/prometheus/releases/download/v2.40.5/${PKG}
mkdir -p /apps
tar xvf ${PKG} -C /apps/
ln -sv /apps/${S_DIR} /apps/prometheus
\cp ./prometheus.service /etc/systemd/system/prometheus.service
systemctl   daemon-reload &&  systemctl  restart prometheus && systemctl  enable  prometheus
echo "prometheus Server install successful"
