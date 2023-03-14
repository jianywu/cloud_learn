kubectl create namespace magedu
k apply -f centos7-magedu.yaml
k get po -n magedu
k create deploy nginx2-magedu --image=nginx --namespace=default
#k create deploy centos7-magedu --image=centos7 --namespace=magedu
k apply -f centos7-default.yaml
# test ping from centos to nginx, get nginx ip via k describe po nginx*
k apply -f egress-magedu.yaml
kubectl get networkpolicy -n magedu
