#!/bin/bash

IMG_NAME=carla-test
docker build . \
    --build-arg usern=$IMG_NAME \
    --build-arg USER_UID=$(id -g $USER) \
    --build-arg USER_GID=$(id -g $USER) \
    -t $IMG_NAME
