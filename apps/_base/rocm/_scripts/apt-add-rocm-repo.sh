#!/usr/bin/env bash

set -ex

apt-get install -y ca-certificates curl gnupg

mkdir --parents --mode=0755 /etc/apt/keyrings

curl https://repo.radeon.com/rocm/rocm.gpg.key | \
    gpg --dearmor > /etc/apt/keyrings/rocm.gpg

tee /etc/apt/sources.list.d/rocm.list << EOF
deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/${ROCM_VERSION} noble main
deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/graphics/${ROCM_VERSION}/ubuntu noble main
EOF

tee /etc/apt/preferences.d/rocm-pin-600 << EOF
Package: *
Pin: release o=repo.radeon.com
Pin-Priority: 600
EOF
