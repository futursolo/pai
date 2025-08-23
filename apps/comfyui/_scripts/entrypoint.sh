#!/usr/bin/env bash

set -e

if [ -z "$(ls -A $COMFYUI_BASE_DIR)" ]; then
    echo "Initialising Data Directory..."
    cp -ar /opt/comfyui-base-tpl/ $COMFYUI_BASE_DIR/
fi

mkdir -p $COMFYUI_BASE_DIR/input
mkdir -p $COMFYUI_BASE_DIR/output
mkdir -p $COMFYUI_BASE_DIR/models
mkdir -p $COMFYUI_BASE_DIR/custom_nodes
mkdir -p $COMFYUI_BASE_DIR/temp
mkdir -p $COMFYUI_BASE_DIR/user

python3 main.py \
    --listen ${COMFYUI_LISTEN} \
    --base-directory ${COMFYUI_BASE_DIR} \
    --database-url ${COMFYUI_DB_URL} \
    "$@"
