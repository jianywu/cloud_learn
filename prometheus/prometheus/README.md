# 安装
默认装/apps目录。运行prometheus-install.sh。

# 修改配置
配置文件在/apps/prometheus/config/prometheus.yml
修改localhost为0.0.0.0, 否则外网无法连上云主机。
其它的主要是加新的job，用于从某个ip和端口pull数据。

也可以加参数，比如--storage.tsdb.path=/var/logs。
如果存储是外部的，这个参数就无效了。

