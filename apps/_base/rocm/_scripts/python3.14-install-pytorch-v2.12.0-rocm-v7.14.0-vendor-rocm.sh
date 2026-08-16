#!/bin/bash

set -ex

pip install --index-url https://repo.amd.com/rocm/whl-multi-arch/ \
    "torch[device-all]==2.12.0+rocm7.14.0" \
    "torchvision[device-all]==0.27.0+rocm7.14.0" \
    "torchaudio==2.11.0+rocm7.14.0"
