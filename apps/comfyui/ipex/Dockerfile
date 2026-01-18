ARG PYTORCH_BASE_IMAGE=ghcr.io/futursolo/pai-apps/base:pytorch-v2.9.1-ipex-20251220
ARG COMFYUI_VERSION=v0.9.2

FROM alpine/git:2.49.1 AS build-git

ARG COMFYUI_VERSION

WORKDIR /opt/
RUN git clone --depth 1 \
    --branch ${COMFYUI_VERSION} \
    https://github.com/comfyanonymous/ComfyUI.git

FROM ubuntu:24.04 AS build-comfyui

COPY --from=build-git --chown=root:root /opt/ComfyUI /opt/comfyui

WORKDIR /opt/comfyui

RUN --mount=type=bind,source=./comfyui/_scripts/,target=/tmp/_build/ \
    /tmp/_build/create-base-tpl.sh

RUN rm -rf .git

FROM ${PYTORCH_BASE_IMAGE} AS build-comfyui-env

RUN python3 -m venv /opt/comfyui-env/
RUN --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    env \
    PATH="/opt/comfyui-env/bin:$PATH" \
    /tmp/_build/python3-link-parent-env.sh /opt/pytorch-env

COPY --from=build-git /opt/ComfyUI/requirements.txt /tmp/requirements.txt

RUN env \
    PATH="/opt/comfyui-env/bin:$PATH" \
    pip install -r /tmp/requirements.txt

FROM ${PYTORCH_BASE_IMAGE} AS build-final

COPY --from=build-comfyui /opt/comfyui /opt/comfyui
COPY --from=build-comfyui /opt/comfyui-base-tpl /opt/comfyui-base-tpl
COPY --from=build-comfyui-env /opt/comfyui-env /opt/comfyui-env

COPY ./comfyui/_scripts/entrypoint.sh /

ENV PATH=/opt/comfyui-env/bin/:$PATH

RUN mkdir -p /mnt/comfyui/
RUN chown pai-user:pai-user /mnt/comfyui/

USER pai-user

SHELL ["/bin/bash", "-c"]

WORKDIR /opt/comfyui

ENV COMFYUI_LISTEN="0.0.0.0"
ENV COMFYUI_BASE_DIR="/mnt/comfyui"
ENV COMFYUI_DB_URL="sqlite:////mnt/comfyui/user/comfyui.db"

VOLUME /mnt/comfyui

ENTRYPOINT [ "/entrypoint.sh" ]
