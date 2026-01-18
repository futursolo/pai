ARG VULKAN_BASE_IMAGE=ghcr.io/futursolo/pai-apps/base:vulkan-20250823

ARG KOBOLDCPP_VERSION=v1.106.1

FROM ubuntu:24.04 AS build-koboldcpp

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

ENTRYPOINT [ "/opt/koboldcpp/koboldcpp" ]
