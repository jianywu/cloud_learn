#!/bin/bash
# generate ca
echo "generate private key"
./bin/elasticsearch-certutil ca
echo "generate public key via private key"
./bin/elasticsearch-certutil cert --ca elastic-stack-ca.p12
echo "generate cluster node certificate"
./bin/elasticsearch-certutil cert --silent --in instances.yml --out certs.zip --pass magedu123 --ca elastic-stack-ca.p12

unzip certs.zip
mkdir config/certs
cp -rp es1.example.com/es1.example.com.p12 config/certs

scp -rp es2.example.com/es2.example.com.p12 es-node2:/apps/elasticsearch/config/certs
scp -rp es3.example.com/es3.example.com.p12 es-node3:/apps/elasticsearch/config/certs

# generate key store file
echo "generate keystore file"
./bin/elasticsearch-keystore create
echo "add keystore password"
./bin/elasticsearch-keystore add xpack.security.transport.ssl.keystore.secure_password
echo "add truststore password"
./bin/elasticsearch-keystore add xpack.security.transport.ssl.truststore.secure_password

scp -rp /apps/elasticsearch/config/elasticsearch.keystore es-node2:/apps/elasticsearch/config/elasticsearch.keystore
scp -rp /apps/elasticsearch/config/elasticsearch.keystore es-node3:/apps/elasticsearch/config/elasticsearch.keystore

# setup password
echo "setup passwords"
./bin/elasticsearch-setup-passwords interactive

echo "add user"
./bin/elasticsearch-users useradd magedu -p 123456 -r superuser
