ARG PYTORCH_ENV_VERSION=v2.12.0-xpu

FROM ubuntu:24.04 AS build-intel-final

ENV TZ=Etc/UTC

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    /tmp/_build/create-pai-user.sh

RUN --mount=type=bind,source=./_base/intel/_scripts/,target=/tmp/_build/base-intel/ \
    --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/base/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/base/apt-pre.sh && \
    /tmp/_build/base-intel/apt-add-intel-repo.sh

RUN --mount=type=bind,source=./_base/intel/_scripts/,target=/tmp/_build/base-intel/ \
    --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/base/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/base/apt-pre.sh && \
    /tmp/_build/base-intel/apt-install-intel-deps.sh

FROM build-intel-final AS build-pytorch-xpu-base

RUN --mount=type=bind,source=./_base/intel/_scripts/,target=/tmp/_build/base-intel/ \
    --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/base/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/base/apt-pre.sh && \
    /tmp/_build/base-intel/apt-install-python3.sh

FROM build-pytorch-xpu-base AS build-pytorch-xpu

ARG PYTORCH_ENV_VERSION

RUN --mount=type=bind,source=./_base/intel/_scripts/,target=/tmp/_build/base-intel/ \
    --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/base/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/base/apt-pre.sh && \
    /tmp/_build/base-intel/apt-install-python3-dev.sh

RUN python3 -m venv /opt/pytorch-env/

RUN --mount=type=bind,source=./_base/intel/_scripts/,target=/tmp/_build/ \
    env \
    PATH="/opt/pytorch-env/bin:$PATH" \
    /tmp/_build/python3.12-install-pytorch-${PYTORCH_ENV_VERSION}.sh

FROM build-pytorch-xpu-base AS build-pytorch-xpu-final

COPY --from=build-pytorch-xpu --chown=root:root /opt/pytorch-env /opt/pytorch-env

ENV PATH=/opt/pytorch-env/bin/:$PATH
