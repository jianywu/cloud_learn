# 数据类型Data type
## 数据
instant vector：比如存scalar，内容是string，或者float。
range vector：比如一组数据。
scalar：float。用的少。
string：字符串，用的少。

## 类型
counter计数器
gauge仪表盘
histogram直方图
summary摘要

# 操作符
算数运算操作符：+-*/%^：可以对instance vector运算。
聚合操作符：min(), max(), avg(), sum()，count(), topk(k, metrics)，rate(), irate()等。
    count(node_os_version)可以统计节点数。
    absent(sum(prometheus_http_requests_total{handler="/metrics"}))可以看这个指标是否在，不在说明服务有问题。
    irate(node_network_receive_bytes_total[5m])可以看以太网的速率，rate比irate平滑一些。
时间：s/m/h/d/w/y

# 函数
absent()