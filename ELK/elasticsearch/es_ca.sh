#!/bin/bash
echo "generate private key"
./bin/elasticsearch-certutil ca
echo "generate public key via private key"
./bin/elasticsearch-certutil cert --ca elastic-stack-ca.p12
echo "generate cluster node certificate"
./bin/elasticsearch-certutil cert --silent --in instances.yml --out certs.zip --pass magedu123 --ca elastic-stack-ca.p12

echo "generate keystore file"
./bin/elasticsearch-keystore create
echo "add keystonre password"
./bin/elasticsearch-keystore add xpack.security.transport.ssl.keystore.secure_password
echo "add truststore password"
xpack.security.transport.ssl.truststore.secure_password
