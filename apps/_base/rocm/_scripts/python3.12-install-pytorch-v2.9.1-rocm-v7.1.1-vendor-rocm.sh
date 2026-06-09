#!/bin/bash

set -ex

pip3 install torch==2.9.1 torchvision==0.24.1 torchaudio==2.9.1 -f https://repo.radeon.com/rocm/manylinux/rocm-rel-7.1.1/
