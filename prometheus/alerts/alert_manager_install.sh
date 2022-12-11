#!/bin/bash

VERSION="0.24.0"
S_DIR = "alertmanager-${VERSION}.linux-amd64"
PKG  = "alertmanager-${VERSION}.linux-amd64.tar.gz"

wget https://github.com/prometheus/alertmanager/releases/download/v${VERSION}/alertmanager-${VERSION}.linux-amd64.tar.gz
mkdir -p /apps
tar xvf ${PKG} -C /apps
ln -sv /apps/${S_DIR} /apps/alertmanager
\cp ./alertmanager.service /etc/systemd/systemd/alertmanager.service
systemctl daemon-reload && systemctl restart alertmanager && systemctl enable alertmanager
echo "alertmanager install successful"
