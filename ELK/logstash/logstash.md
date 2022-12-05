# logstash的帮助文档
/usr/share/logstash/bin/logstash -help
/usr/share/logstash/bin/logstash-plugin --help
# 可以看到目前支持哪些plugin
/usr/share/logstash/bin/logstash-plugin list

# 配置文件
在这个目录下/etc/logstash/
jvm.options可以配置为1g, 或CPU mem的一半, 防止浪费太多内存。

配置文件是写在/etc/logstash/conf.d/ 下，以.conf结尾。
可以在~/.bash_aliases加上alias，方便后续执行。
alias logstash='/usr/share/logstash/bin/logstash'
