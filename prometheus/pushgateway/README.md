# install
use onekey-install.sh or install by docker, perfer docker install.
docker run -d --name pushgateway -p 9091:9091 prom/pushgateway:v1.5.1
confirm install OK via open in ip:9091, i.e. http://124.223.157.166:9091/
Note: after install one push gateway, other machine can also push data to this gateway by curl.

# push data
http://<ip>:9091/metrics/job/<JOBNAME>{/<LABEL_NAME>/<LABEL_VALUE>}
test push:
echo "mytest_metric 2088" | curl --data-binary @- http://124.223.157.166:9091/metrics/job/mytest_job
or
cat <<EOF | curl --data-binary @- http://124.223.157.166:9091/metrics/job/test_job/instance/125.124.238.46
#TYPE node_memory_usage gauge
node_memory_usage 4311744512
# TYPE memory_total gauge
node_memory_total 103481868288
EOF

# add to prometheus yml
curl prometheus ip:9090/-/reload to reload the config.
curl -X POST http://124.223.157.166:9090/-/reload
