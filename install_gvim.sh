#!/bin/bash

# 脚本出错时立即退出
set -e

# --- 配置 ---
# Vim 配置文件的源路径和目标路径
VIMRC_SOURCE="./vimrc"
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
vim -e -u "$VIMRC_TARGET" -i NONE -c "PlugInstall" -c "PlugClean!" -c "qa!"
echo "Vim 插件清理和安装完成。"

# --- 步骤 3: 根据语言配置安装开发工具 ---
echo "=> 检查语言配置: $LANGUAGES"

# 检查是否需要配置 Python 开发环境
if [[ "$LANGUAGES" == *"python"* ]]; then
  echo "=> 配置 Python 开发环境..."

  # 检查 uv 是否已安装
  if ! command -v uv &> /dev/null; then
    echo "uv 未安装，正在安装..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo "uv 已安装。"
    # 重新加载环境变量
    export PATH="$HOME/.cargo/bin:$PATH"
  else
    echo "uv 已存在，跳过安装。"
  fi

  # 检查 basedpyright 是否已安装
  if ! command -v basedpyright &> /dev/null; then
    echo "basedpyright 未安装，正在安装..."
    uv tool install basedpyright
    echo "basedpyright 已安装。"
  else
    echo "basedpyright 已存在，跳过安装。"
  fi

  # 检查 ruff 是否已安装
  if ! command -v ruff &> /dev/null; then
    echo "ruff 未安装，正在安装..."
    uv tool install ruff
    echo "ruff 已安装。"
  else
    echo "ruff 已存在，跳过安装。"
  fi
fi

echo -e "\n🎉 Vim 环境配置完成！"
