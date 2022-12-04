参考：
git clone https://gitee.com/jiege-gitee/elk-docker-compose.git

cd docker-elk-compose
# 运行elasticsearch容器
docker-compose up -d elasticsearch
# 设置用户名elastic，密码magedu123
docker exec -it elasticsearch /usr/share/elasticsearch/bin/elasticsearch-setup-passwords interactive
# 修改kibana连接elasticsearch的账户密码：
vim kibana/config/kibana.yml
# 修改logstash连接elasticsearch的账户密码
vim logstash/config/logstash.yml
# 修改Logstash输入输出规则
vim logstash/config/logstash.conf
# 运行所有容器
docker-compose up -d
