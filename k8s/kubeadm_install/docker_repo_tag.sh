#!/bin/bash

kubeadm config images pull --image-repository registry.aliyuncs.com/google_containers --cri-socket unix:///var/run/cri-dockerd.sock

#从国内aliyun镜像拉取
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.26.0
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.26.0
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.26.0
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.26.0
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.6
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.5.1-0
#docker pull coredns/coredns:1.8.6

# images重命名为kubeadm config所需的镜像名
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.26.0 registry.k8s.io/kube-apiserver:v1.26.0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.26.0 registry.k8s.io/kube-controller-manager:v1.26.0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.26.0 registry.k8s.io/kube-scheduler:v1.26.0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.26.0 registry.k8s.io/kube-proxy:v1.26.0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.6 registry.k8s.io/pause:3.6
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.5.1-0 registry.k8s.io/etcd:3.5.1-0
docker tag coredns/coredns:1.8.6 registry.k8s.io/coredns/coredns:v1.8.6
