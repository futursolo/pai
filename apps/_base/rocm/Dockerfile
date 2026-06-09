ARG ROCM_VERSION=7.1.1
ARG PYTORCH_ENV_VERSION=v2.9.1-rocm-v7.1.1-vendor-rocm

FROM ubuntu:24.04 AS build-rocm-final

ARG ROCM_VERSION

ENV TZ=Etc/UTC

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    /tmp/_build/create-pai-user.sh

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-install-python3.sh

RUN  --mount=type=bind,source=./_base/rocm/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-add-rocm-repo.sh

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh

RUN  --mount=type=bind,source=./_base/rocm/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-install-rocm-dev.sh

ENV ROCM_PATH=/opt/rocm
ENV LD_LIBRARY_PATH=/opt/rocm/lib
ENV PATH=/opt/rocm/bin:$PATH

FROM build-rocm-final AS build-blas-rocm-final

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh

RUN  --mount=type=bind,source=./_base/rocm/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-install-blas-rocm-deps.sh

FROM build-blas-rocm-final AS build-pytorch-rocm-deps

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh

RUN  --mount=type=bind,source=./_base/rocm/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-install-pytorch-rocm-deps.sh

FROM build-pytorch-rocm-deps AS build-pytorch

ARG PYTORCH_ENV_VERSION

RUN python3 -m venv /opt/pytorch-env/

RUN --mount=type=bind,source=./_base/rocm/_scripts/,target=/tmp/_build/ \
    env \
    PATH="/opt/pytorch-env/bin:$PATH" \
    /tmp/_build/python3.12-install-pytorch-${PYTORCH_ENV_VERSION}.sh

FROM build-pytorch-rocm-deps AS build-pytorch-rocm-final

COPY --from=build-pytorch --chown=root:root /opt/pytorch-env /opt/pytorch-env

ENV PATH=/opt/pytorch-env/bin/:$PATH
