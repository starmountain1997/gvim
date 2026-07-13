#!/bin/bash
set -e

export SGLANG_USE_MODELSCOPE=true
export MODEL_NAME=Qwen/Qwen3-Embedding-0.6B

uv run python -m sglang.launch_server \
    --model-path $MODEL_NAME \
    --host 0.0.0.0 \
    --port 8001 \
    --mem-fraction-static 0.7 \
    --context-length 2048 \
    --trust-remote-code \
    --is-embedding
