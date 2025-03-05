#!/bin/bash
CUDA_VISIBLE_DEVICES=3

docker run \
    --gpus "device=${CUDA_VISIBLE_DEVICES}" \
    --env-file .env \
    -e PYTHONPATH=/home/duser/project \
    --name jumanji_container \
    --rm \
    -v $(pwd):/home/duser/project \
    --user $(id -u) \
    jumanji_image \
    /bin/bash -c "python3 ./jumanji/training/train.py"