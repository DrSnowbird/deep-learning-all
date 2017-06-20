#!/bin/bash -x

mkdir -p $HOME/data-docker/docker-deep-learning/notebook
mkdir -p $HOME/data-docker/docker-deep-learning/data

docker build -t openkbs/docker-deep-learning .
docker run -d \
	--name docker-deep-learning \
	-p 18888:8888 -p 16006:6006 \
	-e PASSWORD="password" \
	-v $HOME/data-docker/docker-deep-learning/data:/data \
	-v $HOME/data-docker/docker-deep-learning/notebook:/notebook \
	openkbs/docker-deep-learning

