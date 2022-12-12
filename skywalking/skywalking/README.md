# 安装依赖
比如elasticsearch

# 安装skywalking
1. apt install openjdk-11-jdk -y
2. 运行skywalking_install.sh

# 访问skywalking
http://124.223.157.166:8080
8080就是skywalking-ui开放的端口。
也可以在webapp/application.yml文件中修改端口号，比如8081，避免和其它服务冲突。
serverPort: ${SW_SERVER_PORT:-8081}

