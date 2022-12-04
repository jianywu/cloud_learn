config files are under: /etc/logstash/
jvm.options can set to 1g, or half of CPU mem, to avoid using to much mem.

配置文件是写在/etc/logstash/conf.d/ 下，以.conf结尾
加上alias，方便后续执行。
alias logstash='/usr/share/logstash/bin/logstash'
