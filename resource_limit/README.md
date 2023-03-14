Refer to https://github.com/yangguangchao, thanks.

Use k8s 1.26
kubeadm reset --cri-socket unix:///var/run/cri-dockerd.sock
master:
kbeadm init --control-plane-endpoint="kubeapi.magedu.com" --kubernetes-version=v1.26.0 --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 --token-ttl=0 --cri-socket unix:///run/cri-dockerd.sock --upload-certs
export KUBECONFIG=/etc/kubernetes/admin.conf
scp /etc/kubernetes/admin.conf k8s-node01:/etc/kubernetes/admin.conf
scp /etc/kubernetes/admin.conf k8s-node02:/etc/kubernetes/admin.conf
scp /etc/kubernetes/admin.conf k8s-node03:/etc/kubernetes/admin.conf
node:
kubeadm join kubeapi.magedu.com:6443 --cri-socket unix:///run/cri-dockerd.sock --token nhds92.ib0uos36wcc1i3yt --discovery-token-ca-cert-hash sha256:2891c2bf77909f1bcb611958eeec87b6dcfae88068690a9cc14277da6fe18644
