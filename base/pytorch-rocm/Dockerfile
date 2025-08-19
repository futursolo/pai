# Conda is not used as it is too heavy for dependency management
#in a containerised environment. We can install any non-Python dependencies globally.

# A VirtualEnv with PyTorch is created at `/opt/pytorch-env/`.
# You can link PyTorch dependencies to new virtual environments with:
# `/common/scripts/python3-link-parent-venv.sh [parent env]` after activating the child env.

ARG ROCM_DEV_IMAGE=rocm/dev-ubuntu-24.04:6.4.2-complete
ARG ROCM_IMAGE=rocm/dev-ubuntu-24.04:6.4.2

ARG PYTORCH_ENV_VERSION=v2.6.0-rocm-v6.4.2

FROM ${ROCM_IMAGE} AS build-rocm

FROM ${ROCM_DEV_IMAGE} AS build-pytorch

ARG PYTORCH_ENV_VERSION

USER root

RUN --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    /tmp/_build/apt-pre.sh

RUN --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    /tmp/_build/apt-install-python3-dev.sh

RUN python3 -m venv /opt/pytorch-env/

RUN --mount=type=bind,source=./pytorch/rocm/scripts/,target=/tmp/_build/ \
    env \
    PATH="/opt/pytorch-env/bin:$PATH" \
    /tmp/_build/python3.12-install-pytorch-${PYTORCH_ENV_VERSION}.sh

FROM ubuntu:24.04 AS build-base

RUN  --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh && \
    /tmp/_build/apt-install-python3-dev.sh && \
    /tmp/_build/apt-install-rocminfo-deps.sh && \
    /tmp/_build/create-docker-user.sh

COPY --from=build-rocm /opt/amdgpu/ /opt/amdgpu/
COPY --from=build-rocm /opt/rocm/ /opt/rocm/

COPY --from=build-pytorch --chown=root:root /opt/pytorch-env /opt/pytorch-env
