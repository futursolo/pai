FROM ubuntu:24.04 AS build-final

ENV TZ=Etc/UTC

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    /tmp/_build/create-pai-user.sh

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh

RUN  --mount=type=bind,source=./_base/vulkan/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-install-vulkan-deps.sh
