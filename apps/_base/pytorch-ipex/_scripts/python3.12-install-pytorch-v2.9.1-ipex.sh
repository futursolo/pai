#!/bin/bash

set -ex

pip install --index-url https://download.pytorch.org/whl/xpu \
    torch==2.9.1 \
    torchvision==0.24.1 \
    torchaudio==2.9.1
