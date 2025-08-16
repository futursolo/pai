#!/usr/bin/env bash

set -ex

apt-get install -y ca-certificates curl gnupg

mkdir --parents --mode=0755 /etc/apt/keyrings

curl https://repo.radeon.com/rocm/rocm.gpg.key | \
    gpg --dearmor > /etc/apt/keyrings/rocm.gpg

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/${ROCM_VERSION} noble main" \
    > /etc/apt/sources.list.d/rocm.list
echo 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' \
    > /etc/apt/preferences.d/rocm-pin-600
