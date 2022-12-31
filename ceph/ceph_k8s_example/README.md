ceph osd pool create dave-rbd-pool1 32 32
ceph osd pool application enable dave-rbd-pool1 rbd
rbd pool init -p dave-rbd-pool1

