# 从官网下载
http://nginx.org/en/download.html
wget http://nginx.org/download/nginx-1.22.1.tar.gz

tar zxvf nginx-1.22.1.tar.gz
ln -sv /apps/nginx-1.22.1 /apps/nginx

# 修改配置文件
如果是apt install nginx的，在/etc/nginx/nginx.conf目录。
如果二进制安装的，在安装目录的conf文件夹下。
vim /apps/nginx/conf/nginx.conf
log_format access_json '{"@timestamp":"$time_iso8601",'
'"host":"$server_addr",'
'"clientip":"$remote_addr",'
'"size":$body_bytes_sent,'
'"responsetime":$request_time,'
'"upstreamtime":"$upstream_response_time",'
'"upstreamhost":"$upstream_addr",'
'"http_host":"$host",'
'"uri":"$uri",'
'"domain":"$host",'
'"xff":"$http_x_forwarded_for",'
'"referer":"$http_referer",'
'"tcp_xff":"$proxy_protocol_addr",'
'"http_user_agent":"$http_user_agent",'
'"status":"$status"}';
access_log /var/log/nginx/access.log access_json;
