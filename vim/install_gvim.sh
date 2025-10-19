#!/bin/bash

# 脚本出错时立即退出
set -e

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
echo "=> 检查并安装 vim-plug..."
PLUG_VIM_PATH="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$PLUG_VIM_PATH" ]; then
  curl -fLo "$PLUG_VIM_PATH" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "vim-plug 已安装。"
else
  echo "vim-plug 已存在，跳过安装。"
fi

# --- 步骤 2: 部署 vimrc 并安装插件 ---
echo "=> 部署 vimrc..."
cp "$VIMRC_SOURCE" "$VIMRC_TARGET"
echo "$VIMRC_SOURCE -> $VIMRC_TARGET"

echo "=> 运行 PlugInstall 安装插件..."
# 先安装插件，然后再清理（如果需要的话）
vim -e -u "$VIMRC_TARGET" -i NONE -c "PlugInstall" -c "qa!"
echo "Vim 插件安装完成。"

# --- 步骤 3: 根据语言配置安装开发工具 ---
echo "=> 检查语言配置: $LANGUAGES"

# 检查是否需要配置 Python 开发环境
if [[ "$LANGUAGES" == *"python"* ]]; then
  if ! command -v ruff &> /dev/null; then
    echo "ruff 未安装，请安装ruff..."
  fi
  if ! command -v pyright &> /dev/null; then
    echo "pyright 未安装，请安装pyright..."
  fi
fi

echo -e "\n🎉 Vim 环境配置完成！"
