#!/bin/bash

set -ex

pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-7.0/pytorch_triton_rocm-3.4.0%2Brocm7.0.0.gitf9e5bf54-cp312-cp312-linux_x86_64.whl
pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-7.0/torch-2.8.0%2Brocm7.0.0.git64359f59-cp312-cp312-linux_x86_64.whl
pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-7.0/torchvision-0.24.0%2Brocm7.0.0.gitf52c4f1a-cp312-cp312-linux_x86_64.whl
pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-7.0/torchaudio-2.8.0%2Brocm7.0.0.git6e1c7fe9-cp312-cp312-linux_x86_64.whl
