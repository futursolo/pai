ARG ROCM_DEV_IMAGE=rocm/dev-ubuntu-24.04:6.4.3-complete
ARG BLAS_ROCM_BASE_IMAGE=ghcr.io/futursolo/pai-apps/base:blas-rocm-v6.4.3-20250823
ARG KOBOLDCPP_ROCM_VERSION=v1.97.4.yr0-ROCm

FROM bitnami/git:2.51.0 AS build-git

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
ARG ROCM_GPU_TARGETS="gfx803 gfx900 gfx906 gfx908 gfx90a gfx1010 gfx1030 gfx1031 gfx1032 gfx1100 gfx1101 gfx1102 gfx1200 gfx1201"

RUN make LLAMA_HIPBLAS=1 GPU_TARGETS="${ROCM_GPU_TARGETS}" ALLAMDGPUS=1 -j$(nproc)

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

# TODO: Remove once base image has render group
RUN  --mount=type=bind,source=./_base/_scripts/,target=/tmp/_build/ \
    /tmp/_build/create-render-group.sh

USER pai-user

WORKDIR /opt/koboldcpp

SHELL ["/bin/bash", "-c"]

ENV PATH=/opt/rocm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENTRYPOINT [ "/opt/koboldcpp/koboldcpp" ]
