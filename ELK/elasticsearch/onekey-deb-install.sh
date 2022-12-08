#!/bin/bash

set -x

VERSION="8.5.1"

# Install with deb
wget https://mirrors.tuna.tsinghua.edu.cn/elasticstack/8.x/apt/pool/main/e/elasticsearch/elasticsearch-${VERSION}-amd64.deb
sudo dpkg -i elasticsearch-${VERSION}-amd64.deb

# Configure
# it will tell you original passwd: EJwVnECcNAzucyCrQeP3
#Reset the password of the elastic built-in superuser with
/usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic

#Generate an enrollment token for Kibana instances with
/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana

#Generate an enrollment token for Elasticsearch nodes with
/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s node

#If this node should join an existing cluster, you can reconfigure this with
# /usr/share/elasticsearch/bin/elasticsearch-reconfigure-node --enrollment-token <token-here>

### NOT starting on installation, please execute the following statements to configure elasticsearch service to start automatically using systemd
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
### You can start elasticsearch service by executing
sudo systemctl start elasticsearch.service
