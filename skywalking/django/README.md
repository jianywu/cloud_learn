# 相关文档
https://github.com/apache/skywalking-python
https://skywalking.apache.org/docs/skywalking-python/v0.8.0/en/setup/installation/

# 安装skywalking的python agent并启动
直接pip3 install即可，然后运行，启动agent
```bash
# 有时候会下载失败，需加上代理-i 地址即可。
pip3 install apache-skywalking -i https://mirrors.ustc.edu.cn/pypi/web/simple/
python3 skywalking_agent_test.py
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
