# harbor主机的配置
sudo snap install docker
sudo apt install docker-compose
#https://github.com/goharbor/harbor/releases/
wget https://github.com/goharbor/harbor/releases/download/v1.10.17/harbor-offline-installer-v1.10.17.tgz
mkdir /apps
tar zxf harbor-offline-installer-v1.10.17.tgz -C /apps
cd /apps/harbor
mkdir /data
#change hostname to IP addr can access by external, change harbor_admin_password
vi harbor.yml
source ./install.sh
#安装好后，从windows登录harbor, 用户名admin，密码是之前配置的harbor_admin_password
http://172.29.7.9/
#新建magedu和baseimage的项目，方便后续使用

# 其它使用harbor的主机如下
试下curl harbor的网址，还有80端口
curl harbor.magedu.net:80
## 登录
docker login harbor.magedu.net
## docker加上insecure的配置
/lib/systemd/system/docker.service中的ExecStart里加上选项--insecure-registry harbor.magedu.net
systemctl daemon-reload
systemctl restart docker
## 测试push
docker pull elevy/slim_java:8
docker tag elevy/slim_java:8 harbor.magedu.net/baseimages/slim_java:8
docker push harbor.magedu.net/baseimages/slim_java:8

docker pull zookeeper:3.8.1
docker tag zookeeper:3.8.1 harbor.magedu.net/magedu/zookeeper:3.8.1
docker push harbor.magedu.net/magedu/zookeeper:3.8.1
