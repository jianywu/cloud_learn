# setup
download from official link:
https://www.elastic.co/cn/downloads/elasticsearch
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.5.1-linux-x86_64.tar.gz

1. Install directly via onekey-install.sh
./onekey-install.sh
2. Update config/elasticsearch.yml, config/jvm.options to reduce mem usage, restart elasticsearch.service.
3. Update /etc/hosts, add elastic search IP addrs.
4. After install, configure_keystore.sh for keystore.
5. If needed, configure_ca.sh for ca public and private keys.

FAQ:
1. Aborting auto configuration because of config dir ownership mismatch. Config dir is owned by elasticsearch but auto-configuration directory would be owned by root.
Because keystore file is root:
-rw-rw---- 1 root          root            337 Dec  7 12:44 elasticsearch.keystore
A: Change owner, chown elasticsearch.elasticsearch /apps/elasticsearch/config/elasticsearch.yml
2. cluster can't up, because port 9300 bind with 127.0.0.1, which is host loopback address. Host loopback refers to the fact that no data packet addressed to 127.0.0.1 should ever leave the computer (host), sending it — instead of being sent to the local network or the internet, it simply gets "looped back" on itself, and the computer sending the packet becomes the recipient.
LISTEN 0       1024                                  127.0.0.1:9300              *:*     users:(("java",pid=1537086,fd=409))
Need to be:
LISTEN 0       1024                                  *:9300              *:*     users:(("java",pid=1537086,fd=409))
A: Check elasticsearch.yml, change network.host: 0.0.0.0
3. systemctl status elasticsearch show failure
Check dmesg for kernel logs, can see it is caused by OOM, killed by kernel, because used too much memory.
[1834374.983097] Out of memory: Killed process 3128418 (java) total-vm:9584212kB, anon-rss:5917180kB, file-rss:2052kB, shmem-rss:0kB, UID:0 pgtables:11812kB oom_score_adj:0
[1834375.367995] oom_reaper: reaped process 3128418 (java), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
A: update /apps/elasticsearch/config/jvm.options, change to -Xms2g or smaller.
4. How to confirm elasticsearch is really up.
ss -tnlp | grep -E "9200|9300"
port 9200 for outside access, 9300 for cluster communication.
curl 124.223.157.166:9200
Expect to see: "You Know, for Search"
Install in host is not so good, better use docker-compose to run it in container.