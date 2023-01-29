# 创建demoapp这个pod
kubectl create deployment demoapp --image=ikubernetes/demoapp:v1.0 --replicas=3
# 创建service
kubectl create service nodeport demoapp --tcp=80:80
# 到容器内执行命令
kubectl run client-$RANDOM --image=ikubernetes/admin-box:v1.2 --rm --restart=Never -it --command -- /bin/bash
while true; do curl demoapp.default.svc; sleep 1; done

# 生成yaml文件
# kubectl create deployment demoapp --image=ikubernetes/demoapp:v1.0 --replicas=3 --dry-run=client -o yaml

# use 6 replicas
k scale deploy demoapp --replicas=6
