#!/bin/bash

set -e

IMAGE_NAME=ros2_iron_img
CONTAINER_NAME=ros2_iron_container

if [[ -z $(docker images | grep $IMAGE_NAME) ]]; then
  docker build -t ros2_iron_img . 
else 
  echo "found docker image: ros2_iron_img"
fi

if [[ -z $(docker container ls -a | grep $CONTAINER_NAME) ]]; then
  docker run -it \
             --name $CONTAINER_NAME \
             --user=$(id -u $USER):$(id -g $USER) \
             --network=host \
             --gpus=all \
             --privileged \
             --env="QT_X11_NO_MITSHM=1" \
             --env="DISPLAY" \
             --volume=$(pwd):/home/ubuntu/ \
             --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
             --volume="/etc/group:/etc/group:ro" \
             --volume="/etc/passwd:/etc/passwd:ro" \
             --volume="/etc/shadow:/etc/shadow:ro" \
             --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
             --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
             $IMAGE_NAME:latest 
else 
  echo "found docker container: ros2_iron_container"
fi
