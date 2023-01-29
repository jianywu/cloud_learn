
# nfs-client sw install
sudo apt install nfs-common nfs-kernel-server -y
sudo systemctl start rpcbind nfs-mountd
sudo systemctl enable rpcbind nfs-mountd
sudo /lib/systemd/systemd-sysv-install enable rpcbind

# nfs-client configure
# if nfs server IP is 172.29.1.1
echo "172.29.1.1:/opt/data /mnt/data nfs rw,sync,hard,intr 0 0" >> /etc/fstab
sudo apt install autofs -y
echo "/-    /etc/auto.mount" >> /etc/auto.master
echo "/mnt/data -fstype=nfs,rw  10.164.178.238:/opt/data" >> /etc/auto.mount
