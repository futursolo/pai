#!/bin/bash

set -ex

PARENT_PYTHON_PATH="$1"/bin/python3;

realpath $($PARENT_PYTHON_PATH -c "import site; print(site.getsitepackages()[0])") \
    > $(python3 -c "import site; print(site.getsitepackages()[0])")/base_venv.pth
