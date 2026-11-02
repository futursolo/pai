#!/bin/bash

set -ex

pip install --index-url https://download.pytorch.org/whl/xpu \
    torch==2.14.1 \
    torchvision==0.29.2 \
    torchaudio==2.11.1
