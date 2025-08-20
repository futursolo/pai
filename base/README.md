# Base Images

### Variants

- pytorch-rocm: Supports AMD Radeon Graphics with ROCm Support

  **Pytorch w/ ROCm Backend**\
  Base Repository: https://github.com/pytorch/pytorch

  Tensors and Dynamic neural networks in Python with strong GPU acceleration.

- pytorch-ipex: Supports Intel Graphcis with IPEX Support

  **Pytorch w/ IPEX Backend**\
  Base Repository: https://github.com/pytorch/pytorch

  Tensors and Dynamic neural networks in Python with strong GPU acceleration.

### Usage

Variants under this image are used as base images during the building process or as part of the final image.

This reduces build time and/or download time for subsequent image pulls.
