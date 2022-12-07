# setup
1. Create user/group and directories for elastic search.
./setup.sh
2. increase configuration for max_map_count.
vim /etc/sysctl.conf
vm.max_map_count = 262144
sysctl -p
3. Update /etc/hosts, add elastic search IP addrs.
