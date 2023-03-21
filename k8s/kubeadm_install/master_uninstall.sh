# 如果有cri-docker，需要加上后续的配置
kubeadm reset --cri-socket unix:///run/cri-dockerd.sock
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
ipvsadm --clear
systemctl stop kubelet
systemctl stop docker
rm -rf /var/lib/cni/*
rm -rf /var/lib/kubelet/*
rm -rf /etc/cni/*
rm -rf $HOME/.kube/config
systemctl start docker
systemctl start kubelet

# 需要重启才行，不重启还是无效的
sudo reboot
