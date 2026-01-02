ARG ROCM_DEV_IMAGE=rocm/dev-ubuntu-24.04:7.1.1-complete
ARG BLAS_ROCM_BASE_IMAGE=ghcr.io/futursolo/pai-apps/base:blas-rocm-v7.1.1-20251223
ARG KOBOLDCPP_VERSION=v1.105

FROM alpine/git:2.49.1 AS build-git

ARG KOBOLDCPP_VERSION

WORKDIR /opt/
RUN git clone --depth 1 \
    --branch ${KOBOLDCPP_VERSION} \
    https://github.com/LostRuins/koboldcpp.git

FROM ${ROCM_DEV_IMAGE} AS build-koboldcpp

RUN --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    /tmp/_build/apt-pre.sh

RUN --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    /tmp/_build/apt-install-python3-dev.sh

RUN --mount=type=bind,source=./koboldcpp/rocm/_scripts/,target=/tmp/_build/ \
    /tmp/_build/apt-install-koboldcpp-rocm-deps.sh

COPY --from=build-git --chown=root:root /opt/koboldcpp /opt/koboldcpp

WORKDIR /opt/koboldcpp

ARG ROCM_PATH=/opt/rocm

RUN env \
    KCPP_CUDA=rocm \
    BRANCH_NAME=${KOBOLDCPP_VERSION} \
    TCL_LIBRARY=$(find /usr/lib/ -name 'tcl8*' | head -n 1) \
    TK_LIBRARY=$(find /usr/lib/ -name 'tk8*' | head -n 1) \
    ./koboldcpp.sh dist

RUN chmod 755 dist/koboldcpp-linux-x64-rocm

FROM ${BLAS_ROCM_BASE_IMAGE} AS build-final

COPY --from=build-koboldcpp /opt/koboldcpp/dist/koboldcpp-linux-x64-rocm /opt/koboldcpp/koboldcpp

USER pai-user

WORKDIR /opt/koboldcpp

SHELL ["/bin/bash", "-c"]

ENV PATH=/opt/rocm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENTRYPOINT [ "/opt/koboldcpp/koboldcpp" ]
