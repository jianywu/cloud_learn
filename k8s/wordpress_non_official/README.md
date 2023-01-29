# 参考资料
https://vietkubers.github.io/2019-06-17-deploying-stateful-wordpress.html#41-installing-loadbalancer

# 配置nfs服务
# 提供存储的执行nfs-server.sh
# 使用存储的执行nfs-client.sh

# 为mysql和wordpress搭建pv和pvc
kubectl apply -f mysql-pv0.yaml
kubectl apply -f mysql-pv1.yaml
kubectl apply -f mysql-pv2.yaml

kubectl apply -f wordpress-pv0.yaml
kubectl apply -f wordpress-pv1.yaml
kubectl apply -f wordpress-pv2.yaml

# 搭建mysql
kubectl apply -f secret.yml
kubectl apply -f mysql-deploy.yaml

# 搭建load balancer
sudo kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml
k apply -f configmap.yaml
kubectl get pods -n metallb-system


# 总的测试命令，可以忽略之前的命令，直接运行这个命令
curl -LO https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml
# Need apply for secret firstly, otherwise, it will report as:
# error: merging from generator &{0xc003044380 <nil>}: id resid.ResId{Gvk:resid.Gvk{Group:"", Version:"v1", Kind:"Secret",isClusterScoped:false}, Name:"mysql-pass", Namespace:""} exists; behavior must be merge or replace
kubectl apply -f secret.yaml

cat <<EOF >>./kustomization.yaml
secretGenerator:
- name: mysql-pass
  literals:
  - password="123456"
resources:
  - mysql-pv0.yaml
  - mysql-pv1.yaml
  - mysql-pv2.yaml
  - wordpress-pv0.yaml
  - wordpress-pv1.yaml
  - wordpress-pv2.yaml
  - metallb.yaml
  - mysql-deploy.yaml
  - wordpress-deploy.yaml
EOF

kubectl apply -k ./

# 删除集群
kubectl delete -k ./

# QA
# no matches for kind "DaemonSet" in version "apps/v1beta2"
因为DaemonSet、Deployment、StatefulSet 和 ReplicaSet 在 v1.16 中将不再从 extensions/v1beta1、apps/v1beta1 或 apps/v1beta2 提供服务。
解决方法是把v1beta2改为apps/v1。
# LoadBalancer的EXTERNAL-IP一直显示pending
因为kubeadm和minikube不支持external IP，只有cloud的k8s才支持。
