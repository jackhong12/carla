#!/usr/bin/bash
img=carla-test
home=$img
docker run -it \
    --rm \
    -e "TERM=xterm-256color" \
    -e DISPLAY=unix$DISPLAY \
    -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
    -v $(pwd):/home/$home/share \
    --gpus all \
    --network host \
    --detach-keys="ctrl-@" \
    --privileged=true \
    $img \
    zsh
