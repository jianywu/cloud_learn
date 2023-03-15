#!/bin/bash
docker pull mysql:5.7.36
docker tag mysql:5.7.36 harbor.magedu.net/magedu/mysql:5.7.36
docker push harbor.magedu.net/magedu/mysql:5.7.36

docker pull zhangshijie/xtrabackup:1.0
## note: don't forget magedu after harbr.magedu.net, otherwise, push will fail
docker tag zhangshijie/xtrabackup:1.0 harbor.magedu.net/magedu/xtrabackup:1.0
docker push harbor.magedu.net/magedu/xtrabackup:1.0
