#!/bin/bash
#Author: "Zhang ShiJie"
#Email: "rooroot@aliyun.com"
#Date: 20220903

VERSION="1.5.0"
# VERSION = $1 # i.e. 1.5.0
S_DIR = "node_exporter-${VERSION}.linux-amd64"
PKG  = "node_exporter-${VERSION}.linux-amd64.tar.gz"

wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz
mkdir -p /apps
tar xvf ${PKG} -C /apps
ln -sv /apps/${S_DIR} /apps/node_exporter
\cp ./node-exporter.service /etc/systemd/systemd/node-node-exporter.service
systemctl daemon-reload && systemctl restart node-exporter && systemctl enable node-exporter
echo "node-exporter install successful"
