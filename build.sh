#!/bin/bash

docker build \
    --build-arg UID=$(id -u ${USER}) \
    --build-arg GID=1234 \
    -t jumanji_image \
    --progress plain \
    .
    # --no-cache \