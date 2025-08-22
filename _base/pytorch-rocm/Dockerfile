# Conda is not used as it is too heavy for dependency management
# in a containerised environment. We can install any non-Python dependencies globally.

# A VirtualEnv with PyTorch is created at `/opt/pytorch-env/`.
# You can link PyTorch dependencies to new virtual environments with:
# `/common/scripts/python3-link-parent-env.sh [parent env]` after activating the child env.

ARG ROCM_BASE_IMAGE=ghcr.io/futursolo/portable-ai/base:rocm-v6.4.2-does-not-exist

ARG PYTORCH_ENV_VERSION=v2.6.0-rocm-v6.4.2

FROM ${ROCM_BASE_IMAGE} AS build-pytorch

ARG PYTORCH_ENV_VERSION

USER root

RUN python3 -m venv /opt/pytorch-env/

RUN --mount=type=bind,source=./_base/pytorch-rocm/_scripts/,target=/tmp/_build/ \
    env \
    PATH="/opt/pytorch-env/bin:$PATH" \
    /tmp/_build/python3.12-install-pytorch-${PYTORCH_ENV_VERSION}.sh

FROM ${ROCM_BASE_IMAGE} AS build-final

COPY --from=build-pytorch --chown=root:root /opt/pytorch-env /opt/pytorch-env
