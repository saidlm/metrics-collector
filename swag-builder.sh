#!/bin/bash

# Enable docker buildkit
export DOCKER_BUILDKIT=1

# Tag generator
TAG=`date +%Y.%m.%d`

# Discover architecture
echo -n "Deiscovering architecture ... "
if [[ $(uname -a | grep -i arm) ]]; then
	echo "arm."
	DOCKERFILE="Dockerfile.armhf"
else
	echo "x86."
	DOCKERFILE="Dockerfile"
fi

echo "Clonning repositories from git and building images."

echo "Processing alpine baseimage."
(git -C ./docker-baseimage-alpine pull || git clone https://github.com/linuxserver/docker-baseimage-alpine.git ./docker-baseimage-alpine) && \
	docker build ./docker-baseimage-alpine -f ./docker-baseimage-alpine/$DOCKERFILE -t mc-baseimage-alpine:latest -t mc-baseimage-alpine:$TAG --no-cache

echo "Processing NGINX base image."
(git -C ./docker-baseimage-alpine-nginx pull || git clone https://github.com/linuxserver/docker-baseimage-alpine-nginx.git ./docker-baseimage-alpine-nginx) && \
	cat ./docker-baseimage-alpine-nginx/$DOCKERFILE | sed -e "s/^FROM.*/FROM mc-baseimage-alpine:latest/" > ./docker-baseimage-alpine-nginx/$DOCKERFILE.edited && \
	docker build ./docker-baseimage-alpine-nginx -f ./docker-baseimage-alpine-nginx/$DOCKERFILE.edited -t mc-baseimage-alpine-nginx:latest -t mc-baseimage-alpine-nginx:$TAG --no-cache

echo "Processing SWANG."
(git -C ./docker-swag/ pull || git clone https://github.com/linuxserver/docker-swag.git ./docker-swag) && \
	cat ./docker-swag/$DOCKERFILE | sed -e "s/^FROM.*/FROM mc-baseimage-alpine-nginx:latest/" > ./docker-swag/$DOCKERFILE.edited && \
	docker build ./docker-swag -f ./docker-swag/$DOCKERFILE.edited -t mc-swag:latest -t mc-swag:$TAG --no-cache

echo "Done."

#EOF
