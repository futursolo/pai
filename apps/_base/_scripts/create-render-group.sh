#!/usr/bin/env bash

set -ex

if [ ! $(getent group render) ]; then
    groupadd -g 993 render
fi
