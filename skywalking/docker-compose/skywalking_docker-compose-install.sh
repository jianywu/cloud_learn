mkdir -pv /data/elasticsearch
# 防止没有权限写数据
chown 1000.1000 -R /data/elasticsearch
docker-compose up -d