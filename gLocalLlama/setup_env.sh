#!/usr/bin/env bash
# One-time setup: create conda env and install vLLM + flash-attn + modelscope

set -euo pipefail

CONDA_ENV="localLlama"
PYTHON_VERSION="3.11"
CUDA_VERSION="12.1"   # adjust to match your driver (check: nvidia-smi)

# shellcheck disable=SC1091
source "$(conda info --base)/etc/profile.d/conda.sh"

if conda env list | grep -q "^${CONDA_ENV} "; then
    echo "[INFO] Conda env '${CONDA_ENV}' already exists, skipping creation."
else
    echo "[INFO] Creating conda env '${CONDA_ENV}' with Python ${PYTHON_VERSION}..."
    conda create -y -n "${CONDA_ENV}" python="${PYTHON_VERSION}"
fi

conda activate "${CONDA_ENV}"

echo "[INFO] Installing vLLM (CUDA ${CUDA_VERSION})..."
pip install vllm --extra-index-url "https://download.pytorch.org/whl/cu${CUDA_VERSION//./}"

echo "[INFO] Installing ModelScope..."
pip install modelscope

echo "[INFO] Setup complete. Run ./serve_qwen25_14b.sh to start the server."
