#!/bin/bash
set -e

export VLLM_USE_MODELSCOPE=true


uv run python -m vllm.entrypoints.openai.api_server \
    --model Qwen/Qwen3-0.6B-GPTQ-Int8 \
    --host 0.0.0.0 \
    --port 8000 \
    --gpu-memory-utilization 0.5 \
    --max-model-len 2048 \
    --served-model-name qwen \
    --enable-auto-tool-choice \
    --tool-call-parser qwen3_xml \
    --chat-template ./qwen3_nonthinking.jinja
