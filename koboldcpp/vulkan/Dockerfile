ARG KOBOLDCPP_VERSION=v1.97.4

FROM curlimages/curl:8.15.0 AS build-curl

ARG KOBOLDCPP_VERSION

WORKDIR /tmp

RUN curl -O -L \
    https://github.com/LostRuins/koboldcpp/releases/download/${KOBOLDCPP_VERSION}/koboldcpp-linux-x64-nocuda

FROM ubuntu:24.04 AS build-final

RUN mkdir -p /opt/build
COPY ./common/ /opt/build/common

WORKDIR /opt/build

RUN /opt/build/common/scripts/apt-pre.sh
RUN /opt/build/common/scripts/apt-install-sudo.sh
RUN /opt/build/common/scripts/apt-install-vulkan-deps.sh

RUN /opt/build/common/scripts/create-docker-user.sh

RUN /opt/build/common/scripts/apt-post.sh
RUN /opt/build/common/scripts/cleanup-build.sh

RUN mkdir -p /opt/koboldcpp
COPY --from=build-curl /tmp/koboldcpp-linux-x64-nocuda /opt/koboldcpp/koboldcpp

RUN chmod +x /opt/koboldcpp/koboldcpp

FROM scratch

COPY --from=build-final / /

USER docker-user

WORKDIR /opt/koboldcpp

SHELL ["/bin/bash", "-c"]

ENTRYPOINT [ "/opt/koboldcpp/koboldcpp" ]
