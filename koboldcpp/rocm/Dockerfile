ARG ROCM_DEV_IMAGE=rocm/dev-ubuntu-24.04:6.4.3-complete
ARG ROCM_IMAGE=rocm/dev-ubuntu-24.04:6.4.3
ARG KOBOLDCPP_ROCM_VERSION=v1.97.4.yr0-ROCm
ARG BASE_IMAGE=build-base

FROM bitnami/git AS build-git

ARG KOBOLDCPP_ROCM_VERSION

WORKDIR /opt/
RUN git clone --depth 1 \
    --branch ${KOBOLDCPP_ROCM_VERSION} \
    https://github.com/YellowRoseCx/koboldcpp-rocm.git

FROM ${ROCM_DEV_IMAGE} AS build-rocm-extras

USER root

RUN mkdir -p /opt/rocm-extras-lib/
RUN cp -av /opt/rocm/lib/libhipblas.so /opt/rocm-extras-lib/
RUN cp -av /opt/rocm/lib/libhipblas.so.* /opt/rocm-extras-lib/
RUN cp -av /opt/rocm/lib/librocblas.so /opt/rocm-extras-lib/
RUN cp -av /opt/rocm/lib/librocblas.so.* /opt/rocm-extras-lib/

FROM ${ROCM_IMAGE} AS build-rocm

WORKDIR /opt/rocm/lib

COPY --from=build-rocm-extras /opt/rocm/lib/rocblas/ /opt/rocm/lib/rocblas/
COPY --from=build-rocm-extras /opt/rocm-extras-lib/ /opt/rocm-extras-lib/

RUN cp -av /opt/rocm-extras-lib/* /opt/rocm/lib/

FROM ${ROCM_DEV_IMAGE} AS build-koboldcpp

RUN --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    /tmp/_build/apt-pre.sh

RUN --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    /tmp/_build/apt-install-python3-dev.sh

COPY --from=build-git --chown=root:root /opt/koboldcpp-rocm /opt/koboldcpp

WORKDIR /opt/koboldcpp

ARG ROCM_PATH=/opt/rocm
ARG ROCM_GPU_TARGETS="gfx803 gfx900 gfx906 gfx908 gfx90a gfx1010 gfx1030 gfx1031 gfx1032 gfx1100 gfx1101 gfx1102 gfx1200 gfx1201"

RUN make LLAMA_HIPBLAS=1 GPU_TARGETS="${ROCM_GPU_TARGETS}" ALLAMDGPUS=1 -j$(nproc)

RUN rm -rf .git

RUN mkdir -p /opt/koboldcpp/dist
RUN cp -av *.py /opt/koboldcpp/dist/
RUN cp -av *.embd /opt/koboldcpp/dist/
RUN cp -av *.so /opt/koboldcpp/dist/
RUN cp -av *.md /opt/koboldcpp/dist/
RUN cp -av *.txt /opt/koboldcpp/dist/

WORKDIR /opt/koboldcpp/dist
RUN chmod +x ./koboldcpp.py
RUN ln -s /opt/koboldcpp/dist/koboldcpp ./koboldcpp.py

FROM ubuntu:24.04 AS build-base

COPY --from=build-rocm /opt/amdgpu /opt/amdgpu
COPY --from=build-rocm /opt/rocm/bin /opt/rocm/bin
COPY --from=build-rocm /opt/rocm/libexec /opt/rocm/libexec
COPY --from=build-rocm /opt/rocm/lib /opt/rocm/lib

RUN  --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh && \
    /tmp/_build/apt-install-python3-minimal.sh && \
    /tmp/_build/apt-install-rocminfo-deps.sh && \
    /tmp/_build/create-docker-user.sh

FROM ${BASE_IMAGE} AS build-final

COPY --from=build-koboldcpp /opt/koboldcpp/dist /opt/koboldcpp

USER docker-user

WORKDIR /opt/koboldcpp

SHELL ["/bin/bash", "-c"]

ENV PATH=/opt/rocm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENTRYPOINT [ "/opt/koboldcpp/koboldcpp" ]
