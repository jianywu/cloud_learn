#!/bin/bash
docker build -t harbor.magedu.net/myserver/nginx:v2 .
docker push harbor.magedu.net/myserver/nginx:v2

#/usr/local/bin/nerdctl build -t harbor.magedu.net/magedu/nginx-base:1.22.0 .
#/usr/local/bin/nerdctl push harbor.magedu.net/magedu/nginx-base:1.22.0
