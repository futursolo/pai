ARG ROCM_BASE_IMAGE=ghcr.io/futursolo/pai-apps/base:rocm-v7.1.1-20251220

FROM ${ROCM_BASE_IMAGE} AS build-final

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh

RUN  --mount=type=bind,source=./_base/blas-rocm/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-install-blas-rocm-deps.sh
