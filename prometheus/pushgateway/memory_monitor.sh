#!/bin/bash

total_memory=$(free |awk '/Mem/{print $2}')
used_memory=$(free |awk '/Mem/{print $3}')
job_name="custom_memory_monitor"
# get ip addr as instance name
instance_name=`ip addr show eth0 | grep -w inet | awk '{print $2}' | awk -F/ '{print $1}'`
pushgateway_server="http://124.223.157.166:9091/metrics/job"
cat <<EOF | curl --data-binary @- ${pushgateway_server}/${job_name}/instance/${instance_name}
#TYPE custom_memory_total gauge
custom_memory_total $total_memory
#TYPE custom_memory_used gauge
custom_memory_used $used_memory
EOF