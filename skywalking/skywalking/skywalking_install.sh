#!/bin/bash

VERSION="9.3.0"
# VERSION = $1
PKG = "apache-skywalking-apm-${VERSION}.tar.gz"

wget https://dlcdn.apache.org/skywalking/${VERSION}/apache-skywalking-apm-${VERSION}.tar.gz
mkdir -p /apps
tar xvf ${PKG} -C /apps
ln -sv /apps/apache-skywalking-apm-bin /apps/skywalking
\cp ./skywalking.service /etc/systemd/system/skywalking.service
systemctl daemon-reload && systemctl restart skywalking && systemctl enable skywalking
echo "Skywalking install successful"
