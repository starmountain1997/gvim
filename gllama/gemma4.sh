#!/usr/bin/env bash
cd "$(dirname "$0")/Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-MTP" || exit 1

llama serve \
  -m ./Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M.gguf \
  --alias "gemma4" \
  -md ./mtp-gemma-4-26B-A4B-it.gguf \
  --spec-type draft-mtp \
  -ngl 99 \
  -cmoe \
  -fa on \
  --mmproj ./mmproj-Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-BF16.gguf \
  --host 0.0.0.0 --port 8080 \
  --alias "gemma4-26b-a4b" \
  --jinja \
  --temp 0.6 \
  --top-k 64 \
  --top-p 0.9 \
  --min-p 0.05 \
  --repeat-penalty 1.1
