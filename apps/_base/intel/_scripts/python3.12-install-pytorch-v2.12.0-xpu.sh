#!/bin/bash

set -ex

pip install --index-url https://download.pytorch.org/whl/xpu \
    torch==2.12.0 \
    torchvision==0.27.0 \
    torchaudio==2.12.0
