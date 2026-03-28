#!/usr/bin/env bash
# Serve Qwen2.5-14B-Instruct-AWQ via vLLM with flash-attn
# Download source: ModelScope
# Env manager: conda

set -euo pipefail

# ── Configuration ──────────────────────────────────────────────────────────────
CONDA_ENV="localLlama"
MODEL_ID="Qwen/Qwen2.5-7B-Instruct-AWQ"

HOST="0.0.0.0"
PORT=8000
TENSOR_PARALLEL=1          # increase if using multi-GPU
MAX_MODEL_LEN=32768
GPU_MEM_UTILIZATION=0.90
# ───────────────────────────────────────────────────────────────────────────────

# Activate conda env
# shellcheck disable=SC1091
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "${CONDA_ENV}"

# Force vLLM to use flash-attention backend
export VLLM_ATTENTION_BACKEND=FLASH_ATTN

# Use ModelScope as the model source (vLLM will download automatically if needed)
export VLLM_USE_MODELSCOPE=True

# ── Step 1: Launch vLLM server ─────────────────────────────────────────────────
echo "[INFO] Starting vLLM OpenAI-compatible server on ${HOST}:${PORT} ..."

python -m vllm.entrypoints.openai.api_server \
    --model "${MODEL_ID}" \
    --served-model-name "qwen" \
    --host "${HOST}" \
    --port "${PORT}" \
    --quantization awq \
    --dtype float16 \
    --tensor-parallel-size "${TENSOR_PARALLEL}" \
    --max-model-len "${MAX_MODEL_LEN}" \
    --gpu-memory-utilization "${GPU_MEM_UTILIZATION}" \
    --enable-prefix-caching \
    --max-num-seqs 32 \
    --trust-remote-code
