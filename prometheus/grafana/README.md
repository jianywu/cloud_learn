# 从grafana下载
https://grafana.com/grafana/download?pg=get&plcmt=selfmanaged-box1-cta1

```bash
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_9.3.1_amd64.deb
sudo dpkg -i grafana-enterprise_9.3.1_amd64.deb
```

dockerhub也可以搜索grafana，也可以安装。docker里运行，性能会下降百分之十左右。
docker run -d --name=grafana -p 3000:3000 grafana/grafana
--name是docker创建后的容器名称，-p前面是host端口，后面是容器的端口。

# 修改配置
配置文件在/etc/grafana/grafana.ini。需要修改下面这几个参数。其中http_addr可以写0.0.0.0，不可以是环回地址127.0.0.1，因为外部需要访问。
```bash
# Protocol (http, https, h2, socket)
protocol = http
# The ip address to bind to, empty will bind to all interfaces
http_addr = 0.0.0.0
# The http port  to use
http_port = 3000
```

# 登录
看grafana的运行状态：
systemctl status grafana-server
http://ip:3000即可登录。
默认用户名和密码都是admin。

