ARG PYTORCH_BASE_IMAGE=ghcr.io/futursolo/pai-apps/base:pytorch-v2.8.0-rocm-v6.4.3
ARG COMFYUI_VERSION=v0.3.51

FROM bitnami/git:2.51.0 AS build-git

ARG COMFYUI_VERSION

WORKDIR /opt/
RUN git clone --depth 1 \
    --branch ${COMFYUI_VERSION} \
    https://github.com/comfyanonymous/ComfyUI.git

FROM ubuntu:24.04 AS build-comfyui

COPY --from=build-git --chown=root:root /opt/ComfyUI /opt/comfyui

WORKDIR /opt/comfyui

RUN --mount=type=bind,source=./apps/comfyui/_scripts/,target=/tmp/_build/ \
    /tmp/_build/create-base-tpl.sh

RUN rm -rf .git

FROM ${PYTORCH_BASE_IMAGE} AS build-comfyui-env

RUN python3 -m venv /opt/comfyui-env/
RUN --mount=type=bind,source=./apps/_base/_scripts/,target=/tmp/_build/ \
    env \
    PATH="/opt/comfyui-env/bin:$PATH" \
    /tmp/_build/python3-link-parent-env.sh /opt/pytorch-env

COPY --from=build-git /opt/ComfyUI/requirements.txt /tmp/requirements.txt

RUN env \
    PATH="/opt/comfyui-env/bin:$PATH" \
    pip install -r /tmp/requirements.txt

FROM ${PYTORCH_BASE_IMAGE} AS build-final

COPY --from=build-comfyui /opt/comfyui /opt/comfyui
COPY --from=build-comfyui-env /opt/comfyui-env /opt/comfyui-env
COPY --from=build-comfyui /opt/comfyui-base-tpl /opt/comfyui-tpl-base

COPY ./apps/comfyui/_scripts/entrypoint.sh /

ENV PATH=/opt/comfyui-env/bin/:/opt/rocm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN mkdir -p /mnt/data/
RUN chown pai-user:pai-user /mnt/data/

USER pai-user

SHELL ["/bin/bash", "-c"]

WORKDIR /opt/comfyui

ENV COMFYUI_LISTEN="0.0.0.0"
ENV COMFYUI_BASE_DIR="/mnt/data"
ENV COMFYUI_DB_URL="sqlite:////mnt/data/user/comfyui.db"

VOLUME /mnt/data

ENTRYPOINT [ "/entrypoint.sh" ]
