#!/bin/bash
set -e

export SGLANG_USING_MODELSCOPE="true"
export SGLANG_PORT="8000"
export SGLANG_HOST="0.0.0.0"

model="Qwen/Qwen3-0.6B-GPTQ-Int8"

echo "Starting SGLang server with $model"
echo "Host: $SGLANG_HOST | Port: $SGLANG_PORT"

python -m sglang.launch_server \
    --model-path "$model" \
    --port "$SGLANG_PORT" \
    --host "$SGLANG_HOST" \
    --chat-template ./qwen3_nonthinking.jinja
