# 相关文档
https://github.com/apache/skywalking-python
https://skywalking.apache.org/docs/skywalking-python/v0.8.0/en/setup/installation/

# 安装skywalking的python agent并启动
直接pip3 install即可，然后运行，启动agent
```bash
# 有时候会下载失败，需加上代理-i 地址即可。
pip3 install apache-skywalking -i https://mirrors.ustc.edu.cn/pypi/web/simple/
python3 skywalking_test.py
```

# 安装django
步骤为：
```bash
tar xvf django-test.tgz -C /apps
cd /apps/django-test
pip3 install -r requirements.txt -i https://mirrors.ustc.edu.cn/pypi/web/simple/
django-admin startproject mysite1
cd mysite1
python3 manage.py startapp myapp
python3 manage.py makemigrations
python3 manage.py migrate
# 注意密码不要为纯数字，否则有提示
python3 manage.py createsuperuser
```

# 配置skywalking环境变量
```bash
export SW_AGENT_NAME='python-app1'
export SW_AGENT_NAMESPACE='python-project'
export SW_AGENT_COLLECTOR_BACKEND_SERVICES='Skywalking_IP:11800'
```
修改配置
```bash
# 允许所有主机访问，ALLOWED_HOSTS = ["*",]注意有引号，另外有逗号，表示列表
vim mysite/settings.py
```
启动：
```bash
# 安装依赖,psycopg2貌似找不到
pip3 install aiohttp celery elasticsearch falcon flask kafka pymongo pyramid rabbitmq redis sanic tornado -i https://mirrors.ustc.edu.cn/pypi/web/simple/
# 注意这里地址不可以是公网的，而需要是0.0.0.0，否则会报错：Error: That IP address can't be assigned to.因为公网地址是NAT的，无法像网卡地址一样被绑定
# 80端口被占用了，所以换成81端口
sw-python -d run python3 manage.py runserver 0.0.0.0:81
```

# 登录django
http://42.51.17.66:81/admin
注意链接里有admin，否则没有登录界面。
可以新建用户等。
后续可以看到，python-app这个skywalking的界面增加了访问。
