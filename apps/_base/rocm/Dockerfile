ARG PYTORCH_ENV_VERSION=v2.12.0-rocm-v7.14.0-vendor-rocm

FROM ubuntu:24.04 AS build-pytorch-rocm-deps

ENV TZ=Etc/UTC

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    /tmp/_build/create-pai-user.sh

RUN --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/base/ \
    --mount=type=bind,source=./_base/rocm/_scripts/,target=/tmp/_build/rocm/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/base/apt-pre.sh && \
    /tmp/_build/base/apt-install-python3.sh

RUN --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/base/ \
    --mount=type=bind,source=./_base/rocm/_scripts/,target=/tmp/_build/rocm/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/base/apt-pre.sh && \
    /tmp/_build/rocm/apt-install-pytorch-rocm-deps.sh

FROM build-pytorch-rocm-deps AS build-pytorch

ARG PYTORCH_ENV_VERSION

RUN python3 -m venv /opt/pytorch-env/

RUN --mount=type=bind,source=./_base/rocm/_scripts/,target=/tmp/_build/ \
    env \
    PATH="/opt/pytorch-env/bin:$PATH" \
    /tmp/_build/python3.14-install-pytorch-${PYTORCH_ENV_VERSION}.sh

FROM build-pytorch-rocm-deps AS build-pytorch-rocm-final

COPY --from=build-pytorch --chown=root:root /opt/pytorch-env /opt/pytorch-env

ENV PATH=/opt/pytorch-env/bin/:$PATH
