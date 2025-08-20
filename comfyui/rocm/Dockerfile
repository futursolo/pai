ARG PYTORCH_BASE_IMAGE=ghcr.io/futursolo/portable-ai/base:pytorch-v2.6.0-rocm-v6.4.2-20250820
ARG COMFYUI_VERSION=v0.3.50

FROM bitnami/git AS build-git

ARG COMFYUI_VERSION

WORKDIR /opt/
RUN git clone --depth 1 \
    --branch ${COMFYUI_VERSION} \
    https://github.com/comfyanonymous/ComfyUI.git

FROM ubuntu:24.04 AS build-comfyui

USER root

COPY --from=build-git --chown=root:root /opt/ComfyUI /opt/comfyui

WORKDIR /opt/comfyui

RUN --mount=type=bind,source=./comfyui/common/scripts/,target=/tmp/_build/ \
    /tmp/_build/create-base-tpl.sh

RUN rm -rf .git

FROM ${PYTORCH_BASE_IMAGE} AS build-comfyui-env

RUN python3 -m venv /opt/comfyui-env/
RUN --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    env \
    PATH="/opt/comfyui-env/bin:$PATH" \
    /tmp/_build/python3-link-parent-env.sh /opt/pytorch-env

COPY --from=build-git /opt/ComfyUI/requirements.txt /tmp/requirements.txt

RUN env \
    PATH="/opt/comfyui-env/bin:$PATH" \
    pip install -r /tmp/requirements.txt

FROM ${PYTORCH_BASE_IMAGE} AS build-final

COPY --from=build-comfyui --chown=root:root /opt/comfyui /opt/comfyui
COPY --from=build-comfyui-env --chown=root:root /opt/comfyui-env /opt/comfyui-env
COPY --from=build-comfyui --chown=docker-user:docker-user /opt/comfyui-base-tpl /home/docker-user/data

COPY ./comfyui/common/scripts/entrypoint.sh /

ENV PATH=/opt/comfyui-env/bin/:/opt/rocm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

USER docker-user

SHELL ["/bin/bash", "-c"]

WORKDIR /opt/comfyui

ENV COMFYUI_LISTEN="0.0.0.0"
ENV COMFYUI_BASE_DIR="/home/docker-user/data"
ENV COMFYUI_DB_URL="sqlite:////home/docker-user/data/user/comfyui.db"

VOLUME /home/docker-user/data

ENTRYPOINT /entrypoint.sh
