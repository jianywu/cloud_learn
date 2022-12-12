# docker image performance is not good as binary install
Notice: For production, binary install is better than docker-compose, there are two reasons:
1. Run in docker is slower, lose about 10% performance.
2. Put all services together is not flexible deployment.
But of course, we can use multiple machines or containers to improve this, cloud is for horizontal expansion, more flexible than bare-metal machine.

# docker images
Download from https://skywalking.apache.org/downloads/
Run skywalking_docker-compose-install.sh directly to bring up skywalking and elasticsearch dockers.