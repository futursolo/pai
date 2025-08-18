ARG ROCM_IMAGE_VERSION=6.4.2-complete
ARG COMFYUI_VERSION=v0.3.50
ARG PYTORCH_ENV_VERSION=v2.6.0-rocm-v6.4.2

FROM bitnami/git AS build-git

ARG COMFYUI_VERSION

WORKDIR /opt/
RUN git clone --depth 1 \
    --branch ${COMFYUI_VERSION} \
    https://github.com/comfyanonymous/ComfyUI.git

FROM rocm/dev-ubuntu-24.04:${ROCM_IMAGE_VERSION} AS build-rocm

USER root

RUN rm -rf /opt/rocm/lib/llvm

FROM rocm/dev-ubuntu-24.04:${ROCM_IMAGE_VERSION} AS build-pytorch

USER root

COPY ./common/ /opt/build/common/

RUN /opt/build/common/scripts/apt-pre.sh
RUN /opt/build/common/scripts/apt-install-python3-dev.sh

RUN python3 -m venv /opt/pytorch-venv/

WORKDIR /opt/pytorch-venv/

RUN env \
    PATH="/opt/pytorch-venv/bin:$PATH" \
    /opt/build/common/scripts/python3.12-install-pytorch-${PYTORCH_ENV_VERSION}.sh

FROM build-pytorch AS build-comfyui

USER root

COPY --from=build-git --chown=root:root /opt/ComfyUI /opt/comfyui

WORKDIR /opt/comfyui

RUN python3 -m venv ./.venv/
RUN env \
    PATH="/opt/comfyui/.venv/bin:$PATH" \
    /opt/build/common/python3-link-parent-venv.sh /opt/pytorch-venv

RUN ./.venv/bin/pip install -r requirements.txt

COPY ./comfyui/common/ /opt/build/comfyui/common/
RUN /opt/build/comfyui/common/scripts/create-base-tpl.sh

RUN rm -rf .git

FROM ubuntu:24.04 AS build-base

COPY ./common/ /opt/build/common/

WORKDIR /opt/build

RUN /opt/build/common/scripts/apt-pre.sh
RUN /opt/build/common/scripts/apt-install-python3-minimal.sh
RUN /opt/build/common/scripts/apt-install-rocminfo-deps.sh
RUN /opt/build/common/scripts/apt-post.sh

RUN /opt/build/common/scripts/create-docker-user.sh

RUN /opt/build/common/scripts/cleanup-build.sh

FROM scratch

COPY --from=build-base / /
COPY --from=build-rocm /opt/amdgpu /opt/amdgpu
COPY --from=build-rocm /opt/rocm/ /opt/rocm/

COPY --from=build-pytorch --chown=root:root /opt/pytorch-venv /opt/pytorch-venv
COPY --from=build-comfyui --chown=root:root /opt/comfyui /opt/comfyui
COPY --from=build-comfyui --chown=docker-user:docker-user /opt/comfyui-base-tpl /home/docker-user/data

COPY ./comfyui/common/scripts/entrypoint.sh /

ENV PATH=/opt/comfyui/.venv/bin/:/opt/rocm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

USER docker-user

SHELL ["/bin/bash", "-c"]

WORKDIR /opt/comfyui

ENV COMFYUI_LISTEN="0.0.0.0"
ENV COMFYUI_BASE_DIR="/home/docker-user/data"
ENV COMFYUI_DB_URL="sqlite:////home/docker-user/data/user/comfyui.db"

VOLUME /home/docker-user/data

ENTRYPOINT /entrypoint.sh
