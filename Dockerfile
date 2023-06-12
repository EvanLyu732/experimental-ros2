FROM ros:iron-ros-core

USER root
RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list; \
    apt-get update -y; \
    apt-get install -y vim git curl wget; 

ENTRYPOINT ["/bin/bash"]
