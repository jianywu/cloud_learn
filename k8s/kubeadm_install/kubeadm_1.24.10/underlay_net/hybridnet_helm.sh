#下载
wget https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz
tar xvf helm-v3.9.0-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/

#安装hybridmet
helm repo add hybridnet https://alibaba.github.io/hybridnet/
helm repo update
helm install hybridnet hybridnet/hybridnet -n kube-system --set init.cidr=10.200.0.0/16

#给node加label
#如果不加label，没法调度过去，加label之后，node的role就成为master了。
kubectl label node k8s-node1.example.com node-role.kubernetes.io/master=
kubectl label node k8s-node2.example.com node-role.kubernetes.io/master=
kubectl label node k8s-node3.example.com node-role.kubernetes.io/master=
