# 从grafana下载
https://grafana.com/grafana/download?pg=get&plcmt=selfmanaged-box1-cta1

```bash
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_9.3.1_amd64.deb
sudo dpkg -i grafana-enterprise_9.3.1_amd64.deb
```

配置文件在/etc/grafana/grafana.ini。需要修改下面这几个参数。其中http_addr可以写0.0.0.0，不可以是环回地址127.0.0.1，因为外部需要访问。
# Protocol (http, https, h2, socket)
protocol = http
# The ip address to bind to, empty will bind to all interfaces
http_addr = 0.0.0.0
# The http port  to use
http_port = 3000
