# 参考链接
https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/

# 测试命令
curl -LO https://k8s.io/examples/application/wordpress/mysql-deployment.yaml
curl -LO https://k8s.io/examples/application/wordpress/wordpress-deployment.yaml
cat <<EOF >>./kustomization.yaml
secretGenerator:
- name: mysql-pass
  literals:
  - password="123456"
resources:
  - mysql-deployment.yaml
  - wordpress-deployment.yaml
EOF
kubectl apply -k ./

# 验证是否启动
kubectl get secrets
kubectl get pvc
kubectl get pv
kubectl get pods
kubectl get services wordpress

# 删除集群
kubectl delete -k ./
