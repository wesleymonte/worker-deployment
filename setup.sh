#!/bin/bash

install-docker() {
    echo "--> Installing docker"
    sudo apt update

    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo apt-key fingerprint 0EBFCD88

    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

    sudo apt-get update

    sudo apt-get install -y docker-ce
}

open-tcp-port() {
    echo "--> Setting up the TCP port"

    local PROPERTY_PATTERN="ExecStart"
    local PROPERTY_VALUE="/usr/bin/dockerd -H fd:// -H=tcp://0.0.0.0:5555 --containerd=/run/containerd/containerd.sock"

    local DOCKER_CONF_FILE="/lib/systemd/system/docker.service"

    sed -i "s@.*${PROPERTY_PATTERN}=.*@${PROPERTY_PATTERN}=${PROPERTY_VALUE}@" $DOCKER_CONF_FILE
}

pull-default-images() {    

    echo "--> Pulling default docker images"

    docker pull wesleymonte/simple-worker
    docker pull ubuntu:latest
}

main() {
    CHECK_DOCKER_INSTALLATION=$(dpkg -l | grep -c docker-ce)

    if ! [ $CHECK_DOCKER_INSTALLATION -ne 0 ]; then
        install-docker
    else 
        echo "--> Docker its already installed"
    fi

    open-tcp-port

    systemctl daemon-reload
    service docker restart

    pull-default-images
}

main
