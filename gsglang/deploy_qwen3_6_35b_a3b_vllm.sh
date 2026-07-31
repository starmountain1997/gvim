#!/bin/bash
set -e

export VLLM_USE_MODELSCOPE=true
export MODEL_ID=Qwen/Qwen3.6-35B-A3B
export MODEL_NAME=/data1/model-agent-data/Qwen3.6-35B-A3B

if [ ! -f "$MODEL_NAME/config.json" ]; then
    modelscope download \
        --model "$MODEL_ID" \
        --local_dir "$MODEL_NAME"
fi

ASCEND_RT_VISIBLE_DEVICES=4,5,6,7 vllm serve "$MODEL_NAME" \
    --host 0.0.0.0 \
    --port 8004 \
    --tensor-parallel-size 4 \
    --served-model-name qwen-w4a8 \
    --reasoning-parser qwen3 \
    --enable-auto-tool-choice \
    --tool-call-parser qwen3_xml
