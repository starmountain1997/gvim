#!/bin/bash
set -e

export SGLANG_USE_MODELSCOPE=true
export MODEL_NAME=Tencent-Hunyuan/Hy-MT2-1.8B

sglang serve \
    --model-path $MODEL_NAME \
    --host 0.0.0.0 \
    --port 8000 \
    --mem-fraction-static 0.7 \
    --context-length 4096
