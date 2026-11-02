#!/usr/bin/env bash

set -ex

apt-get install -y --no-install-recommends \
    libssl-dev \
    libgomp1 \
    ocl-icd-libopencl1

# https://github.com/intel/intel-graphics-compiler/releases
IGC_VERSION="v2.41.5"
IGC_VERSION_FULL="2_2.41.5+22716"

# https://github.com/intel/compute-runtime/releases
COMPUTE_RUNTIME_VERSION="26.35.39758.10"
COMPUTE_RUNTIME_VERSION_FULL="26.35.39758.10-0"
IGDGMM_VERSION="22.10.0"

# https://github.com/oneapi-src/level-zero/releases
LEVEL_ZERO_VERSION="1.34.0"
LEVEL_ZERO_UBUNTU_VERSION="u24.04"

TMP_DIR="/tmp/intel-icd"
mkdir --parents "${TMP_DIR}"
cd "${TMP_DIR}"

curl -fLO "https://github.com/intel/intel-graphics-compiler/releases/download/${IGC_VERSION}/intel-igc-core-${IGC_VERSION_FULL}_amd64.deb"
curl -fLO "https://github.com/intel/intel-graphics-compiler/releases/download/${IGC_VERSION}/intel-igc-opencl-${IGC_VERSION_FULL}_amd64.deb"
curl -fLO "https://github.com/intel/compute-runtime/releases/download/${COMPUTE_RUNTIME_VERSION}/intel-ocloc_${COMPUTE_RUNTIME_VERSION_FULL}_amd64.deb"
curl -fLO "https://github.com/intel/compute-runtime/releases/download/${COMPUTE_RUNTIME_VERSION}/intel-opencl-icd_${COMPUTE_RUNTIME_VERSION_FULL}_amd64.deb"
curl -fLO "https://github.com/intel/compute-runtime/releases/download/${COMPUTE_RUNTIME_VERSION}/libigdgmm12_${IGDGMM_VERSION}_amd64.deb"
curl -fLO "https://github.com/intel/compute-runtime/releases/download/${COMPUTE_RUNTIME_VERSION}/libze-intel-gpu1_${COMPUTE_RUNTIME_VERSION_FULL}_amd64.deb"
curl -fLO "https://github.com/oneapi-src/level-zero/releases/download/v${LEVEL_ZERO_VERSION}/libze1_${LEVEL_ZERO_VERSION}%2B${LEVEL_ZERO_UBUNTU_VERSION}_amd64.deb"
curl -fLO "https://github.com/oneapi-src/level-zero/releases/download/v${LEVEL_ZERO_VERSION}/libze-dev_${LEVEL_ZERO_VERSION}%2B${LEVEL_ZERO_UBUNTU_VERSION}_amd64.deb"

apt-get -o Dpkg::Options::="--force-overwrite" install -y --no-install-recommends ./*.deb

rm -rf "${TMP_DIR}"
