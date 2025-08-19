ARG COMFYUI_VERSION=v0.3.50
ARG PYTORCH_ENV_VERSION=v2.7.0-ipex

FROM bitnami/git AS build-git

ARG COMFYUI_VERSION

WORKDIR /opt/
RUN git clone --depth 1 \
    --branch ${COMFYUI_VERSION} \
    https://github.com/comfyanonymous/ComfyUI.git

FROM ubuntu:24.04 AS build-deps

