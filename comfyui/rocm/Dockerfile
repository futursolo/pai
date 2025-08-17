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

COPY ./common/ /opt/build/common

WORKDIR /opt/build

RUN /opt/build/common/scripts/apt-pre.sh
RUN /opt/build/common/scripts/apt-install-python3-dev.sh

RUN python3 -m venv /opt/pytorch-venv/

WORKDIR /opt/pytorch-venv/

RUN ./bin/pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/pytorch_triton_rocm-3.2.0%2Brocm6.4.2.git7e948ebf-cp312-cp312-linux_x86_64.whl
RUN ./bin/pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/torch-2.6.0%2Brocm6.4.2.git76481f7c-cp312-cp312-linux_x86_64.whl
RUN ./bin/pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/torchvision-0.21.0%2Brocm6.4.2.git4040d51f-cp312-cp312-linux_x86_64.whl
RUN ./bin/pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/torchaudio-2.6.0%2Brocm6.4.2.gitd8831425-cp312-cp312-linux_x86_64.whl

FROM rocm/dev-ubuntu-24.04:${ROCM_IMAGE_VERSION} AS build-comfyui

USER root

COPY ./common/ /opt/build/common

WORKDIR /opt/build

RUN /opt/build/common/scripts/apt-pre.sh
RUN /opt/build/common/scripts/apt-install-python3-dev.sh

RUN /opt/build/common/scripts/create-docker-user.sh

USER docker-user

COPY --from=build-git --chown=docker-user:docker-user /opt/ComfyUI /opt/comfyui
COPY --from=build-pytorch --chown=root:root /opt/pytorch-venv /opt/pytorch-venv

WORKDIR /opt/comfyui

RUN python3 -m venv ./.venv/
RUN realpath $(/opt/pytorch-venv/bin/python3 -c "import site; print(site.getsitepackages()[0])") \
    > $(./.venv/bin/python3 -c "import site; print(site.getsitepackages()[0])")/base_venv.pth

RUN ./.venv/bin/pip install -r requirements.txt

RUN rm -rf .git

FROM ubuntu:24.04 AS build-base

COPY ./common/ /opt/build/common

WORKDIR /opt/build

RUN /opt/build/common/scripts/apt-pre.sh
RUN /opt/build/common/scripts/apt-install-python3-minimal.sh
RUN /opt/build/common/scripts/apt-install-rocminfo-deps.sh
RUN /opt/build/common/scripts/apt-post.sh

RUN /opt/build/common/scripts/create-docker-user.sh

RUN /opt/build/common/scripts/cleanup-build.sh

FROM scratch

COPY --from=build-base / /
COPY --from=build-pytorch /opt/amdgpu /opt/amdgpu
COPY --from=build-pytorch /opt/rocm/ /opt/rocm/

COPY --from=build-pytorch --chown=root:root /opt/pytorch-venv /opt/pytorch-venv
COPY --from=build-comfyui --chown=docker-user:docker-user /opt/comfyui /opt/comfyui

ENV PATH=/opt/rocm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

USER docker-user

SHELL ["/bin/bash", "-c"]

WORKDIR /opt/comfyui

ENV COMFYUI_LISTEN="0.0.0.0"

CMD ./.venv/bin/python3 main.py --listen ${COMFYUI_LISTEN}
