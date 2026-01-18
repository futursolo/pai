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

### Permissions and Capabilities

In order for containers to access necessary accelerators, the following configuration is required:

#### ROCm

The container must have access to the following devices:

- `/dev/dri` (Direct Rendering Infrastructure)
- `/dev/kfd` (AMD Kernel Fusion Driver)

They can be mapped like the following in the `docker-compose.yml`:

```yaml
services:
  app:
    # ...
    devices:
      - /dev/dri
      - /dev/kfd
```

The user inside container must have access to the following groups:

- `video`
  - This group usually has a fixed Group ID (44) and is embedded in the container, it can be referenced as name of the container.
- `render`
  - This group has a dynamic Group ID and it must match the host environment.
  - You can figure this out with: `getent group render | awk '{split($0,a,":"); print a[3]}'`

They can be added like the following in the `docker-compose.yml`:

```yaml
services:
  app:
    # ...
    group_add:
      - video
      - $GROUP_ID_RENDER # This must match the group id of machine that runs the container, see above.
```

Optionally, the container can enable CPU / GPU memory mapping to improve performance.

It can be configured like the following in the `docker-compose.yml`:

```yaml
services:
  app:
    # ...
    security_opt:
      - seccomp:unconfined
```

Optionally, the container can increase the shared memory size to improve performance.

It can be configured like the following in the `docker-compose.yml`:

```yaml
services:
  app:
    # ...
    shm_size: 16G
```

#### Intel / IPEX

The container must have access to the following devices:

- `/dev/dri` (Direct Rendering Infrastructure)

They can be mapped like the following in the `docker-compose.yml`:

```yaml
services:
  app:
    # ...
    devices:
      - /dev/dri
```

The user inside container must have access to the following groups:

- `video`
  - This group usually has a fixed Group ID (44) and is embedded in the container, it can be referenced as name of the container.
- `render`
  - This group has a dynamic Group ID and it must match the host environment.
  - You can figure this out with: `getent group render | awk '{split($0,a,":"); print a[3]}'`

They can be added like the following in the `docker-compose.yml`:

```yaml
services:
  app:
    # ...
    group_add:
      - video
      - $GROUP_ID_RENDER # This must match the group id of machine that runs the container, see above.
```

Optionally, the container can enable CPU / GPU memory mapping to improve performance.

It can be configured like the following in the `docker-compose.yml`:

```yaml
services:
  app:
    # ...
    security_opt:
      - seccomp:unconfined
```

Optionally, the container can increase the shared memory size to improve performance.

It can be configured like the following in the `docker-compose.yml`:

```yaml
services:
  app:
    # ...
    shm_size: 16G
```

For containers running under WSL2 (Windows Subsystem for Linux), you need the following configuration:

```yaml
services:
  app:
    # ...
    privileged: true
    volumes:
      - /usr/lib/wsl:/usr/lib/wsl
```

### Rootless Containers

All images are by default run with `pai-user:pai-user`(1999:1999) instead of root.
You may also specify containers with other uid and gid at runtime.
