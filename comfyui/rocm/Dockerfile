ARG ROCM_IMAGE_VERSION=6.4.2-complete
ARG COMFYUI_VERSION=v0.3.50

FROM bitnami/git AS build-git

ARG COMFYUI_VERSION

WORKDIR /opt/
RUN git clone --depth 1 \
    --branch ${COMFYUI_VERSION} \
    https://github.com/comfyanonymous/ComfyUI.git

FROM rocm/dev-ubuntu-24.04:${ROCM_IMAGE_VERSION} AS build-pytorch

USER root

RUN mkdir -p /opt/build
COPY ./common/ /opt/build/common

WORKDIR /opt/build

RUN /opt/build/common/scripts/apt-pre.sh
RUN /opt/build/common/scripts/apt-install-python3-dev.sh

RUN python3 -m venv /opt/pytorch-venv/

WORKDIR /opt/pytorch-venv/

RUN ./bin/pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/torch-2.6.0%2Brocm6.4.2.git76481f7c-cp312-cp312-linux_x86_64.whl
RUN ./bin/pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/torchvision-0.21.0%2Brocm6.4.2.git4040d51f-cp312-cp312-linux_x86_64.whl
RUN ./bin/pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/torchaudio-2.6.0%2Brocm6.4.2.gitd8831425-cp312-cp312-linux_x86_64.whl

FROM rocm/dev-ubuntu-24.04:${ROCM_IMAGE_VERSION} AS build-comfyui

USER root

RUN mkdir -p /opt/build
COPY ./common/ /opt/build/common

WORKDIR /opt/build

RUN /opt/build/common/scripts/apt-pre.sh
RUN /opt/build/common/scripts/apt-install-python3-dev.sh

RUN /opt/build/common/scripts/create-docker-user.sh

USER docker-user

COPY --from=build-git --chown=docker-user:docker-user /opt/ComfyUI /opt/comfyui
COPY --from=build-pytorch --chown=docker-user:docker-user /opt/pytorch-venv /opt/comfyui/.venv/

WORKDIR /opt/comfyui

RUN ./.venv/bin/pip install -r requirements.txt

RUN rm -rf .git

FROM rocm/dev-ubuntu-24.04:${ROCM_IMAGE_VERSION} AS build-final

USER root

RUN --mount=type=bind,source=./common,target=/opt/build/common/ \
    /opt/build/common/scripts/apt-pre.sh && \
    /opt/build/common/scripts/apt-install-python3-minimal.sh && \
    /opt/build/common/scripts/apt-post.sh && \
    /opt/build/common/scripts/create-docker-user.sh

USER docker-user

COPY --from=build-comfyui --chown=docker-user:docker-user /opt/comfyui /opt/comfyui

WORKDIR /opt/comfyui

ENV COMFYUI_LISTEN="0.0.0.0"

SHELL ["/bin/bash", "-c"]

CMD ./.venv/bin/python3 main.py --listen ${COMFYUI_LISTEN}
