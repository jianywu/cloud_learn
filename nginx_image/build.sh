#!/bin/bash
TAG=$1

docker build -t domain/repo/myserver-web1:${TAG} .

docker push domain/repo/myserver-web1:${TAG}

