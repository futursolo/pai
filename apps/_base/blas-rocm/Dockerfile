ARG ROCM_DEV_IMAGE=rocm/dev-ubuntu-24.04:7.1-complete
ARG ROCM_BASE_IMAGE=ghcr.io/futursolo/pai-apps/base:rocm-v7.1.0-20251108

FROM ${ROCM_DEV_IMAGE} AS build-rocm-blas

RUN mkdir -p /opt/rocm-blas-extras/lib/
RUN cp -av /opt/rocm/lib/libhipblas.so* /opt/rocm-blas-extras/lib/
RUN cp -av /opt/rocm/lib/librocblas.so* /opt/rocm-blas-extras/lib/
RUN cp -av /opt/rocm/lib/librocsolver.so* /opt/rocm-blas-extras/lib/
RUN cp -av /opt/rocm/lib/libhipblaslt.so* /opt/rocm-blas-extras/lib/
RUN cp -av /opt/rocm/lib/librocroller.so* /opt/rocm-blas-extras/lib/

FROM ${ROCM_BASE_IMAGE} AS build-final

COPY --from=build-rocm-blas /opt/rocm-blas-extras/ /opt/rocm/
COPY --from=build-rocm-blas /opt/rocm/lib/rocblas/ /opt/rocm/lib/rocblas/
COPY --from=build-rocm-blas /opt/rocm/lib/hipblaslt/ /opt/rocm/lib/hipblaslt/
