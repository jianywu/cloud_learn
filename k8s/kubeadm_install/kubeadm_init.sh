#!/bin/bash

# --image-repository指定本地镜像
kubeadm init --control-plane-endpoint="kubeapi.magedu.com" --kubernetes-version=v1.26.0 --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 --token-ttl=0 --cri-socket unix:///run/cri-dockerd.sock --upload-certs  --image-repository=registry.aliyuncs.com/google_containers

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 可以加到/etc/profile，这样确保每次启动都会有这个配置
export KUBECONFIG=$HOME/.kube/config
