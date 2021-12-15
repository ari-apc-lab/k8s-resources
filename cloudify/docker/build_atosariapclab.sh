#!/bin/bash

export IMAGE_NAME=croupier-permedcoe
export TAG_NAME=latest

# Build the docker image
docker build --rm=true -t $IMAGE_NAME:$TAG_NAME .

docker image tag croupier-permedcoe:latest atosariapclab/croupier-permedcoe:latest
docker login
docker push atosariapclab/croupier-permedcoe:latest
