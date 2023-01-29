#!/bin/bash

# refer to this link, thanks
# https://mp.weixin.qq.com/s/fX_SHoRYUFzGBZp9VidDSQ

# time sync
apt install chrony
systemctl start chrony.service
systemctl status chrony.service
systemctl enable chrony.service

# disable swap
swapoff -a
systemctl --type swap
# 手工删除/etc/fstab里带swap的那一行，确保重启后，swap还是关闭的

# disable firewall
ufw disable
ufw status
apt install -y firewalld
systemctl stop firewalld && systemctl disable firewalld

# install docker
apt -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
apt update -y
apt install docker-ce -y

# 给docker加镜像加速服务, 有镜像加速后，就可以不需要代理了
echo ./daemon.json >> /etc/docker/daemon.json
systemctl daemon-reload
systemctl start docker
systemctl enable docker

# install cri-dockerd
# wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.0/cri-dockerd_0.3.0.3-0.ubuntu-focal_amd64.deb
chmod 777 ./cri-dockerd_0.3.0.3-0.ubuntu-focal_amd64.deb
apt install -y ./cri-dockerd_0.3.0.3-0.ubuntu-focal_amd64.deb

# kubelet, kubeadm, kubectl, 注意这里kubbernetes后是跟xenial，哪怕是20.04系统，也不是focal的
apt-get update -y && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt-get update -y
apt-get install -y kubelet kubeadm kubectl

systemctl enable kubelet

# /usr/lib/systemd/system/cri-docker.service文件里，ExecStart加上cni插件
# ExecStart=/usr/bin/cri-dockerd --container-runtime-endpoint fd:// --network-plugin=cni --cni-bin-dir=/opt/cni/bin --cni-cache-dir=/var/lib/cni/cache --cni-conf-dir=/etc/cni/net.d

# 配置kubelet
mkdir -p /etc/sysconfig
cp kubelet.conf /etc/sysconfig/kubelet

# 启动kubeadm主节点
sh ./kubeadm_init.sh

# 获取flannel网络插件
# wget https://github.com/flannel-io/flannel/releases/download/v0.20.2/flanneld-amd64
mkdir -p /opt/bin/
cp flanneld-amd64 /opt/bin/flanneld
chmod +x /opt/bin/flanneld
# 配置flannel
# wget https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
kubelet apply -f kube-flannel.yml

# 看kubelet，应该是正常运行了
systemctl status kubelet
journalctl -xeu kubelet
