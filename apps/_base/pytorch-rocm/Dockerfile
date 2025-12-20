# Conda is not used as it is too heavy for dependency management
# in a containerised environment. We can install any non-Python dependencies globally.

# A VirtualEnv with PyTorch is created at `/opt/pytorch-env/`.
# You can link PyTorch dependencies to new virtual environments with:
# `/_base/_scripts/python3-link-parent-env.sh [parent env]` after activating the child env.

ARG ROCM_BASE_IMAGE=ghcr.io/futursolo/pai-apps/base:rocm-v7.1.1-20251220

ARG PYTORCH_ENV_VERSION=v2.9.1-rocm-v7.1.1-vendor-rocm

FROM ${ROCM_BASE_IMAGE} AS build-pytorch-deps

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh

RUN  --mount=type=bind,source=./_base/pytorch-rocm/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-install-pytorch-rocm-deps.sh

FROM build-pytorch-deps AS build-pytorch

ARG PYTORCH_ENV_VERSION

RUN python3 -m venv /opt/pytorch-env/

RUN --mount=type=bind,source=./_base/pytorch-rocm/_scripts/,target=/tmp/_build/ \
    env \
    PATH="/opt/pytorch-env/bin:$PATH" \
    /tmp/_build/python3.12-install-pytorch-${PYTORCH_ENV_VERSION}.sh

FROM build-pytorch-deps AS build-final

COPY --from=build-pytorch --chown=root:root /opt/pytorch-env /opt/pytorch-env

ENV PATH=/opt/pytorch-env/bin/:$PATH
