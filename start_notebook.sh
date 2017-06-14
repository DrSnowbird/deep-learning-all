#!/bin/bash -x

mkdir -p $HOME/data-docker/dl_docker_cpu/notebook
mkdir -p $HOME/data-docker/dl_docker_cpu/data

docker build -t floydhub/dl-docker:cpu -f Dockerfile.cpu .
docker run -d \
	--name dl_docker_cpu \
	-p 18888:8888 -p 16006:6006 \
	-e PASSWORD="password" \
	-v $HOME/data-docker/dl_docker_cpu/data:/data \
	-v $HOME/data-docker/dl_docker_cpu/notebook:/notebook \
	floydhub/dl-docker:cpu

