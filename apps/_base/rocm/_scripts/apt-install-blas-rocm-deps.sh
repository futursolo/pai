#!/usr/bin/env bash

set -ex

apt-get update
apt-get install -y --no-install-recommends rocm-hip-libraries
