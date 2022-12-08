#!/bin/bash

set -x

VERSION="8.5.1"
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${VERSION}-linux-x86_64.tar.gz

S_DIR="elasticsearch-${VERSION}"
PKG="elasticsearch-${VERSION}-linux-x86_64.tar.gz"
mkdir -p /apps
tar xvf ${PKG} -C /apps
ln -sv /apps/${S_DIR} /apps/elasticsearch
\cp ./elasticsearch.service /etc/systemd/system/elasticsearch.service
systemctl daemon-reload && systemctl restart elasticsearch && systemctl enable elasticsearch

mkdir /data/esdata /data/eslogs /apps -pv
# Add user and group for ES
groupadd -g 2888 elasticsearch; useradd -u 2888 -g 2888 -r -m -s /bin/bash elasticsearch
# Untar elasticsearch.tgz, softlink to /apps/elasticsearch, change /apps is better.
# If change /apps/elasticsearch/ directory, make sure there is / after elasticsearch directory.
# Otherwise, this dir still not own with elastic.
chown elasticsearch.elasticsearch /data /apps -R

# make max_map_count bigger as 262144.
echo "vm.max_map_count = 262144" >> /etc/sysctl.conf
sysctl -p

echo "elasticsearch install successful."

# or install with deb
# wget https://mirrors.tuna.tsinghua.edu.cn/elasticstack/8.x/apt/pool/main/e/elasticsearch/elasticsearch-${VERSION}-amd64.deb
# sudo dpkg -i elasticsearch-${VERSION}-amd64.deb