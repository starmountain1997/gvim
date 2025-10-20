#!/bin/bash

# 脚本出错时立即退出
set -e

# --- Emojis and Colors ---
INFO="ℹ️"
SUCCESS="✅"
WARN="⚠️"
STEP="🚀"
PLUGIN="🔌"
CONFIG="🔧"
LANGUAGE="🌐"
PARTY="🎉"

# --- 配置 ---
# Vim 配置文件的源路径和目标路径
VIMRC_SOURCE="$(dirname "$0")/vimrc"
VIMRC_TARGET="$HOME/.vimrc"

# 语言配置 - 通过命令行参数传入，多个语言用空格分隔
# 支持的语言：python, javascript, typescript, go, rust, java 等
# 使用方法: ./install_gvim.sh python javascript go
# 默认值为 python
LANGUAGES="${1:-python}"

# --- 步骤 1: 安装和配置 vim-plug ---
echo -e "\n$STEP 步骤 1: 安装和配置 vim-plug..."
PLUG_VIM_PATH="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$PLUG_VIM_PATH" ]; then
  echo "$INFO 正在下载 vim-plug..."
  curl -fLo "$PLUG_VIM_PATH" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "$SUCCESS vim-plug 已安装。"
else
  echo "$SUCCESS vim-plug 已存在，跳过安装。"
fi

# --- 步骤 2: 部署 vimrc 并安装插件 ---
echo -e "\n$STEP 步骤 2: 部署 vimrc 并安装插件..."
echo "$CONFIG 部署 vimrc..."
cp "$VIMRC_SOURCE" "$VIMRC_TARGET"
echo "$SUCCESS $VIMRC_SOURCE -> $VIMRC_TARGET"

echo -e "\n$PLUGIN 运行 PlugInstall 安装插件..."
# 先安装插件，然后再清理（如果需要的话）
vim -u "$VIMRC_TARGET" -i NONE -c "PlugInstall" -c "qa!"
echo "$SUCCESS Vim 插件安装完成。"

# --- 步骤 3: 根据语言配置安装开发工具 ---
echo -e "\n$STEP 步骤 3: 根据语言配置安装开发工具..."
echo "$LANGUAGE 检查语言配置: $LANGUAGES"

# 检查是否需要配置 Python 开发环境
if [[ "$LANGUAGES" == *"python"* ]]; then
  # 定义颜色
  RED='\033[0;31m'
  NC='\033[0m' # No Color

  echo "$INFO 正在检查 Python 开发工具..."
  if command -v ruff &> /dev/null; then
    echo "$SUCCESS ruff 已安装。"
  else
    echo -e "${WARN}${RED} ruff 未安装，请手动安装 ruff 以获得最佳体验。${NC}"
  fi

  if command -v pyright &> /dev/null || command -v python-lsp-server &> /dev/null; then
    if command -v pyright &> /dev/null; then
      echo "$SUCCESS pyright 已安装。"
    else
      echo "$SUCCESS python-lsp-server 已安装。"
    fi
  else
    echo -e "${WARN}${RED} pyright 或 python-lsp-server 未安装，请手动安装其中一个以获得最佳体验。${NC}"
  fi
fi

echo -e "\n$PARTY Vim 环境配置完成！$PARTY\n"
