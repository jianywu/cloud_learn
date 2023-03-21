
# configure
refer to:
https://github.com/oracle/opengrok/wiki/How-to-setup-OpenGrok
mkdir -p ~/opengrok/{src,data,dist,etc,log}

# install
Refer to https://hub.docker.com/r/opengrok/docker/
docker pull opengrok/docker
docker-compose up -d

# add source
put under ~/opengrok/src/

# add project
Here eb19d40a7b0d is container ID for opengrok/docker.
bash is better than sh, can use tab to get full command.
docker exec -it eb19d40a7b0d bash
apt update -y
apt install -y vim
## add index for all projects under /opengork/src
java -Djava.util.logging.config.file=/opengrok/etc/logging.properties -jar /opengrok/lib/opengrok.jar -c /usr/local/bin/ctags -s /opengrok/src -d /opengrok/data -H -P -S -G -W /opengrok/etc/configuration.xml -U http://localhost:8080/
-c是ctags的路径
-s是源代码的路径
-d是opengork存数据的路径
-H是历史记录
-P是在src目录生成project
-S是到source repo的路径，是可选的
-G是assign tag
-W是写配置的路径
-U是web app的路径

# auto sync with repo
https://github.com/oracle/opengrok/wiki/Repository-synchronization 
docker exec -it eb19d40a7b0d bash
mkdir -p /scripts/
mkdir -p /ws-local/
# copy sync.conf there
vi /scripts/sync.conf
