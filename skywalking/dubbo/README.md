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
安装java的agent，这个步骤和halo的例子类似。
如果一个服务器有多个agent可以放到不同目录。比如/data/skywalking-agent_dubbo目录。
修改skywalking的/data/skywalking-agent_dubbo_server/config/agent.config文件，backend_service的skywalking可以在另一台服务器。
agent.service_name=${SW_AGENT_NAME:dubbo-server1}
agent.namespace=${SW_AGENT_NAMESPACE:myserver}
collector.backend_service=${SW_AGENT_COLLECTOR_BACKEND_SERVICES:114.115.221.236:11800}

# 配置注册中心ZK
## 安装ZK
需要jdk11版本，否则会出错，Starting zookeeper ... FAILED TO START。
```bash
wget https://dlcdn.apache.org/zookeeper/zookeeper-3.7.1/apache-zookeeper-3.7.1-bin.tar.gz
tar xvf apache-zookeeper-3.7.1-bin.tar.gz -C /apps
# 用默认配置文件
cp /apps/apache-zookeeper-3.7.1-bin/conf/zoo_sample.cfg /apps/apache-zookeeper-3.7.1-bin/conf/zoo.cfg
# 启动ZK
/apps/apache-zookeeper-3.7.1-bin/bin/zkServer.sh start
# 看2181是否被tcp监听了
lsof -i :2181
```
## 配置ZK服务器地址
如果云主机在一个集群，可以用私网地址，否则用公网的。
注意这里是ZK_SERVER1，因为dubbo里用这个搜索。
```bash
# 加上export ZK_SERVER1="124.223.157.166"
vim /etc/profile
source /etc/profile
echo $ZK_SERVER1
```

# 启动dubbo provider服务端
## 启动server
```bash
mkdir -pv /apps/dubbo/provider
# /apps/dubbo/provider里放dubbo-server.jar
# java启动，第一个是skywalking的agent，第二个是jar包。
java -javaagent:/data/skywalking-agent_dubbo_server/skywalking-agent.jar -jar /apps/dubbo/provider/dubbo-server.jar
```
# 启动dubbo consumer客户端
在另一台服务器，可以启动客户端client。
和server类似，装好skywalking的agent，service_name，namespace和backend_service修改一下，然后配置skywalking和ZK的解析地址。
```bash
#/etc/profile中加入export SW_SERVER="114.115.221.236"和export ZK_SERVER1="124.223.157.166"
vi /etc/profile
echo $SW_SERVER
echo $ZK_SERVER1
mkdir -pv /apps/dubbo/consumer
# 把dubbo-client.jar复制到/apps/dubbo/consumer
java -javaagent:/data/skywalking-agent_dubbo_client/skywalking-agent.jar -jar /apps/dubbo/consumer/dubbo-client.jar
```

# 测试访问dubbo客户端
访问consumer的端口即可，默认是8080，可以修改为其它。
http://42.51.17.66:8080/hello?name=Jack

## tomcat里运行dubbo的war包
需要8080端口，所以要先把8080端口释放出来。否则会出错：
15-Dec-2022 09:32:10.129 SEVERE [main] org.apache.catalina.core.StandardService.initInternal Failed to initialize connector [Connector[HTTP/1.1-8080]]
启动Tomcat:
/apps/apache-tomcat-8.5.84# ./bin/catalina.sh start
```bash
rm -rf /apps/apache-tomcat-8.5.84/webapps/*
# 把dubbo的war包放到webapps目录下
unzip dubboadmin.war
# 更新ZK地址：dubbo.registry.address=zookeeper://124.223.157.166:2181
vi dubboadmin/WEB-INF/dubbo.properties
```
日志可以查看文件logs/catalina.2022-12-15.log。

# QA
1. Caused by: org.springframework.beans.factory.BeanDefinitionStoreException: Invalid bean definition with name 'com.alibaba.dubbo.config.RegistryConfig' defined in null: Could not resolve placeholder 'ZK_SERVER1' in string value "zookeeper://${ZK_SERVER1}:2181"; nested exception is java.lang.IllegalArgumentException: Could not resolve placeholder 'ZK_SERVER1' in string value "zookeeper://${ZK_SERVER1}:2181"
配置不准确，配置/etc/profile里写的是ZK_SERVER，而不是ZK_SERVER1。
2. Failed to bind NettyServer on /10.0.4.5:20880, cause: Failed to bind to: /0.0.0.0:20880
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 52:54:00:fd:c2:cf brd ff:ff:ff:ff:ff:ff
    altname enp0s5
    altname ens5
    inet 10.0.4.5/22 metric 100 brd 10.0.7.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fefd:c2cf/64 scope link
       valid_lft forever preferred_lft forever
原因是dubbo的server和client都需要jdk8，而ZK需要jdk11。dubbo和ZK用不同服务器，使用不同版本即可。
dubbo的server和client可以在一个服务器部署，不过client要和skywalking的区分开，因为端口8080是复用的。
或者同一台服务器，docker-compose中，把skywalking-ui的端口修改为其它的，如8081。

