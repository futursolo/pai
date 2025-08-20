#!/bin/bash

set -ex

pip install --index-url https://download.pytorch.org/whl/xpu \
    torch==2.8.0 \
    torchvision==0.23.0 \
    torchaudio==2.8.0

pip install --extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/us/ \
    intel-extension-for-pytorch==2.8.10+xpu \
    oneccl_bind_pt==2.8.0+xpu
