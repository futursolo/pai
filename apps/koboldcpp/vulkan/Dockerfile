ARG VULKAN_BASE_IMAGE=ghcr.io/futursolo/pai-apps/base:vulkan-20260817

ARG KOBOLDCPP_VERSION=v1.121

FROM ubuntu:26.04 AS build-koboldcpp

ARG KOBOLDCPP_VERSION

WORKDIR /tmp

ADD https://github.com/LostRuins/koboldcpp/releases/download/${KOBOLDCPP_VERSION}/koboldcpp-linux-x64-nocuda \
    /tmp/

RUN chmod 755 /tmp/koboldcpp-linux-x64-nocuda

FROM ${VULKAN_BASE_IMAGE} AS build-final

RUN mkdir -p /opt/koboldcpp
COPY --from=build-koboldcpp --chown=root:root /tmp/koboldcpp-linux-x64-nocuda /opt/koboldcpp/koboldcpp

USER pai-user

WORKDIR /opt/koboldcpp

SHELL ["/bin/bash", "-c"]

ENV PAI_HEALTHCHECK_URL=http://localhost:5001/

HEALTHCHECK --interval=30s --timeout=5s --start-period=300s --retries=3 \
    CMD curl -f "$PAI_HEALTHCHECK_URL" || exit 1

ENTRYPOINT [ "/opt/koboldcpp/koboldcpp" ]
