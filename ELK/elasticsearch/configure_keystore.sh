#!/bin/bash

su - elasticsearch

echo "setup password for es"
passwd elasticsearch
# generate key store file
echo "generate keystore file"
/apps/elasticsearch/bin/elasticsearch-keystore create
echo "add keystore password: input password like magedu123"
/apps/elasticsearch/bin/elasticsearch-keystore add xpack.security.transport.ssl.keystore.secure_password
echo "add truststore password: input password like magedu123"
/apps/elasticsearch/bin/elasticsearch-keystore add xpack.security.transport.ssl.truststore.secure_password

scp -rp /apps/elasticsearch/config/elasticsearch.keystore es-node2:/apps/elasticsearch/config/elasticsearch.keystore
scp -rp /apps/elasticsearch/config/elasticsearch.keystore es-node3:/apps/elasticsearch/config/elasticsearch.keystore
