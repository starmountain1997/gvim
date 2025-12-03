#!/bin/bash

# 脚本出错时立即退出
set -e

# --- Emojis and Colors ---
INFO="ℹ️"
SUCCESS="✅"
WARN="⚠️"
STEP="🚀"
CONFIG="🔧"
PARTY="🎉"

# --- 配置 ---
# Neovim 配置文件的源路径和目标路径
INIT_LUA_SOURCE="$(dirname "$0")/init.lua"
INIT_LUA_TARGET="$HOME/.config/nvim/init.lua"

# --- 步骤 1: 创建目标目录 ---
echo -e "\n$STEP 步骤 1: 创建 Neovim 配置目录..."
NVIM_CONFIG_DIR="$HOME/.config/nvim"
if [ ! -d "$NVIM_CONFIG_DIR" ]; then
  echo "$INFO 正在创建目录: $NVIM_CONFIG_DIR"
  mkdir -p "$NVIM_CONFIG_DIR"
  echo "$SUCCESS 目录已创建。"
else
  echo "$SUCCESS 目录已存在，跳过创建。"
fi

# --- 步骤 2: 备份现有配置（如果存在） ---
echo -e "\n$STEP 步骤 2: 备份现有配置..."
if [ -f "$INIT_LUA_TARGET" ]; then
  BACKUP_FILE="$INIT_LUA_TARGET.backup.$(date +%Y%m%d_%H%M%S)"
  echo "$INFO 正在备份现有配置: $INIT_LUA_TARGET -> $BACKUP_FILE"
  cp "$INIT_LUA_TARGET" "$BACKUP_FILE"
  echo "$SUCCESS 配置已备份到: $BACKUP_FILE"
else
  echo "$SUCCESS 没有现有配置需要备份。"
fi

# --- 步骤 3: 部署 init.lua ---
echo -e "\n$STEP 步骤 3: 部署 init.lua..."
echo "$CONFIG 部署 init.lua..."
cp "$INIT_LUA_SOURCE" "$INIT_LUA_TARGET"
echo "$SUCCESS $INIT_LUA_SOURCE -> $INIT_LUA_TARGET"

# --- 步骤 4: 验证安装 ---
echo -e "\n$STEP 步骤 4: 验证安装..."
if [ -f "$INIT_LUA_TARGET" ]; then
  echo "$SUCCESS Neovim 配置已成功安装到: $INIT_LUA_TARGET"
  echo "$INFO 文件大小: $(wc -l < "$INIT_LUA_TARGET") 行"
else
  echo "$WARN 警告: 配置文件可能未正确安装。"
fi

echo -e "\n$PARTY Neovim 环境配置完成！$PARTY\n"
echo "使用方法:"
echo "1. 启动 Neovim: nvim"
echo "2. 查看配置是否生效"
echo "3. 后续可以编辑 $INIT_LUA_SOURCE 来添加更多配置"
echo ""
echo "注意: 这是一个渐进式配置的起点，后续可以根据需要添加插件和设置。"