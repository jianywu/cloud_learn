
# nfs server install
sudo apt install nfs-kernel-server -y
sudo mkdir -p /opt/data
sudo chmod -R 777 /opt/data
sudo chown -R nobody:nogroup /opt/data

# nfs server configure
echo "/opt/data *(rw,sync,no_root_squash,fsid=0,no_subtree_check)" >> /etc/exports
sudo exportfs -a
sudo systemctl enable rpcbind
sudo /lib/systemd/systemd-sysv-install enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl start rpcbind
sudo systemctl start nfs-server

sudo mkdir -p /opt/data/vol/{0,1,2}
mkdir -p /opt/data/content/{0,1,2}
