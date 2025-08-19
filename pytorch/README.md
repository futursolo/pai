# PyTorch

Tensors and Dynamic neural networks in Python with strong GPU acceleration.

Base Repository: https://github.com/pytorch/pytorch

### Variants

- rocm: Supports AMD Radeon Graphics with ROCm Support

### Usage

\* This is usually used as a base image for other images. Not intended for end-user.

Conda is not used as it is too heavy for dependency management in a containerised environment. We can install any non-Python dependencies globally.

A VirtualEnv with PyTorch is created at `/opt/pytorch-env/`.
You can link PyTorch dependencies to new virtual environments with: `/common/scripts/python3-link-parent-venv.sh [parent env]` after activating the child env.
