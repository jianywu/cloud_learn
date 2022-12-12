1. 下载agent
从https://skywalking.apache.org/downloads/下载即可。

2. 装agent
```bash
mkdir /data
tar xvf apache-skywalking-java-agent-8.13.0.tgz -C /data
# 会出现新的目录skywalking-agent，配置文件在里面
vi /data/skywalking-agent/config/agent.config
agent.service_name=${SW_AGENT_NAME:jenkins}
agent.namespace=${SW_AGENT_NAMESPACE:magedu}
collector.backend_service=${SW_AGENT_COLLECTOR_BACKEND_SERVICES:Skywalking_IP:11800}
```

3. 配置halo
https://docs.halo.run/getting-started/prepare
apt install openjdk-11-jdk
cd /apps
wget https://dl.halo.run/release/halo-1.6.1.jar

4. 启动服务
java -javaagent:/data/skywalking-agent/skywalking-agent.jar -jar /apps/halo-1.6.1.jar
生产环境模板如下：
java -javaagent:/skywalking-agent/skywalking-agent.jar \
    -DSW_AGENT_NAMESPACE=xyz \
    -DSW_AGENT_NAME=abc-application \
    -Dskywalking.collector.backend_service=skywalking.abc.xyz.com:11800 \
    -jar abc-xyz-1.0-SNAPSHOT.jar
访问halo，在ip:8090端口，就可以看到skywalking的内容了。
普通服务 - 服务 - service name里就可以看到数据了。
