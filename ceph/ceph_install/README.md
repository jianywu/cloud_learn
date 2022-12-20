# 安装步骤
## 配置环境
common_install.sh配置所有环境的ceph安装包。
用了3台主机，主机名分别为ceph-mon1，ceph-mon2，ceph-mon3。
## 安装monitor node
以su - cephadmin的方式安装，如果出错了，比如socket找不到，就需要修改host为ceph-mon1/2/3，rm -rf ~/ceph-cluster/*，然后kill ceph，重新安装。
部署3个节点。
2_monitor_node.sh 10.11.154.8 1
2_monitor_node.sh 192.168.1.8 2
2_monitor_node.sh 10.0.4.5 3
ceph -s看到active就好了。
mon: 1 daemons, quorum ceph-mon2
## 安装manager node
也需要su - cephadmin
部署2个节点。
3_manager_node.sh 1
3_manager_node.sh 2
ceph -s看到active就好了。
ceph-mgr2(active)
## 安装storage node
也需要su - cephadmin
部署3个节点。
