ARG ROCM_DEV_IMAGE=rocm/dev-ubuntu-24.04:6.4.3-complete
ARG BLAS_ROCM_BASE_IMAGE=ghcr.io/futursolo/pai-apps/base:blas-rocm-v6.4.3-20250823
ARG LLAMA_CPP_VERSION=b6257

FROM bitnami/git:2.51.0 AS build-git

ARG LLAMA_CPP_VERSION

WORKDIR /opt/
RUN git clone --depth 1 \
    --branch ${LLAMA_CPP_VERSION} \
    https://github.com/ggml-org/llama.cpp


FROM ${BLAS_ROCM_BASE_IMAGE} AS build-llama-cpp-env

RUN python3 -m venv /opt/llama.cpp-env/

COPY --from=build-git --chown=root:root /opt/llama.cpp/requirements.txt /tmp/requirements.txt
COPY --from=build-git --chown=root:root /opt/llama.cpp/requirements /tmp/requirements

RUN env \
    PATH="/opt/llama.cpp-env/bin:$PATH" \
    pip install -r /tmp/requirements.txt

FROM ${ROCM_DEV_IMAGE} AS build-llama-cpp

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh

RUN  --mount=type=bind,source=./llama.cpp/rocm/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-install-build-deps.sh

COPY --from=build-git --chown=root:root /opt/llama.cpp /opt/llama.cpp

WORKDIR /opt/llama.cpp

ARG ROCM_PATH=/opt/rocm
ARG ROCM_GPU_TARGETS="gfx803,gfx900,gfx906,gfx908,gfx90a,gfx1010,gfx1030,gfx1031,gfx1032,gfx1100,gfx1101,gfx1102,gfx1200,gfx1201"

RUN HIPCXX="$(hipconfig -l)/clang" HIP_PATH="$(hipconfig -R)" \
    cmake -S . -B build -DGGML_HIP=ON -DAMDGPU_TARGETS=$ROCM_GPU_TARGETS -DGGML_BACKEND_DL=ON -DGGML_CPU_ALL_VARIANTS=ON -DCMAKE_BUILD_TYPE=Release -DLLAMA_BUILD_TESTS=OFF \
    && cmake --build build --config Release -j$(nproc)

RUN mkdir -p ./app/lib \
    && find build -name "*.so" -exec cp {} ./app/lib \;

RUN mkdir -p ./app/full \
    && cp build/bin/* ./app/full \
    && cp *.py ./app/full \
    && cp -r gguf-py ./app/full \
    && cp .devops/tools.sh ./app/full/tools.sh

FROM ${BLAS_ROCM_BASE_IMAGE} AS build-final

RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-pre.sh

RUN  --mount=type=bind,source=./llama.cpp/rocm/_scripts/,target=/tmp/_build/ \
    --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    /tmp/_build/apt-install-llama-cpp-deps.sh

COPY --from=build-llama-cpp-env /opt/llama.cpp-env /opt/llama.cpp-env
COPY --from=build-llama-cpp /opt/llama.cpp/app/lib /opt/llama.cpp
COPY --from=build-llama-cpp /opt/llama.cpp/app/full /opt/llama.cpp

USER pai-user

WORKDIR /opt/llama.cpp

SHELL [ "/bin/bash", "-c" ]

ENV ROCM_PATH=/opt/rocm
ENV PATH=/opt/llama.cpp-env/bin:/opt/llama.cpp/:/opt/rocm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=/opt/rocm/lib

ENTRYPOINT [ "/opt/llama.cpp/tools.sh" ]
