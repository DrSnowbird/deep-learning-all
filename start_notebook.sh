#!/bin/bash -x

docker build -t floydhub/dl-docker:cpu -f Dockerfile.cpu .
docker run -d -p 18888:8888 -p 16006:6006 -v /home/user1/data-docker/dl_docker_cpu/data:/root/sharedfolder floydhub/dl-docker:cpu

