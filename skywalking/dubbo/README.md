# jdk切换低版本
需要换成jdk8，用于实验。dubbo的服务器貌似jdk11可以，client需要jdk8。
```bash
apt-get update -y
apt install apt-transport-https ca-certificates wget dirmngr -y
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public |sudo apt-key add -
sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
apt update -y
apt install adoptopenjdk-8-hotspot -y
# 选择Java版本
update-alternatives --config java
# 检查Java版本，注意version前一个中划线即可
java -version
# 需删除jdk8时，这样操作即可。
apt remove adoptopenjdk-8-hotspot
```

# 安装并配置agent
这个步骤和halo的例子类似。
如果一个服务器有多个agent可以放到不同目录。比如/data/skywalking-agent_dubbo目录。
修改skywalking的/data/skywalking-agent_dubbo/config/agent.config文件，backend_service的skywalking可以在另一台服务器。
agent.service_name=${SW_AGENT_NAME:dubbo-server1}
agent.namespace=${SW_AGENT_NAMESPACE:myserver}
collector.backend_service=${SW_AGENT_COLLECTOR_BACKEND_SERVICES:42.51.17.66:11800}

# 配置ZK
## 安装ZK
```bash
wget https://dlcdn.apache.org/zookeeper/zookeeper-3.7.1/apache-zookeeper-3.7.1-bin.tar.gz
tar xvf apache-zookeeper-3.7.1-bin.tar.gz -C /apps
# 用默认配置文件
cp /apps/apache-zookeeper-3.7.1-bin/conf/zoo_sample.cfg /apps/apache-zookeeper-3.7.1-
bin/conf/zoo.cfg
# 启动ZK
/apps/apache-zookeeper-3.7.1-bin/bin/zkServer.sh start
# 看2181是否被tcp监听了
lsof -i :2181
```
## 配置服务器地址
```bash
# 加上export ZK_SERVER1=124.223.157.166
vim /etc/profile
source /etc/profile
echo $ZK_SERVER1
```

# 启动dubbo服务
## 启动server
```bash
mkdir -pv /apps/dubbo/provider
# /apps/dubbo/provider里放dubbo.jar
# java启动，第一个是skywalking的agent，第二个是jar包。
java -javaagent:/data/skywalking-agent_dubbo/skywalking-agent.jar -jar /apps/dubbo/provider/dubbo-server.jar
```
## 启动client
在另一台服务器，可以启动client。
和server类似，装好skywalking的agent，然后配置skywalking和ZK的解析地址。
```bash
#/etc/profile中加入export SW_SERVER="42.51.17.66"和export ZK_SERVER="124.223.157.166"
vi /etc/profile
echo $SW_SERVER
echo $ZK_SERVER
mkdir -pv /apps/dubbo/consumer
# 把dubbo-client.jar复制到/apps/dubbo/consumer
java -javaagent:/data/skywalking-agent/skywalking-agent.jar -jar /apps/dubbo/consumer/dubbo-client.jar
```

# tomcat里运行dubbo的war包
```bash
rm -rf /apps/apache-tomcat-8.5.84/webapps/*
# 把dubbo的war包放到webapps目录下
unzip dubboadmin.war
# 更新ZK地址：dubbo.registry.address=zookeeper://124.223.157.166:2181
vi dubboadmin/WEB-INF/dubbo.properties
```

