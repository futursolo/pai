ARG PYTORCH_BASE_IMAGE=ghcr.io/futursolo/pai-apps/base:pytorch-v2.12.0-rocm-v7.14.0-20260817
ARG COMFYUI_VERSION=v0.33.1

FROM alpine/git:2.52.0 AS build-git

ARG COMFYUI_VERSION

WORKDIR /opt/
RUN git clone --depth 1 \
    --branch ${COMFYUI_VERSION} \
    https://github.com/Comfy-Org/ComfyUI.git

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

RUN --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh && \
    /tmp/_build/apt-install-curl.sh

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

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8188/ || exit 1

ENTRYPOINT [ "/entrypoint.sh" ]
