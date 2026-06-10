FROM ubuntu:26.04 AS build-vulkan-final

ENV TZ=Etc/UTC

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    /tmp/_build/create-pai-user.sh

RUN --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/base/ \
    --mount=type=bind,source=./_base/vulkan/_scripts/,target=/tmp/_build/vulkan/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/base/apt-pre.sh && \
    /tmp/_build/vulkan/apt-install-vulkan-deps.sh
