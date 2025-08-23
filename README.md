# Pai - Portable Artificial Intelligence

The Pai (Portable Artificial Intelligence) Project is an initiative to produce a AI containers that can be run with a single command.

### Rationale

The primary purpose of this project is to reduce the burden to manage dependencies.
Since different application may require different ROCm or One-API versions,
this creates compatibility issues when trying to run multiple applications on the same machine.

This project solves this issue by packaging all necessary dependencies in the container and provides images
that can be executed with a single `docker run` command.

Unless specified otherwise, it should work with the `xe` or `amdgpu` driver from the mainline linux kernel.
Vendor drivers are optional.

### Supported Variants

The following variants are usually provided:

- `vulkan` (Any Vulkan Compatible GPUs)
- `intel` / `ipex` (Intel Arc)
- `rocm` (AMD Radeon)

\* CUDA is not supported because I currently do not have any NVIDIA Graphics Cards to test CUDA-based images
and CUDA-based images are usually already available from other sources.

### Supported Apps

- [KoboldCPP](./apps/koboldcpp/README.md)
  - `rocm`:`ghcr.io/futursolo/pai-apps/koboldcpp:rocm`
  - `vulkan`: `ghcr.io/futursolo/pai-apps/koboldcpp:vulkan`
- [ComfyUI](./apps/comfyui/README.md)
  - `rocm`: `ghcr.io/futursolo/pai-apps/comfyui:rocm`
  - `ipex`: `ghcr.io/futursolo/pai-apps/comfyui:ipex`
- [Ollama](./apps/ollama/README.md)
  - `intel`: `ghcr.io/futursolo/pai-apps/ollama:intel`

### Rootless Containers

All images are by default run with `pai-user:pai-user`(1999:1999) instead of root.
You may also specify containers with other uid and gid at runtime.
