
# kubeadm
有节点网络，pod网络和service网络三种。

# 虚拟机
master和api server最好是不同的网卡，不过也可以同一个IP，只是非高可用了。
每个步骤都保存下镜像，未安装k8s，或安装好k8s后，都保存个镜像到云盘，这样以后可以使用。

# QA
Q: dial tcp: lookup kubeapi.magedu.com: no such host
A: Need add API server IP for kubeapi.magedu.com in /etc/hosts.

Q: message:docker: network plugin is not ready: cni config uninitialized"
A: Need install flannel or calico.
k apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
注意下载的flannel版本，需要和yml里的配置一致才行。

Q: The connection to the server localhost:8080 was refused - did you specify the right host or port?
A: Need configure KUBECONFIG in bash_profile.
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile
. ~/.bash_profile

Q: Node can't join
"Status from runtime service failed" err="rpc error: code = Unavailable desc = connection error: desc = \"transport: Error while dialing dial unix /run/cri-dockerd.sock: connect: connection refused\"
systemctl status cri-docker
systemctl status docker
查看/etc/docker/daemon.json的配置是否有异常。

Q: master一切正常，但node起不来。
k get po -A -o wide
NAMESPACE      NAME                                   READY   STATUS              RESTARTS   AGE   IP             NODE           NOMINATED NODE   READINESS GATES
kube-flannel   kube-flannel-ds-2q6mr                  0/1     Init:0/2            0          50s   172.31.7.112   k8s-node02     <none>           <none>
kube-flannel   kube-flannel-ds-6nj66                  0/1     Init:0/2            0          10m   172.31.7.111   k8s-node01     <none>           <none>
kube-flannel   kube-flannel-ds-kmsnw                  0/1     Init:0/2            0          10m   172.31.7.113   k8s-node03     <none>           <none>
kube-flannel   kube-flannel-ds-wj6rm                  1/1     Running             0          10m   172.31.7.101   k8s-master01   <none>           <none>
kube-system    coredns-5bbd96d687-4w6xd               1/1     Running             0          14m   10.244.0.2     k8s-master01   <none>           <none>
kube-system    coredns-5bbd96d687-8dxv7               1/1     Running             0          14m   10.244.0.3     k8s-master01   <none>           <none>
kube-system    etcd-k8s-master01                      1/1     Running             0          15m   172.31.7.101   k8s-master01   <none>           <none>
kube-system    kube-apiserver-k8s-master01            1/1     Running             0          15m   172.31.7.101   k8s-master01   <none>           <none>
kube-system    kube-controller-manager-k8s-master01   1/1     Running             0          15m   172.31.7.101   k8s-master01   <none>           <none>
kube-system    kube-proxy-7k7lp                       0/1     ContainerCreating   0          50s   172.31.7.112   k8s-node02     <none>           <none>
kube-system    kube-proxy-8vvk7                       0/1     ContainerCreating   0          13m   172.31.7.113   k8s-node03     <none>           <none>
kube-system    kube-proxy-cqcwp                       0/1     ContainerCreating   0          14m   172.31.7.111   k8s-node01     <none>           <none>
kube-system    kube-proxy-g985j                       1/1     Running             0          14m   172.31.7.101   k8s-master01   <none>           <none>
kube-system    kube-scheduler-k8s-master01            1/1     Running             0          15m   172.31.7.101   k8s-master01   <none>           <none>
# ks describe po kube-proxy-cqcwp | tail
Events:
  Type     Reason                  Age                  From               Message
  ----     ------                  ----                 ----               -------
  Normal   Scheduled               14m                  default-scheduler  Successfully assigned kube-system/kube-proxy-cqcwp to k8s-node01
  Warning  FailedCreatePodSandBox  11m (x5 over 14m)    kubelet            Failed to create pod sandbox: rpc error: code = Unknown desc = failed pulling image "registry.k8s.io/pause:3.6": Error response from daemon: Head "https://asia-east1-docker.pkg.dev/v2/k8s-artifacts-prod/images/pause/manifests/3.6": dial tcp 142.251.8.82:443: i/o timeout
  Warning  FailedCreatePodSandBox  5m31s (x8 over 10m)  kubelet            Failed to create pod sandbox: rpc error: code = Unknown desc = failed pulling image "registry.k8s.io/pause:3.6": Error response from daemon: Head "https://asia-east1-docker.pkg.dev/v2/k8s-artifacts-prod/images/pause/manifests/3.6": dial tcp 64.233.187.82:443: i/o timeout
  Warning  FailedCreatePodSandBox  72s (x6 over 4m47s)  kubelet            Failed to create pod sandbox: rpc error: code = Unknown desc = failed pulling image "registry.k8s.io/pause:3.6": Error response from daemon: Head "https://asia-east1-docker.pkg.dev/v2/k8s-artifacts-prod/images/pause/manifests/3.6": dial tcp 108.177.125.82:443: i/o timeout
  Warning  FailedCreatePodSandBox  27s                  kubelet            Failed to create pod sandbox: rpc error: code = Unknown desc = failed pulling image "registry.k8s.io/pause:3.6": Error response from daemon: Head "https://asia-east1-docker.pkg.dev/v2/k8s-artifacts-prod/images/pause/manifests/3.6": dial tcp 74.125.23.82:443: i/o timeout
A: 说明docker pull的网络不通，需要在/etc/docker/daemon.json加上registry的代理才行。
    "registry-mirrors": [
        "https://docker.mirrors.ustc.edu.cn",
        "https://hub-mirror.c.163.com",
        "https://reg-mirror.qiniu.com",
        "https://registry.docker-cn.com"
    ]
修改后，重启docker。
systemctl daemon-reload && systemctl restart docker


