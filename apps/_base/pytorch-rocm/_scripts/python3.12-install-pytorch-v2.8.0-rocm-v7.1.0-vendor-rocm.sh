#!/bin/bash

set -ex

pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-7.1/triton-3.4.0%2Brocm7.1.0.gitf9e5bf54-cp312-cp312-linux_x86_64.whl
pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-7.1/torch-2.8.0%2Brocm7.1.0.lw.git7a520360-cp312-cp312-linux_x86_64.whl
pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-7.1/torchvision-0.23.0%2Brocm7.1.0.git824e8c87-cp312-cp312-linux_x86_64.whl
pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-7.1/torchaudio-2.8.0%2Brocm7.1.0.git6e1c7fe9-cp312-cp312-linux_x86_64.whl

