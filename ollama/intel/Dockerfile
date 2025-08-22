ARG INTEL_BASE_IMAGE=ghcr.io/futursolo/portable-ai/base:intel-20250822
ARG IPEX_LLM_VERSION=v2.3.0-nightly
ARG OLLAMA_IPEX_LLM_VERSION=2.3.0b20250725

FROM ubuntu:24.04 AS build-ollama

ARG IPEX_LLM_VERSION
ARG OLLAMA_IPEX_LLM_VERSION

RUN mkdir /tmp/ollama/

WORKDIR /tmp/ollama/

ADD https://github.com/ipex-llm/ipex-llm/releases/download/${IPEX_LLM_VERSION}/ollama-ipex-llm-${OLLAMA_IPEX_LLM_VERSION}-ubuntu.tgz \
    /tmp/ollama/

RUN tar -zxvf *.tgz

RUN rm -rf *.tgz

RUN mv ollama-* ollama

FROM ${INTEL_BASE_IMAGE} AS build-final

USER root

COPY --from=build-ollama /tmp/ollama/ollama /opt/ollama/

USER docker-user

RUN mkdir -p /home/docker-user/.ollama

VOLUME [ "/home/docker-user/.ollama" ]

WORKDIR /opt/ollama/

SHELL [ "/bin/bash", "-c" ]

RUN ln -s /opt/ollama/ollama /bin/

ENTRYPOINT [ "/bin/ollama" ]

CMD [ "serve" ]
