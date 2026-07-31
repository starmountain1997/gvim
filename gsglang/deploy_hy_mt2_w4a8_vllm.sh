#!/bin/bash
set -e

export VLLM_USE_MODELSCOPE=true
export MODEL_NAME=/data1/model-agent-data/Hy-MT2-30B-A3B-W4A8

ASCEND_RT_VISIBLE_DEVICES=3 vllm serve $MODEL_NAME \
    --host 0.0.0.0 \
    --port 8004 \
    --tensor-parallel-size 1 \
    --max-model-len 2048 \
    --served-model-name qwen-w4a8
