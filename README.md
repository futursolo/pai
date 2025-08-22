# Portable AI

Collection of AI Containers - Prebuilt and Ready-to-Use

### Rationale

The primary purpose of this project is to reduce the burden to manage dependencies.
Since different application may require different ROCm or One-API versions,
this creates compatibility issues when trying to run multiple applications on the same machine.

This project solves this issue by packaging all necessary dependencies in the docker container and provides images
that can be executed with a single `docker run` command.

Unless specified otherwise, it should work with the `xe` or `amdgpu` driver from the mainline kernel.
Vendor drivers are optional.

### Supported Variants

The following variants are usually provided:

- `vulkan` (Any Vulkan Compatible GPUs)
- `intel` / `ipex` (Intel Arc)
- `rocm` (AMD Radeon)

\* CUDA is not supported because I currently do not have any NVIDIA Graphics Cards to test CUDA-based images
and CUDA-based images are usually already available from other sources.

### Supported Images

- [KoboldCPP](./koboldcpp/README.md)
   - `rocm`:`ghcr.io/futursolo/portable-ai/koboldcpp:rocm`
   - `vulkan`: `ghcr.io/futursolo/portable-ai/koboldcpp:vulkan`
- [ComfyUI](./comfyui/README.md)
   - `rocm`: `ghcr.io/futursolo/portable-ai/comfyui:rocm`
   - `ipex`: `ghcr.io/futursolo/portable-ai/comfyui:ipex`
- [Ollama](./ollama/README.md)
   - `intel`: `ghcr.io/futursolo/portable-ai/ollama:intel`

### Non-root Images

All images are by default run with `docker-user:docker-user`(1999:1999) instead of root.
