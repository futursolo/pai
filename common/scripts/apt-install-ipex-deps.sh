#!/usr/bin/env bash

set -ex

apt-get install -y intel-opencl-icd \
    libze-intel-gpu1 \
    libze1
