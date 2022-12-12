
# 安装
安装openresty，是nginx增强版。
```bash
# 装依赖库
apt  install iproute2  ntpdate  tcpdump telnet traceroute nfs-kernel-server nfs-common  lrzsz tree  openssl libssl-dev libpcre3 libpcre3-dev zlib1g-dev ntpdate tcpdump telnet traceroute  gcc openssh-server lrzsz tree  openssl libssl-dev libpcre3 libpcre3-dev zlib1g-dev ntpdate tcpdump telnet traceroute iotop unzip zip -y
# 下载
wget https://openresty.org/download/openresty-1.21.4.1.tar.gz
tar xvf openresty-1.21.4.1.tar.gz
cd openresty-1.21.4.1/
# 配置安装到/apps/openresty目录
./configure --prefix=/apps/openresty  \
--with-luajit \
--with-pcre \
--with-http_iconv_module \
--with-http_realip_module \
--with-http_sub_module \
--with-http_stub_status_module \
--with-stream \
--with-stream_ssl_module
# 编译，安装
make -j; sudo make install
```

# 运行
先测试运行。
```bash
/apps/openresty/bin/openresty -t
/apps/openresty/bin/openresty
```
如果发现80端口被占用了，可以修改为其它端口测试，比如83
```bash
# 修改端口listen，比如81
vi /apps/openresty/nginx/conf/nginx.conf
```

#  配置agent
https://github.com/apache/skywalking-nginx-lua
https://github.com/apache/skywalking-nginx-lua

# mkdir  /data
# cd /data/
# wget https://github.com/apache/skywalking-nginx-lua/archive/refs/tags/v0.6.0.tar.gz
# mv v0.6.0.tar.gz  skywalking-nginx-lua-v0.6.0.tar.gz
# tar xvf skywalking-nginx-lua-v0.6.0.tar.gz

# cd /apps/openresty/nginx/conf/
# vim nginx.conf
  include /apps/openresty/nginx/conf/conf.d/*.conf;
 # mkdir  conf.d
