#看k8s版本需要哪些镜像
#kubeadm config images list --kubernetes-version v1.24.10
#registry.k8s.io/kube-apiserver:v1.24.10
#registry.k8s.io/kube-controller-manager:v1.24.10
#registry.k8s.io/kube-scheduler:v1.24.10
#registry.k8s.io/kube-proxy:v1.24.10
#registry.k8s.io/pause:3.7
#registry.k8s.io/etcd:3.5.6-0
#registry.k8s.io/coredns/coredns:v1.8.6

# 注意pause有2个版本，分别是3.6和3.7的，如果发现journal -xeu kubelet里有提示
#7409 kuberuntime_manager.go:815] "CreatePodSandbox for pod failed" err="rpc error: code = Unknown desc = failed pulling image \"registry.k8s.io/pause:3.6\": Error response from daemo>
#表示pause这个image没有下载下来。
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.24.10
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.24.10
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.24.10
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.24.10
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.6
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.7
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.5.6-0
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.8.6

docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.24.10 registry.k8s.io/kube-apiserver:v1.24.10
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.24.10 registry.k8s.io/kube-controller-manager:v1.24.10
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.24.10 registry.k8s.io/kube-scheduler:v1.24.10
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.24.10 registry.k8s.io/kube-proxy:v1.24.10
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.6 registry.k8s.io/pause:3.6
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.7 registry.k8s.io/pause:3.7
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.5.6-0 registry.k8s.io/etcd:3.5.6-0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.8.6 registry.k8s.io/coredns/coredns:v1.8.6

#master
kubeadm init --apiserver-advertise-address=172.31.6.201 --apiserver-bind-port=6443 --kubernetes-version=v1.24.10 --pod-network-cidr=10.200.0.0/16 --service-cidr=172.31.5.0/24 --service-dns-domain=cluster.local --ignore-preflight-errors=swap --cri-socket unix:///var/run/cri-dockerd.sock
# 如果是1.26.0版本的：
#kubeadm config images pull --cri-socket unix:///run/cri-dockerd.sock --image-repository=registry.aliyuncs.com/google_containers
#docker pull registry.aliyuncs.com/google_containers/pause:3.6
#docker tag registry.aliyuncs.com/google_containers/pause:3.6 registry.k8s.io/pause:3.6
#kubeadm init --control-plane-endpoint="kubeapi.magedu.com" --kubernetes-version=v1.26.0 --pod-network-cidr=10.244.0.0/16 --service-cidr=172.31.5.0/24 --token-ttl=0 --cri-socket unix:///run/cri-dockerd.sock --upload-certs  --image-repository=registry.aliyuncs.com/google_containers
#1.26.0需要是10.244.0.0，否则会出错：Error registering network: failed to acquire lease: subnet "10.244.0.0/16" specified in the flannel net config doesn't contain "10.200.0.0/24" PodCIDR of the "k8s-master01" node

#slave
kubeadm join 172.31.6.201:6443 --token g7kc4k.no5too5ok3t9s8py \
        --discovery-token-ca-cert-hash sha256:e1f39da2e0ccf01fdfc1b9eee024d884080c8afce149ef51b04f7e6af94ea5c9 --cri-socket unix:///var/run/cri-dockerd.sock
#如果是1.26.0版本的，node也需要自己下载pause镜像，其他镜像不需要
#docker pull registry.aliyuncs.com/google_containers/pause:3.6
#docker tag registry.aliyuncs.com/google_containers/pause:3.6 registry.k8s.io/pause:3.6
#kubeadm join kubeapi.magedu.com:6443 --token 4ir3o7.21ow0du250gl22gk         --discovery-token-ca-cert-hash sha256:92b6c7b6a94477c810ee70be7a8c191d8fc74f79303205b0621f7e30301a85a5 --cri-socket unix:///run/cri-dockerd.sock

#let node also can access k8s cluster
scp $HOME/.kube/config  root@k8s-node01:/root/.kube/
scp $HOME/.kube/config  root@k8s-node02:/root/.kube/
scp $HOME/.kube/config  root@k8s-node03:/root/.kube/


