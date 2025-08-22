#!/usr/bin/env bash

set -ex

rm -f /etc/apt/apt.conf.d/docker-clean

apt-get update
