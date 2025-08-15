# KoboldCPP

Run GGUF models easily with a KoboldAI UI.

### Variants

- rocm: Supported AMD Radeon Graphics

  Base Repository: https://github.com/YellowRoseCx/koboldcpp-rocm/

### Usage

See: `[variant]/docker-compose.example.yml`

### Difference comparing to Official Image

Comparing to Official Image, this image:

1. Embeds all necessary files in the image and doesn't download any content on startup.
2. Downloads a tagged version of the application.
3. Does not start Cloudflared by default.
4. Provides rocm variant from the ROCm fork ([YellowRoseCx/koboldcpp-rocm](https://github.com/YellowRoseCx/koboldcpp-rocm/)).
