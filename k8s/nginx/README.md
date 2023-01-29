# 生成创建nginx的yaml文件
kubectl create deployment nginx --image=nginx:alpine --replicas=2 --dry-run -o yaml

# 查看pod运行情况
k logs nginx-6c557cc74d-cwqsd
k describe nginx-6c557cc74d-cwqsd
