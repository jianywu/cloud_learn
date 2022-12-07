# 从官网下载
https://github.com/prometheus/node_exporter或https://gitee.com/AliyunContainerService/node_exporter
https://github.com/prometheus/node_exporter/releases/download/

# 安装
见 node_exporter_install.sh
node_exporter没有配置文件，参数都在选项里。
systemctl daemon-reload && systemctl restart node-exporter && systemctl enable node-exporter.service
http://ip:9100/metrics里有上传的metrics内容。
