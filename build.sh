#!/bin/bash

APP_NAME=react-devops-app
IMAGE_NAME=react-devops-image
TAG=latest

echo "Building Docker image..."

docker build -t $IMAGE_NAME:$TAG .

if [ $? -ne 0 ]; then
  echo "Build failed"
  exit 1
fi

echo " Docker image built successfully"