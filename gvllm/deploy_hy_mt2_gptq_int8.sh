#!/bin/bash
set -euo pipefail

MODEL_NAME="Tencent-Hunyuan/Hy-MT2-1.8B"
MODEL_DIR="${MODEL_DIR:-$HOME/.cache/modelscope/models/Tencent-Hunyuan--Hy-MT2-1.8B/snapshots/master}"

if [[ ! -f "$MODEL_DIR/model.safetensors" ]]; then
    ms download "$MODEL_NAME" --local-dir "$MODEL_DIR"
fi

sglang serve \
    --model-path "$MODEL_DIR" \
    --trust-remote-code \
    --host 0.0.0.0 \
    --port 8000 \
    --mem-fraction-static 0.7 \
    --context-length 1024 \
    --served-model-name hy-mt2
