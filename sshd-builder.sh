#!/bin/bash

# Configuration variables
# sshd username
USER="collector"
# Password authorisation yes/no
PASSWDAUTH="yes"
# Password or public key have to be provided as a env_var PASS or PUBKEY on starting phase.

# Enable docker buildkit
export DOCKER_BUILDKIT=1

# Tag generator
TAG=`date +%Y.%m.%d`

echo "Building sshd image."
docker build ./sshd --build-arg USER=$USER --build-arg PASSWDAUTH=$PASSWDAUTH  -f ./sshd/Dockerfile -t mc-sshd:latest -t mc-sshd:$TAG
