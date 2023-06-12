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
               --network=host \
               --gpus=all \
               --privileged \
               --env="QT_X11_NO_MITSHM=1" \
               --env="DISPLAY" \
               --volume=$(pwd):/home/ubuntu/ \
               --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
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
   if [[ -z $(docker container ls | grep $CONTAINER_NAME) ]]; then
      docker start $CONTAINER_NAME > /dev/null
   fi
   docker exec -it $CONTAINER_NAME /bin/bash
}

delete_container() {
   docker rm -f $CONTAINER_NAME
}


while getopts ":hsadm:" option; do
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
