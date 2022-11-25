# setup
1. tar zxvf *.tar.gz
2. source docker-install.sh
3. update /etc/hosts, with insecure-registries' domain name and IP addr.

Those steps will be done by docker-install.sh directly:
1. update daemon.json, add insecure-registries, copy to /etc/docker/daemon.json
2. copy docker.service to /usr/lib/systemd/system/docker.service.
systemctl restart docker
systemctl status docker
systemctl enable docker
3. update /etc/sysctl.conf, add contents:
net.ipv4.ip_forward=1
vm.max_map_count=262144
kernel.pid_max=4194303
fs.file-max=1000000
net.ipv4.tcp_max_tw_buckets=6000
net.netfilter.nf_conntrack_max=2097152
#sysctl -p
