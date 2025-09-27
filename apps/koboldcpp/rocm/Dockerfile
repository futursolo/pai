ARG ROCM_DEV_IMAGE=rocm/dev-ubuntu-24.04:7.0-complete
ARG BLAS_ROCM_BASE_IMAGE=ghcr.io/futursolo/pai-apps/base:blas-rocm-v7.0.0-preview
ARG KOBOLDCPP_ROCM_VERSION=v1.98.1.yr0-ROCm

FROM alpine/git:2.49.1 AS build-git

ARG KOBOLDCPP_ROCM_VERSION

WORKDIR /opt/
RUN git clone --depth 1 \
    --branch ${KOBOLDCPP_ROCM_VERSION} \
    https://github.com/YellowRoseCx/koboldcpp-rocm.git

FROM ${ROCM_DEV_IMAGE} AS build-koboldcpp

RUN --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    /tmp/_build/apt-pre.sh

RUN --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    /tmp/_build/apt-install-python3-dev.sh

COPY --from=build-git --chown=root:root /opt/koboldcpp-rocm /opt/koboldcpp

WORKDIR /opt/koboldcpp

ARG ROCM_PATH=/opt/rocm

ARG ROCM_GPU_TARGETS="gfx908 gfx90a gfx942 gfx950 gfx1030 gfx1100 gfx1101 gfx1151 gfx1200 gfx1201"

RUN make LLAMA_HIPBLAS=1 GPU_TARGETS="${ROCM_GPU_TARGETS}" -j$(nproc)

RUN rm -rf .git

RUN mkdir -p /opt/koboldcpp/dist
RUN cp -av *.py /opt/koboldcpp/dist/
RUN cp -av *.embd /opt/koboldcpp/dist/
RUN cp -av *.so /opt/koboldcpp/dist/
RUN cp -av *.md /opt/koboldcpp/dist/
RUN cp -av *.txt /opt/koboldcpp/dist/

WORKDIR /opt/koboldcpp/dist
RUN chmod +x ./koboldcpp.py
RUN ln -s ./koboldcpp.py ./koboldcpp

FROM ${BLAS_ROCM_BASE_IMAGE} AS build-final

COPY --from=build-koboldcpp /opt/koboldcpp/dist /opt/koboldcpp

USER pai-user

WORKDIR /opt/koboldcpp

SHELL ["/bin/bash", "-c"]

ENTRYPOINT [ "/opt/koboldcpp/koboldcpp" ]
