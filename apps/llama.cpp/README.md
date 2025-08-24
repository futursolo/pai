# llama.cpp

LLM inference in C/C++

Base Repository: https://github.com/ggml-org/llama.cpp

### Variants

- `rocm`: Supports AMD Radeon Graphics with ROCm Support\
  URI: `ghcr.io/futursolo/pai-apps/llama.cpp:rocm`

### Usage

See: `[variant]/docker-compose.example.yml`

### Difference comparing to Official Image

Comparing to Official Image, this image:

1. Stores the app to `/opt/llama.cpp` instead of `/app`.
2. Uses `pai-user` as the user to execute the container.
3. Only an official `full` variant equivalent is provided.
4. This image is built on a roughly weekly basis since llama.cpp releases very frequently.
