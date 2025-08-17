ARG ROCM_IMAGE_VERSION=6.4.3-complete
ARG KOBALDCPP_ROCM_VERSION=v1.97.4.yr0-ROCm

FROM bitnami/git AS build-git

ARG KOBALDCPP_ROCM_VERSION

WORKDIR /opt/
RUN git clone --depth 1 \
    --branch ${KOBALDCPP_ROCM_VERSION} \
    https://github.com/YellowRoseCx/koboldcpp-rocm.git

FROM rocm/dev-ubuntu-24.04:${ROCM_IMAGE_VERSION} AS build-app

USER root

RUN mkdir -p /opt/build
COPY ./common/ /opt/build/common

WORKDIR /opt/build

RUN /opt/build/common/scripts/apt-pre.sh
RUN /opt/build/common/scripts/apt-install-sudo.sh
RUN /opt/build/common/scripts/apt-install-python3-dev.sh
RUN /opt/build/common/scripts/apt-install-hipblas-dev.sh
RUN /opt/build/common/scripts/apt-install-build-essential.sh
RUN /opt/build/common/scripts/create-docker-user.sh

USER docker-user

COPY --from=build-git --chown=docker-user:docker-user /opt/koboldcpp-rocm /opt/koboldcpp

WORKDIR /opt/koboldcpp

ARG ROCM_PATH=/opt/rocm
ARG ROCM_GPU_TARGETS="gfx803 gfx900 gfx906 gfx908 gfx90a gfx1010 gfx1030 gfx1031 gfx1032 gfx1100 gfx1101 gfx1102"

RUN make LLAMA_HIPBLAS=1 GPU_TARGETS="${ROCM_GPU_TARGETS}" ALLAMDGPUS=1 -j$(nproc)

RUN rm -rf .git

WORKDIR /opt/rocm/lib

# Remove Extra Libraries
RUN find -mindepth 1 -maxdepth 1 -type d | grep -v "rocblas" | xargs sudo rm -rf

FROM ubuntu:24.04 AS build-final

RUN mkdir -p /opt/build
COPY ./common/ /opt/build/common

WORKDIR /opt/build

RUN /opt/build/common/scripts/apt-pre.sh
RUN /opt/build/common/scripts/apt-install-sudo.sh
RUN /opt/build/common/scripts/apt-install-python3-minimal.sh
RUN /opt/build/common/scripts/apt-install-rocminfo-deps.sh
RUN /opt/build/common/scripts/apt-post.sh

RUN /opt/build/common/scripts/create-docker-user.sh

RUN /opt/build/common/scripts/cleanup-build.sh

COPY --from=build-app /opt/koboldcpp /opt/koboldcpp
COPY --from=build-app /opt/amdgpu /opt/amdgpu
COPY --from=build-app /opt/rocm/lib /opt/rocm/lib
COPY --from=build-app /opt/rocm/bin /opt/rocm/bin
COPY --from=build-app /opt/rocm/libexec /opt/rocm/libexec

FROM scratch

COPY --from=build-final / /

USER docker-user

WORKDIR /opt/koboldcpp

SHELL ["/bin/bash", "-c"]

ENV PATH=/opt/rocm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENTRYPOINT [ "python3", "/opt/koboldcpp/koboldcpp.py" ]
