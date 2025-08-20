# Conda is not used as it is too heavy for dependency management
#in a containerised environment. We can install any non-Python dependencies globally.

# A VirtualEnv with PyTorch is created at `/opt/pytorch-env/`.
# You can link PyTorch dependencies to new virtual environments with:
# `/common/scripts/python3-link-parent-env.sh [parent env]` after activating the child env.

ARG PYTORCH_ENV_VERSION=v2.8.0-ipex-v2.8.10

FROM ubuntu:24.04 AS build-ipex-base

USER root

RUN --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh

RUN --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-add-intel-repo.sh

RUN --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh

RUN --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-install-ipex-deps.sh

RUN --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-install-python3-dev.sh

FROM build-ipex-base AS build-pytorch

ARG PYTORCH_ENV_VERSION

USER root

RUN python3 -m venv /opt/pytorch-env/

RUN --mount=type=bind,source=./base/pytorch-ipex/scripts/,target=/tmp/_build/ \
    env \
    PATH="/opt/pytorch-env/bin:$PATH" \
    /tmp/_build/python3.12-install-pytorch-${PYTORCH_ENV_VERSION}.sh

FROM build-ipex-base AS build-final

RUN  --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh && \
    /tmp/_build/create-docker-user.sh

COPY --from=build-pytorch --chown=root:root /opt/pytorch-env /opt/pytorch-env
