#!/usr/bin/env bash

set -ex

apt-get install -y ca-certificates curl gnupg

mkdir --parents --mode=0755 /usr/share/keyrings

# OneAPI
curl -fsSL https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB | \
  gpg --dearmor > /usr/share/keyrings/intel-oneapi-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/intel-oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main " \
    > /etc/apt/sources.list.d/oneapi.list

# Intel Graphics Driver
curl -fsSL https://repositories.intel.com/gpu/intel-graphics.key | \
    gpg --dearmor > /usr/share/keyrings/intel-graphics-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/intel-graphics-archive-keyring.gpg arch=amd64] https://repositories.intel.com/gpu/ubuntu noble unified" \
    > /etc/apt/sources.list.d/intel-graphics.list
