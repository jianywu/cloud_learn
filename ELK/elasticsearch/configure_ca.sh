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

# setup password for different users, need enable xpack
echo "setup passwords: input password like magedu123"
/apps/elasticsearch/bin/elasticsearch-setup-passwords interactive

echo "add user"
/apps/elasticsearch/bin/elasticsearch-users useradd magedu -p 123456 -r superuser
