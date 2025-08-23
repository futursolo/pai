# Conda is not used as it is too heavy for dependency management
# in a containerised environment. We can install any non-Python dependencies globally.

# A VirtualEnv with PyTorch is created at `/opt/pytorch-env/`.
# You can link PyTorch dependencies to new virtual environments with:
# `/_base/_scripts/python3-link-parent-env.sh [parent env]` after activating the child env.

ARG INTEL_BASE_IMAGE=ghcr.io/futursolo/pai-apps/base:intel-20250823

ARG PYTORCH_ENV_VERSION=v2.8.0-ipex-v2.8.10

FROM ${INTEL_BASE_IMAGE} AS build-ipex-base

RUN --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-install-python3.sh

FROM build-ipex-base AS build-pytorch

ARG PYTORCH_ENV_VERSION

RUN --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-install-python3-dev.sh

RUN python3 -m venv /opt/pytorch-env/

RUN --mount=type=bind,source=./_base/pytorch-ipex/_scripts/,target=/tmp/_build/ \
    env \
    PATH="/opt/pytorch-env/bin:$PATH" \
    /tmp/_build/python3.12-install-pytorch-${PYTORCH_ENV_VERSION}.sh

FROM build-ipex-base AS build-final

COPY --from=build-pytorch --chown=root:root /opt/pytorch-env /opt/pytorch-env
