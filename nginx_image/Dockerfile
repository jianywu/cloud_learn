FROM ubuntu:22.04
LABLE author="Dave wujianyue000@gmail.com"

ADD sources.list /etc/apt/sources.list
RUN touch /etc/apt/apt.conf.d/99verify-peer.conf && echo >>/etc/apt/apt.conf.d/99verify-peer.conf "Acquire { https::Verify-Peer false }"

RUN apt update && apt  install -y iproute2  ntpdate  tcpdump telnet traceroute nfs-kernel-server nfs-common gcc openssh-server lrzsz tree openssl libssl-dev libpcre3 libpcre3-dev zlib1g-dev ntpdate tcpdump telnet traceroute iotop unzip zip make

ADD nginx-1.23.2.tar.gz /usr/local/src/
RUN cd /usr/local/src/nginx-1.23.2 && ./configure --prefix=/apps/nginx && make && make install && ln -sv /apps/nginx/sbin/nginx /usr/bin
RUN groupadd  -g 2088 nginx && useradd  -g nginx -s /usr/sbin/nologin -u 2088 nginx && chown -R nginx.nginx /apps/nginx
ADD nginx.conf /apps/nginx/conf/
ADD frontend.tar.gz /apps/nginx/html/

EXPOSE 80 443

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod a+x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
