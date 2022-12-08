# 配置
federal是连接其它Prometheus的node的，端口是Prometheus的9090。
idc是连接node_exporter的，端口是node_exporter的9100。


# grafana
1. Configuration-Data Sources-选择Prometheus
连接到federal的Prometheus即可。
2. Create-Import加入到Grafana
3. DashBoard-Browse可以看到创建的图。
