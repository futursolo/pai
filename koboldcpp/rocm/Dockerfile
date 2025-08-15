ARG ROCM_IMAGE_VERSION=6.4.3-complete
ARG KOBALDCPP_ROCM_VERSION=v1.97.4.yr0-ROCm

FROM bitnami/git AS build-git

ARG KOBALDCPP_ROCM_VERSION

WORKDIR /opt/
RUN git clone --depth 1 \
    --branch ${KOBALDCPP_ROCM_VERSION} \
    https://github.com/YellowRoseCx/koboldcpp-rocm.git

FROM rocm/dev-ubuntu-24.04:${ROCM_IMAGE_VERSION} AS build-builder

RUN apt-get update && \
    apt-get install -y hipblas && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1999 docker-user && \
    useradd -m -s /bin/bash -u 1999 -g 1999 docker-user

RUN echo "docker-user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/999-docker-user

USER docker-user

RUN sudo apt-get update && \
    sudo apt-get install -y hipblas-dev build-essential

COPY --from=build-git --chown=docker-user:docker-user /opt/koboldcpp-rocm /opt/koboldcpp

WORKDIR /opt/koboldcpp

ARG ROCM_PATH=/opt/rocm
ARG ROCM_GPU_TARGETS="gfx803 gfx900 gfx906 gfx908 gfx90a gfx1010 gfx1030 gfx1031 gfx1032 gfx1100 gfx1101 gfx1102"

RUN make LLAMA_HIPBLAS=1 GPU_TARGETS="${ROCM_GPU_TARGETS}" ALLAMDGPUS=1 -j$(nproc)

RUN rm -rf .git

FROM rocm/dev-ubuntu-24.04:${ROCM_IMAGE_VERSION}

RUN apt-get update && \
    apt-get install -y hipblas && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1999 docker-user && \
    useradd -m -s /bin/bash -u 1999 -g 1999 docker-user

RUN echo "docker-user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/999-docker-user

USER docker-user

COPY --from=build-builder /opt/koboldcpp /opt/koboldcpp

WORKDIR /opt/koboldcpp

ENV ROCM_PATH=/opt/rocm

ENTRYPOINT [ "python3", "/opt/koboldcpp/koboldcpp.py" ]
