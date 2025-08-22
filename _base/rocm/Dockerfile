ARG ROCM_IMAGE=rocm/dev-ubuntu-24.04:6.4.3

FROM ${ROCM_IMAGE} AS build-rocm

FROM ubuntu:24.04 AS build-final

RUN  --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh && \
    /tmp/_build/apt-install-python3-dev.sh && \
    /tmp/_build/apt-install-rocminfo-deps.sh && \
    /tmp/_build/create-docker-user.sh

COPY --from=build-rocm /opt/amdgpu/ /opt/amdgpu/
COPY --from=build-rocm /opt/rocm/ /opt/rocm/
