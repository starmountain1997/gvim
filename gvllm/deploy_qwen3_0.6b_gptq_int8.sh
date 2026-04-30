#!/bin/bash
set -e

# sudo pacman -S numactl
export HF_ENDPOINT=https://127.0.0.1
export SGLANG_USE_MODELSCOPE=true
export SGLANG_PORT="8000"
export SGLANG_HOST="0.0.0.0"
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
export PATH=/opt/cuda/bin:$PATH

model="Qwen/Qwen3-0.6B-GPTQ-Int8"

echo "Starting SGLang server with $model"
echo "Host: $SGLANG_HOST | Port: $SGLANG_PORT"

uv run python -m sglang.launch_server \
    --model-path "$model" \
    --port "$SGLANG_PORT" \
    --host "$SGLANG_HOST" \
    --mem-fraction-static 0.7 \
    --context-length 1024 \
    --chat-template ./qwen3_nonthinking.jinja
