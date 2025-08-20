ARG KOBOLDCPP_VERSION=v1.97.4

FROM curlimages/curl:8.15.0 AS build-curl

ARG KOBOLDCPP_VERSION

WORKDIR /tmp

RUN curl -O -L \
    https://github.com/LostRuins/koboldcpp/releases/download/${KOBOLDCPP_VERSION}/koboldcpp-linux-x64-nocuda

RUN chmod +x /tmp/koboldcpp-linux-x64-nocuda

FROM ubuntu:24.04 AS build-final

RUN  --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh && \
    /tmp/_build/apt-install-vulkan-deps.sh && \
    /tmp/_build/create-docker-user.sh

RUN mkdir -p /opt/koboldcpp
COPY --from=build-curl --chown=root:root /tmp/koboldcpp-linux-x64-nocuda /opt/koboldcpp/koboldcpp

USER docker-user

WORKDIR /opt/koboldcpp

SHELL ["/bin/bash", "-c"]

ENTRYPOINT [ "/opt/koboldcpp/koboldcpp" ]
