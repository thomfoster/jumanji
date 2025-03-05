#!/bin/bash
CUDA_VISIBLE_DEVICES=3

docker run \
    --gpus "device=${CUDA_VISIBLE_DEVICES}" \
    --env-file .env \
    -e PYTHONPATH=/home/duser \
    --name jumanji_container \
    --rm \
    --user $(id -u) \
    jumanji_image \
    /bin/bash -c "source ../.venv/bin/activate; python ./jumanji/training/train.py"
    # -v $(pwd):/home/duser/project \