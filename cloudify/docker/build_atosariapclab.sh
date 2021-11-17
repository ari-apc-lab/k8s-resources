#!/bin/bash

export IMAGE_NAME=croupier-grapevine
export TAG_NAME=latest

# Build the docker image
docker build --rm=true -t $IMAGE_NAME:$TAG_NAME .

docker image tag croupier-grapevine:latest atosariapclab/croupier-grapevine:latest
docker login
docker push atosariapclab/croupier-grapevine:latest
