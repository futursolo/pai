ARG ROCM_IMAGE_VERSION=6.4.3-complete
ARG KOBALDCPP_ROCM_VERSION=v1.97.4.yr0-ROCm

FROM bitnami/git AS build-git

ARG KOBALDCPP_ROCM_VERSION

WORKDIR /opt/
RUN git clone --depth 1 \
    --branch ${KOBALDCPP_ROCM_VERSION} \
    https://github.com/YellowRoseCx/koboldcpp-rocm.git

FROM rocm/dev-ubuntu-24.04:${ROCM_IMAGE_VERSION} AS build-builder

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

FROM rocm/dev-ubuntu-24.04:${ROCM_IMAGE_VERSION}

COPY ./common/ /opt/build/common/
COPY ./koboldcpp/rocm/ /opt/build/koboldcpp/rocm/

RUN /opt/build/common/scripts/apt-pre.sh
RUN /opt/build/common/scripts/apt-rocminfo-deps.sh
RUN /opt/build/common/scripts/apt-post.sh

RUN /opt/build/common/scripts/create-docker-user.sh
RUN /opt/build/common/cleanup-build.sh

USER docker-user

COPY --from=build-builder --chown=docker-user:docker-user /opt/koboldcpp /opt/koboldcpp

WORKDIR /opt/koboldcpp

ENV ROCM_PATH=/opt/rocm

ENTRYPOINT [ "python3", "/opt/koboldcpp/koboldcpp.py" ]
