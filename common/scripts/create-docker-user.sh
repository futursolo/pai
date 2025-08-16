#!/usr/bin/env bash

set -ex

groupadd -g 1999 docker-user
useradd -m -s /bin/bash -u 1999 -g 1999 docker-user

echo "docker-user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/999-docker-user
