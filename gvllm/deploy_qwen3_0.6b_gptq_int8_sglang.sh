#!/bin/bash
set -e

export SGLANG_USE_MODELSCOPE=true
# export MODEL_NAME=Qwen/Qwen3-0.6B-GPTQ-Int8
export MODEL_NAME=Qwen/Qwen3-8B-AWQ

uv run python -m sglang.launch_server \
    --model-path $MODEL_NAME \
    --host 0.0.0.0 \
    --port 8000 \
    --mem-fraction-static 0.6 \
    --context-length 2048 \
    --served-model-name qwen \
    --tool-call-parser qwen3_coder \
    --chat-template ./qwen3_nonthinking.jinja
