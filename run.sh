#!/bin/bash

set -e

IMAGE_NAME=ros2_iron_img
CONTAINER_NAME=ros2_iron_container

start_container() {
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
}

 
help() {
     # Display Help
   echo "enter ros2 iron docker container"
   echo
   echo "Syntax: ./run.sh [-s|d|a|h]"
   echo "options:"
   echo "s     Start the docker container."
   echo "h     Print this Help."
   echo "d     Delete container."
   echo "a     Attach to the running container."
   echo
}

attach_container() {
   docker exec -it $CONTAINER_NAME /bin/bash
}

delete_container() {
   docker rm -f $CONTAINER_NAME
}


while getopts ":hsa:" option; do
   case $option in
      h) 
         help
         exit;;
      s) 
         start_container
         exit;;
      a) 
         attach_container
         exit;;
      d) 
         delete_container
         exit;;
   esac
done

# No option
help
