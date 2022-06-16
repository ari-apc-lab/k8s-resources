#!/bin/bash

export IMAGE_NAME=cloudify-permedcoe
export TAG_NAME=6.2.0

# Build the docker image
docker build --rm=true -t $IMAGE_NAME:$TAG_NAME .

docker image tag $IMAGE_NAME:$TAG_NAME atosariapclab/$IMAGE_NAME:$TAG_NAME
docker login
docker push atosariapclab/$IMAGE_NAME:$TAG_NAME
