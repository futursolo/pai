#!/bin/bash

set -ex

pip install --index-url https://download.pytorch.org/whl/rocm6.4 \
    torch==2.8.0 \
    torchvision==0.23.0 \
    torchaudio==2.8.0
