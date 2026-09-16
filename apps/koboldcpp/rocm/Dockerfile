ARG ROCM_DEV_IMAGE=rocm/dev-ubuntu-26.04:7.14.0-full
ARG KOBOLDCPP_VERSION=v1.121

FROM alpine/git:2.52.0 AS build-git

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

FROM ubuntu:26.04 AS build-final

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    /tmp/_build/create-pai-user.sh

RUN --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh && \
    /tmp/_build/apt-install-curl.sh

COPY --from=build-koboldcpp /opt/koboldcpp/dist/koboldcpp-linux-x64-rocm /opt/koboldcpp/koboldcpp

USER pai-user

WORKDIR /opt/koboldcpp

SHELL ["/bin/bash", "-c"]

ENV PATH=/opt/rocm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV PAI_HEALTHCHECK_URL=http://localhost:5001/

HEALTHCHECK --interval=30s --timeout=5s --start-period=300s --retries=3 \
    CMD curl -f "$PAI_HEALTHCHECK_URL" || exit 1

ENTRYPOINT [ "/opt/koboldcpp/koboldcpp" ]
