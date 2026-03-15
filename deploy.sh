#!/bin/bash

CONTAINER_NAME=devops-static-container
IMAGE_NAME=react-devops-image
TAG=latest

echo "Removing old container if it exists..."

docker stop $CONTAINER_NAME 2>/dev/null
docker rm $CONTAINER_NAME 2>/dev/null

echo " Starting new container on port 80..."

docker run -d \
  --name $CONTAINER_NAME \
  -p 80:80 \
  --restart always \
  $IMAGE_NAME:$TAG

if [ $? -ne 0 ]; then
  echo "Deployment failed"
  exit 1
fi

echo "Application deployed successfully on port 80"