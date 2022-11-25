# setup
1. Increase config
vi /etc/sysctl.conf
vm.max_map_count=26244
fs.file-max=65536
2. Bring up docker-compose sonar containers
docker-compose up -d
3. login to sonar IP:9000
4. install plugins:
Administration-Marketplace-I understand the risk.
Administration-Marketplace-chinese.
Administration-Configuration-General Settings-Security-Force user authentication: set to Off
Administration-System->Restart Server
5. enable systemd auto start:
cp sonar.service /etc/systemd/system/sonarqube.service
systemctl restart sonarqube
systemctl enable sonarqube.service

# FAQ
1. No quality profiles have been found, you probably don't have any language plugin installed.
