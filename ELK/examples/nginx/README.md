# setup nginx in host machine
wget https://nginx.org/download/nginx-1.23.2.tar.gz

# 注意nginx不是软链接到这里，否则会出现错误:
# cp: 'conf/koi-win' and '/apps/nginx/conf/koi-win' are the same file
mkdir /apps/nginx

# 配置/apps/nginx/conf/nginx.conf里的access_log路径为/var/log/nginx/access.log
# vi /apps/nginx-1.23.2/conf/nginx.conf
# access_log /var/log/nginx/access.log access_json;

# 编译nginx
# 安装需要的编译软件
apt update && apt  install -y iproute2  ntpdate  tcpdump telnet traceroute nfs-kernel-server nfs-common gcc openssh-server lrzsz tree openssl libssl-dev libpcre3 libpcre3-dev zlib1g-dev ntpdate tcpdump telnet traceroute iotop unzip zip make
# 编译nginx
./configure --prefix=/apps/nginx && make && make install

# 运行nginx
/apps/nginx/sbin/nginx

# 测试nginx的access log
如果不修改，默认路径还在/apps/nginx/logs/，目录里有access.log和error.log。
浏览器打开检查，点刷新按钮，选"清空缓存，并硬性重新加载"即可。

# 如果elasticsearch没看到log，可以搜索elasticsearch的打印
es的log在elasticsearch.yml中配置。
默认在/usr/share/elasticsearch/logs。
否则在docker-compose里可以配置volumes，来指定路径存储。
    volumes:
      - 'es-data:/usr/share/elasticsearch/data'
      - 'es-log:/usr/share/elasticsearch/log'

# 修改logstash的配置之后，重启logstash
systemctl restart logstash
