#!/bin/bash

set -e

# 固定使用 dracula 主题
THEME_NAME="dracula"

# 简化处理 - 只接受 --theme 参数
if [[ "$1" == "--theme" && -n "$2" ]]; then
    THEME_NAME="$2"
fi

# 字体提示
echo -e "\033[0;33m提示: 请确保已安装 'FiraCode Nerd Font Mono' 字体\033[0m"
echo -e "\033[0;33m下载地址: https://www.nerdfonts.com/font-downloads\033[0m"
echo -e "\033[0;33m使用主题: $THEME_NAME\033[0m"

# 路径定义
CONFIG_DIR="$HOME/.config/alacritty"
THEMES_DIR="$CONFIG_DIR/themes"
SCRIPT_DIR="$(dirname "$0")"

echo -e "\033[0;33m创建配置目录: $CONFIG_DIR\033[0m"
mkdir -p "$THEMES_DIR"

# 检查并复制主题文件
SOURCE_THEME="$SCRIPT_DIR/alacritty-theme/themes/${THEME_NAME}.toml"
if [[ ! -f "$SOURCE_THEME" ]]; then
    echo -e "\033[0;31m错误: 主题 '$THEME_NAME' 在 submodule 中未找到。\033[0m"
    echo -e "\033[0;33m可用主题:"
    ls "$SCRIPT_DIR/alacritty-theme/themes/" | sed 's/\.toml$//' | head -10
    echo -e "完整列表: https://github.com/alacritty/alacritty-theme\033[0m"
    exit 1
fi

echo -e "\033[0;33m复制主题和配置文件...\033[0m"
cp "$SOURCE_THEME" "$THEMES_DIR/"
cp "$SCRIPT_DIR/alacritty-linux.toml" "$CONFIG_DIR/alacritty.toml"

# 更新配置文件中的主题名称
sed -i "s/dracula.toml/${THEME_NAME}.toml/" "$CONFIG_DIR/alacritty.toml"

echo -e "\033[0;32mAlacritty 配置完成，主题: ${THEME_NAME}\033[0m"
