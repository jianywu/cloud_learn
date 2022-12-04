# install redis
apt update
apt install redis
# update /etc/redis/redis.conf
# restart redis
systemctl restart redis
ss -tlnp

# in local ENV
redis-cli
auth <password>
keys *
l pop magedu-nginx-accesslog

# from other machine
telnet $remote_ip 6379
auth <Password>
info
keys *
