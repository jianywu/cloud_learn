1. 更新max_map_count
vim /etc/sysctl.conf
net.ipv4.ip_forward = 1
vm.max_map_count=262144

2. 安装elasticsearch
dpkg -i elasticsearch-8.5.1-amd64.deb
修改elasticsearch.yml即可。
