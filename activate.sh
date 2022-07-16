#!/usr/bin/bash
img=unreal-engine
home=$img
docker run -it \
    --name build-unreal \
    --device=/dev/dri:/dev/dri \
    --device=/dev/input:/dev/input \
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
