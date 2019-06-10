#!/bin/bash

# Installing Docker

apt update

apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

CHECK_DOCKER_INSTALLATION=$(dpkg -l | grep -c docker-ce)

if ! [ $CHECK_DOCKER_INSTALLATION -ne 0 ]
then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo apt-key fingerprint 0EBFCD88

    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

    sudo apt-get update

    sudo apt-get install -y docker-ce
fi

#Opening tcp port for api docker

PROPERTY_PATTERN="ExecStart"
PROPERTY_VALUE="/usr/bin/dockerd -H fd:// -H=tcp://0.0.0.0:5555 --containerd=/run/containerd/containerd.sock"

DOCKER_CONF_FILE="/lib/systemd/system/docker.service"

sed -i "s@.*${PROPERTY_PATTERN}=.*@${PROPERTY_PATTERN}=${PROPERTY_VALUE}@" $DOCKER_CONF_FILE

#Restarting docker service

systemctl daemon-reload
service docker restart

docker pull wesleymonte/simple-worker
docker pull ubuntu:latest