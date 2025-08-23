#!/usr/bin/env bash

set -ex

mkdir -p /opt/comfyui-base-tpl

mv /opt/comfyui/input /opt/comfyui-base-tpl/
mv /opt/comfyui/output /opt/comfyui-base-tpl/
mv /opt/comfyui/models /opt/comfyui-base-tpl/
mv /opt/comfyui/custom_nodes /opt/comfyui-base-tpl/
mv /opt/comfyui/temp /opt/comfyui-base-tpl/ || mkdir -p /opt/comfyui-base-tpl/temp
mv /opt/comfyui/user /opt/comfyui-base-tpl/ || mkdir -p /opt/comfyui-base-tpl/user
