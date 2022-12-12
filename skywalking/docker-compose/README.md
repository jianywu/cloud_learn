# docker image performance is not good as binary install
Notice: For production, binary install is better than docker-compose, there are two reasons:
1. Run in docker is slower, lose about 10% performance.
2. Put all services together is not flexible deployment.
But of course, we can use multiple machines or containers to improve this, cloud is for horizontal expansion, more flexible than bare-metal machine.

# docker images
Download from https://skywalking.apache.org/downloads/
Run skywalking_docker-compose-install.sh directly to bring up skywalking and elasticsearch dockers.

# good website
Validate yaml:
https://verytoolz.com/yaml-formatter.html

Share code:
https://gist.github.com/

# QA
1. ScannerException: while scanning a simple key.
A: yml need to be formatted, otherwise, will have key error
2. Q: class java.util.LinkedHashMap cannot be cast to class java.lang.String (java.util.LinkedHashMap and java.lang.String are in module java.base of loader 'bootstrap')
A: message: "dubbo-provider service_cpm > 1", need add "", otherwise, will consider as key/value map.
