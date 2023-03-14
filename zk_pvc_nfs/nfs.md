# server:
mkdir -p /data/k8sdata/magedu/zookeeper-datadir-{1,2,3}
## Add in /etc/exports
/data/k8sdata 172.29.0.0/16(rw,sync,no_subtree_check,no_root_squash)
exportfs -r
showmount -e 172.29.7.9

# client:
cd k8s-data/yaml/magedu/zookeeper/pv
k apply -f .
k get pv,pvc -n magedu
k get deploy,po,svc -n magedu -o wide

