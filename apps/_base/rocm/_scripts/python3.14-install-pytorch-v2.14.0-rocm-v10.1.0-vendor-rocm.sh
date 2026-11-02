#!/bin/bash

set -ex

pip install --index-url https://stable.repo.amd.com/rocm/whl-next/ \
    "torch[device-all]==2.14.0+rocm10.1.0" \
    "torchvision[device-all]==0.29.0a0+rocm10.1.0" \
    "torchaudio==2.11.0.3+rocm10.1.0"
