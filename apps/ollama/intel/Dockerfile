ARG INTEL_BASE_IMAGE=ghcr.io/futursolo/pai-apps/base:intel-20250823
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

COPY ./ollama/intel/_scripts/ollama-shim /bin/ollama

RUN mkdir -p /mnt/data
RUN chown pai-user:pai-user /mnt/data

USER pai-user

ENV OLLAMA_MODELS=/mnt/data

VOLUME [ "/home/docker-user/.ollama" ]

WORKDIR /opt/ollama/

SHELL [ "/bin/bash", "-c" ]

ENTRYPOINT [ "/bin/ollama" ]

CMD [ "serve" ]
