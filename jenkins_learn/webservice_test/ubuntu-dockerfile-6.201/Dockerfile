FROM ubuntu:22.04
MAINTAINER "jack 2973707860@qq.com"


ADD sources.list /etc/apt/sources.list

RUN apt update && apt  install -y iproute2  ntpdate  tcpdump telnet traceroute nfs-kernel-server nfs-common  lrzsz tree  openssl libssl-dev libpcre3 libpcre3-dev zlib1g-dev ntpdate tcpdump telnet traceroute  gcc openssh-server lrzsz tree  openssl libssl-dev libpcre3 libpcre3-dev zlib1g-dev ntpdate tcpdump telnet traceroute iotop unzip zip make


ADD nginx-1.22.0.tar.gz /usr/local/src/
RUN cd /usr/local/src/nginx-1.22.0 && ./configure --prefix=/apps/nginx && make && make install  && ln -sv /apps/nginx/sbin/nginx /usr/bin
RUN groupadd  -g 2088 nginx && useradd  -g nginx -s /usr/sbin/nologin -u 2088 nginx && chown -R nginx.nginx /apps/nginx
ADD nginx.conf /apps/nginx/conf/
ADD frontend.tar.gz /apps/nginx/html/


EXPOSE 80 443
#ENTRYPOINT ["nginx"]
CMD ["nginx","-g","daemon off;"]
