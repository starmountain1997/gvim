#!/bin/bash
# Quantize Qwen3.6-35B-A3B (VLM MoE) to W4A8 with msmodelslim
set -e
set -o pipefail

MODEL_PATH=/data1/model-agent-data/Qwen3.6-35B-A3B
SAVE_PATH=/data1/model-agent-data/Qwen3.6-35B-A3B-w4a8
CONFIG_PATH=/home/guozr/CODE/gvim/gsglang/qwen3_6_35b_a3b_w4a8.yaml
LOG_FILE=/home/guozr/CODE/gvim/gsglang/quant_qwen3_6_35b_a3b_w4a8_$(date +%Y%m%d_%H%M%S).log
MSMODELSLIM=/home/guozr/CODE/gvim/gsglang/.venv/bin/msmodelslim

# Only NPUs 2,3 are free (others in use); model lives on CPU, NPU used layer-wise.
# Indices in --device are relative to ASCEND_RT_VISIBLE_DEVICES (2,3 → 0,1)
export ASCEND_RT_VISIBLE_DEVICES=2,3

${MSMODELSLIM} quant \
    --model_path ${MODEL_PATH} \
    --save_path ${SAVE_PATH} \
    --config_path ${CONFIG_PATH} \
    --model_type Qwen3.5-35B-A3B \
    --device npu:0,1 \
    --trust_remote_code True 2>&1 | tee ${LOG_FILE}
