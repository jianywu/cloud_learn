git clone -b release-0.11 https://github.com/prometheus-operator/kube-prometheus.git

kubectl apply --server-side -f manifests/setup
kubectl wait \
        --for condition=Established \
        --all CustomResourceDefinition \
        --namespace=monitoring
kubectl apply -f manifests/
mkdir networkPolicy
mv manifests/*networkPolicy* networkPolicy/
kubectl delete -f networkPolicy/
k apply -f .
