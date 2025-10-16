#!/bin/bash

# 脚本出错时立即退出
set -e

# --- 配置 ---
# Vim 配置文件的源路径和目标路径
VIMRC_SOURCE="./vimrc"
VIMRC_TARGET="$HOME/.vimrc"

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

echo "=> 运行 PlugInstall 和 PlugClean..."
vim -e -u "$VIMRC_TARGET" -i NONE -c "PlugInstall" -c "qa!"
echo "Vim 插件安装/更新和清理完成。"

echo -e "\n🎉 Vim 环境配置完成！"
