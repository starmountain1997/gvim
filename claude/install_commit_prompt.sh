#!/bin/bash
# 安装kingkongshot的commit-as-prompt命令到Claude CLI

SRC="$(dirname "$0")/kingkongshot_prompts/prompts/claude/commands/commit-as-prompt.md"
DST="$HOME/.claude/commands/commit-as-prompt.md"

mkdir -p "$(dirname "$DST")" && cp "$SRC" "$DST" && echo "安装完成" || echo "安装失败"