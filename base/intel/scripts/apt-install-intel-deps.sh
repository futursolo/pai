#!/usr/bin/env bash

set -ex

apt-get install -y --no-install-recommends intel-opencl-icd \
    libze-intel-gpu1 \
    libze1
