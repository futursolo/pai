ARG IPEX_LLM_VERSION=v2.3.0-nightly
ARG OLLAMA_IPEX_LLM_VERSION=2.3.0b20250725

FROM ubuntu:24.04 AS build-ollama

ARG IPEX_LLM_VERSION
ARG OLLAMA_IPEX_LLM_VERSION

RUN --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    /tmp/_build/apt-pre.sh

RUN apt-get install

ADD https://github.com/ipex-llm/ipex-llm/releases/download/\
    ${IPEX_LLM_VERSION}/\
    ollama-ipex-llm-${OLLAMA_IPEX_LLM_VERSION}-ubuntu.tgz /tmp/

WORKDIR /tmp/

RUN tar -zxvf ollama-ipex-llm-${OLLAMA_IPEX_LLM_VERSION}-ubuntu.tgz

RUN ls * && exit 1

FROM ubuntu:24.04 AS build-final

RUN  --mount=type=bind,source=./common/scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh && \
    /tmp/_build/apt-install-python3-dev.sh && \
    /tmp/_build/create-docker-user.sh

COPY --from=build-ollama /tmp/ollama /opt/ollama/
