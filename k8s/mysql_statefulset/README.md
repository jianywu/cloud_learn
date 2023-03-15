Q: Unable to attach or mount volumes: unmounted volumes=[data], unattached volumes=[conf config-map kube-api-access-mssnj data]: timed out waiting for the condition
A: In node, call: #apt install nfs-utils -y  

Q: pv一直terminating状态，但是不退出
A: k patch pv mysql-datadir-5 -p '{"metadata":{"finalizers":null}}'
然后就发现这个pv已经被删除了。

Q: Readiness probe failed: ERROR 2003 (HY000): Can't connect to MySQL server on '127.0.0.1' (111)
A: 指定远程IP的时候，必须要指定一下端口号, 一般是3306。 

Q: Invalid value: 33000: provided port is not in the valid range. The range of valid ports is 30000-32767
A: 修改/etc/kubernetes/manifests/kube-apiserver.yaml，和containers同一级，加上：
  apiServerExtraArgs:
    service-node-port-range: 30000-32767
