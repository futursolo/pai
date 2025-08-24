#!/usr/bin/env bash

set -ex

getent group render || groupadd -g 993 render
