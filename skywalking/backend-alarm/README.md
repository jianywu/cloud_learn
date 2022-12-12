# 相关文档
https://github.com/apache/skywalking/blob/master/docs/en/setup/backend/backend-alarm.md
现在因为有Prometheus的alarm，所以skywalking的alarm用的少了。

# 配置规则
更新告警指标，/apps/skywalking/config/oal/core.oal。
更新告警规则，加webhook到钉钉，/apps/skywalking/config/alarm-settings.yml。
然后重启skywalking，systemctl restart skywalking.service。

# 钉钉机器人
群设置-自定义(通过webhook接入自定义服务)-添加。
安全设置-自定义关键词，可以自定义，比如"SkyWalking"。
返回的webhook地址即可调用。
例如：
url: https://oapi.dingtalk.com/robot/send?access_token=2c6380c6d12b06a30c98a74229ba86689660956d3369fb2389aee46a59ca9337
只需要把url替换即可。
可以测试一下，-k --insecure可以curl https的链接，也可以不加，如果没法访问网址，其中的网址可以在chrome里检查，看到IP。
curl 'https://oapi.dingtalk.com/robot/send?access_token=2c6380c6d12b06a30c98a74229ba86689660956d3369fb2389aee46a59ca9337' \
-H 'Content-Type: application/json' \
-d '{"msgtype": "text",
    "text": {
         "content": "Apache Skywalking alarm: \n"
    }
  }'
