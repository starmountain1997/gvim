#!/bin/bash
set -e

export VLLM_USE_MODELSCOPE=true
export MODEL_NAME=/data1/model-agent-data/Hy-MT2-7B
export ASCEND_RT_VISIBLE_DEVICES=1

vllm serve $MODEL_NAME \
    --host 0.0.0.0 \
    --port 8001 \
    --max-model-len 2048 \
    --served-model-name qwen
