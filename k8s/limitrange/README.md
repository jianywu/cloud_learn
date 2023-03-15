k apply -f limitrange-magedu.yaml
# 未超过资源的限制
k apply -f nginx.yaml
# 超过资源的限制
k apply -f nginx_exceed_limit.yaml
