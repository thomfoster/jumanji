FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

ENV CUDA_PATH /usr/local/cuda
ENV CUDA_INCLUDE_PATH /usr/local/cuda/include
ENV CUDA_LIBRARY_PATH /usr/local/cuda/lib64

# Set timezone
ENV TZ=Europe/London DEBIAN_FRONTEND=noninteractive

# Add Python 3.8 to Ubuntu 22.04 and install dependencies
RUN apt update
RUN apt install -y software-properties-common && add-apt-repository ppa:deadsnakes/ppa
RUN apt install -y \
    git \
    python3.10 \
    python3-pip \
    python3.10-venv \
    python3-setuptools \
    python3-wheel

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
RUN update-alternatives --set python3 /usr/bin/python3.10

# Create local user
# https://jtreminio.com/blog/running-docker-containers-as-current-host-user/
ARG UID
ARG GID
RUN if [ ${UID:-0} -ne 0 ] && [ ${GID:-0} -ne 0 ]; then \
    groupadd -g ${GID} duser &&\
    useradd -l -u ${UID} -g duser duser &&\
    install -d -m 0755 -o duser -g duser /home/duser &&\
    chown --changes --silent --no-dereference --recursive ${UID}:${GID} /home/duser \
    ;fi

USER duser
WORKDIR /home/duser

# Install Python packages
ENV PATH="/home/duser/.local/bin:$PATH"
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install uv
RUN python3 -m pip install --upgrade uv
RUN uv venv -p=3.12
WORKDIR /home/duser/project
COPY --chown=duser:duser . /home/duser/project
RUN uv pip install -e ".[dev,train]"
RUN uv pip install "jax[cuda12]"