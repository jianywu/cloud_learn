# 下载agent
从https://skywalking.apache.org/docs/skywalking-java/latest/en/setup/service-agent/java-agent/readme/下载即可。

# 安装并配置agent
这个步骤和halo的例子类似。
```bash
mkdir /data
tar xvf apache-skywalking-java-agent-8.13.0.tgz -C /data
# 会出现新的目录skywalking-agent，配置文件在里面
vi /data/skywalking-agent/config/agent.config
agent.service_name=${SW_AGENT_NAME:magedu}
agent.namespace=${SW_AGENT_NAMESPACE:jenkins}
collector.backend_service=${SW_AGENT_COLLECTOR_BACKEND_SERVICES:124.223.157.166:11800}
```

# 配置tomcat
wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.84/bin/apache-tomcat-8.5.84.tar.gz
tar xvf apache-tomcat-8.5.84.tar.gz -C /apps
把jenkins.war文件放到/apps/apache-tomcat-8.5.84/webapps目录。
```bash
vim /apps/apache-tomcat-8.5.84/bin/catalina.sh
# 文件里加上这几行
CATALINA_OPTS="$CATALINA_OPTS -javaagent:/data/skywalking-agent/skywalking-agent.jar"; export CATALINA_OPTS
```

# 启动服务
/apps/apache-tomcat-8.5.84/bin/catalina.sh run
访问ip:8080/jenkins，就可以看到jenkins的内容了。
普通服务 - 服务 - service name里就可以看到数据了。
