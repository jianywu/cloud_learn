#!/bin/bash

set -x

VERSION="1.5.1"
PKG="pushgateway-${VERSION}.linux-amd64.tar.gz"
S_DIR="pushgateway-${VERSION}.linux-amd64"

wget https://github.com/prometheus/pushgateway/releases/download/v${VERSION}/${PKG}
mkdir -p /apps
tar xvf ${PKG} -C /apps/
ln -sv /apps/${S_DIR} /apps/pushgateway
\cp ./pushgateway.service /etc/systemd/system/pushgateway.service
systemctl daemon-reload && systemctl restart pushgateway && systemctl enable pushgateway
echo "pushgateway install successful"
