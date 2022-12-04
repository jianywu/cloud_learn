# haproxy install
apt-get -y install apt-transport-https ca-certificates curl software-properties-common
apt update
apt install haproxy

# update /etc/haproxy/haproxy.cfg
# update /etc/rsyslog.d/49-haproxy.conf