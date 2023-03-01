# create virtualbox network
4张网卡顺序分别为：
1. 桥接网络
2. NAT
3. Host-Only
4. Host-Only

# 修改netplan的网络配置
master需要配置的ip比较多，比如API server，比如udnerlay网络用的地址，比如master自己的地址，还有连到外网的地址。
node的IP相对少一些，只需要连到外网的地址，还有node自己的地址就可以了。
