#!/usr/bin/env bash
# Serve Qwen2.5-7B-Instruct-AWQ via vLLM with flash-attn
# Optimized for short-sequence, high-concurrency workloads
# Download source: ModelScope
# Env manager: conda

set -euo pipefail

# ── Configuration ──────────────────────────────────────────────────────────────
CONDA_ENV="localLlama"
MODEL_ID="Qwen/Qwen2.5-7B-Instruct-AWQ"

HOST="0.0.0.0"
PORT=8000
TENSOR_PARALLEL=1          # increase if using multi-GPU
MAX_MODEL_LEN=4096         # short-sequence: shrinks KV cache footprint, frees memory for more concurrent slots
MAX_NUM_SEQS=30            # max concurrent requests in flight
MAX_BATCHED_TOKENS=8192    # cap per-batch tokens; keeps p99 latency stable under burst traffic
GPU_MEM_UTILIZATION=0.90
# ───────────────────────────────────────────────────────────────────────────────

# Activate conda env
# shellcheck disable=SC1091
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "${CONDA_ENV}"

# Use ModelScope as the model source (vLLM will download automatically if needed)
export VLLM_USE_MODELSCOPE=True

# ── Step 1: Launch vLLM server ─────────────────────────────────────────────────
echo "[INFO] Starting vLLM OpenAI-compatible server on ${HOST}:${PORT} ..."

python -m vllm.entrypoints.openai.api_server \
    --model "${MODEL_ID}" \
    --served-model-name "qwen" \
    --host "${HOST}" \
    --port "${PORT}" \
    --quantization awq_marlin \
    --dtype float16 \
    --tensor-parallel-size "${TENSOR_PARALLEL}" \
    --max-model-len "${MAX_MODEL_LEN}" \
    --gpu-memory-utilization "${GPU_MEM_UTILIZATION}" \
    --enable-prefix-caching \
    --max-num-seqs "${MAX_NUM_SEQS}" \
    --max-num-batched-tokens "${MAX_BATCHED_TOKENS}" \
    --no-enable-log-requests \
    --trust-remote-code
