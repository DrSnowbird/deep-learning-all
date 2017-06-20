#!/bin/bash -x

if [ $# -lt 1 ]; then
    echo "Usage: "
    echo "  ${0} [<Jupyter_Password>] [<repo-name/repo-tag>] "
    echo "e.g."
    echo "  ${0} password123 openkbs/docker-deep-learning"
fi
Password="${JupyterPassword:-password123}"

## -- mostly, don't change this --
baseDataFolder=~/data-docker
MY_IP=`ip route get 1|awk '{print$NF;exit;}'`

function displayPortainerURL() {
    port=${1}
    echo "... Go to: http://${MY_IP}:${port}"
    #firefox http://${MY_IP}:${port} &
    if [ "`which google-chrome`" != "" ]; then 
        /usr/bin/google-chrome http://${MY_IP}:${port} &
    else
        firefox http://${MY_IP}:${port} &
    fi
}

##################################################
#### ---- Mandatory: Change those ----
##################################################
imageTag=${2:-"openkbs/docker-deep-learning"}

PACKAGE=`echo ${imageTag##*/}|tr "/\-: " "_"`
#version=cpu

docker_volume_data1=/data
docker_volume_data2=/notebook
local_docker_data1=${baseDataFolder}/${PACKAGE}/data
local_docker_data2=${baseDataFolder}/${PACKAGE}/notebook

#### ---- local data folders on the host ----
mkdir -p ${local_docker_data1}
mkdir -p ${local_docker_data2}

#### ---- ports mapping ----
docker_port1=6006
docker_port2=8888

local_docker_port1=16006
local_docker_port2=18888

##################################################
#### ---- Mostly, you don't need change below ----
##################################################
# Reference: https://docs.docker.com/engine/userguide/containers/dockerimages/

#instanceName=my-${2:-${imageTag%/*}}_$RANDOM
#instanceName=my-${2:-${imageTag##*/}}
instanceName=`echo ${imageTag}|tr "/\-: " "_"`

#### ----- RUN -------
echo "To run: for example"
echo "docker run -d --name ${instanceName} -v ${docker_data}:/${docker_volume_data} ${imageTag}"
echo "---------------------------------------------"
echo "---- Starting a Container for ${imageTag}"
echo "---------------------------------------------"
#docker run --rm -P -d --name $instanceName $imageTag
#docker run -it -p 8888:8888 -p 6006:6006 -v /sharedfolder:/root/sharedfolder floydhub/dl-docker:cpu bash
docker run --rm \
    -d \
    --name=${instanceName} \
	-e PASSWORD="${Password}" \
    -p ${local_docker_port1}:${docker_port1} \
    -p ${local_docker_port2}:${docker_port2} \
    -v ${local_docker_data1}:${docker_volume_data1} \
    -v ${local_docker_data2}:${docker_volume_data2} \
    ${imageTag}
    
echo ">>> Docker Status"
docker ps -a | grep "${instanceName}"
echo "-----------------------------------------------"
echo ">>> Docker Shell into Container `docker ps -lqa`"
echo "docker exec -it ${instanceName} /bin/bash"

#### ---- Display IP:Port URL ----
displayPortainerURL ${local_docker_port1}
displayPortainerURL ${local_docker_port1}
