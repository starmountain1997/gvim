# 设置环境变量，使 vLLM 从 ModelScope 下载模型
export VLLM_USE_MODELSCOPE=True
export MODEL_NAME="Tencent-Hunyuan/Hy-MT2-1.8B"

# vLLM 启动服务
vllm serve \
    --model "$MODEL_NAME" \
    --trust-remote-code \
    --host 0.0.0.0 \
    --port 8000 \
    --gpu-memory-utilization 0.7 \
    --max-model-len 8192 \
    --served-model-name hy-mt2
