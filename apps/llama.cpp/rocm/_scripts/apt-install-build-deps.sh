#!/usr/bin/env bash

set -ex

apt-get install -y \
    build-essential \
    cmake \
    git \
    libcurl4-openssl-dev \
    curl \
    libgomp1
