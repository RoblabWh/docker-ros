#!/bin/bash

xhost + local:
QT_GRAPHICSSYSTEM="native" docker run -it --rm \
	--name container-ros_indigo \
    --privileged \
   	-e DISPLAY=unix$DISPLAY \
	-e LOCAL_USER_ID=`id -u $USER` \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /etc/machine-id:/etc/machine-id \
    -v $(pwd)/userhome:/home/container \
	--network="host" \
	roblabfhge/ros:indigo \
	bash 

xhost -local:
