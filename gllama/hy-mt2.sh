modelscope download --model 'Tencent-Hunyuan/Hy-MT2-7B-GGUF' 'Hy-MT2-7B-Q4_K_M.gguf' --local_dir ./
llama serve -m ./Hy-MT2-7B-Q4_K_M.gguf \
  --metrics \
  --host 0.0.0.0 --port 8080 \
  --alias "hy-mt2" \
  -ngl 99 -fa on \
  -c 81920 --parallel 8 \
  -ctk q8_0 -ctv q8_0 \
  -t 8 --threads-http 16 \
  --temp 0.7 --top-p 0.6 --top-k 20 --min-p 0 \
  --repeat-penalty 1.05
