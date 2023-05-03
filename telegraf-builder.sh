#!/bin/bash

# Enable docker buildkit
export DOCKER_BUILDKIT=1

# Tag generator
TAG=`date +%Y.%m.%d`

# Discover architecture
echo -n "Discovering architecture ... "
if [[ $(uname -a | grep -i arm) ]]; then
        echo "arm."
        DOCKERFILE="Dockerfile.armhf"
else
        echo "x86."
        DOCKERFILE="Dockerfile"
fi

echo "Building telegraf image."
docker build ./telegraf -f ./telegraf/$DOCKERFILE -t mc-telegraf:latest -t mc-telegraf:$TAG
