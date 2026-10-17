modelscope download --model 'Tencent-Hunyuan/Hy-MT2-7B-GGUF' 'Hy-MT2-7B-Q4_K_M.gguf' --local_dir ./
modelscope download --model 'Tencent-Hunyuan/Hy-MT2-1.8B-GGUF' 'Hy-MT2-1.8B-Q4_K_M.gguf' --local_dir ./
# llama serve -m ./Hy-MT2-7B-Q4_K_M.gguf \
llama serve -m ./Hy-MT2-1.8B-Q4_K_M.gguf \
  --host 0.0.0.0 --port 8080 \
  --alias "hy-mt2" \
  -c 81920 \
  --parallel 8 \
  --threads-http 16
