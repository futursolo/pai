#!/bin/bash

set -ex

pip install --index-url https://download.pytorch.org/whl/rocm7.2 \
    torch==2.11.0 \
    torchvision==0.26.0 \
    torchaudio==2.11.0
