# KoboldCPP

Run GGUF models easily with a KoboldAI UI.

Base Repository: https://github.com/LostRuins/koboldcpp/

### Variants

- `rocm`: Supports AMD Radeon Graphics with ROCm Support\
  URI: `ghcr.io/futursolo/pai-apps/koboldcpp:rocm`

- `vulkan`: Supports any Vulkan-compatible Graphics Card\
  URI: `ghcr.io/futursolo/pai-apps/koboldcpp:vulkan`

### Usage

See: `[variant]/docker-compose.example.yml`

### Difference comparing to Official Image

Comparing to Official Image, this image:

1. Embeds all necessary files in the image and doesn't download any content on startup.
2. Downloads a tagged version of the application.
3. Does not start Cloudflared by default.
