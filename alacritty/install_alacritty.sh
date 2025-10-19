#!/bin/bash

set -e

# 固定使用 dracula 主题
THEME_NAME="dracula"

# --- Functions ---
# 简化处理 - 只接受 --theme 参数
if [[ "$1" == "--theme" && -n "$2" ]]; then
    THEME_NAME="$2"
fi

# 字体提示
echo -e "\033[0;33m提示: 请确保已安装 'FiraCode Nerd Font Mono' 字体\033[0m"
echo -e "\033[0;33m下载地址: https://www.nerdfonts.com/font-downloads\033[0m"
echo -e "\033[0;33m使用主题: $THEME_NAME\033[0m"

# 配置路径
CONFIG_DIR="$HOME/.config/alacritty"
THEMES_DIR="$CONFIG_DIR/themes"
THEME_FILE="$THEMES_DIR/${THEME_NAME}.toml"
CONFIG_FILE="$CONFIG_DIR/alacritty.toml"

echo -e "\033[0;33m创建配置目录: $CONFIG_DIR\033[0m"
mkdir -p "$THEMES_DIR"

# 检查主题在submodule中是否存在
SOURCE_THEME="$(dirname "$0")/alacritty-theme/themes/${THEME_NAME}.toml"
if [[ ! -f "$SOURCE_THEME" ]]; then
    echo -e "\033[0;31m错误: 主题 '$THEME_NAME' 在 submodule 中未找到。\033[0m"
    echo -e "\033[0;33m可用主题:"
    ls "$(dirname "$0")/alacritty-theme/themes/" | sed 's/\.toml$//' | head -10
    echo -e "完整列表: https://github.com/alacritty/alacritty-theme\033[0m"
    exit 1
fi

echo -e "\033[0;33m从 submodule 复制主题文件...\033[0m"
cp "$SOURCE_THEME" "$THEMES_DIR/"

echo -e "\033[0;32m主题 '$THEME_NAME' 可用。\033[0m"
echo -e "\033[0;33m创建 alacritty.toml 配置...\033[0m"

# 创建配置文件
cat > "$CONFIG_FILE" << EOF
general.import = [
  "${CONFIG_DIR}/themes/${THEME_NAME}.toml"
]

[font]
normal = { family = "FiraCode Nerd Font Mono", style = "Retina" }
EOF

echo -e "\033[0;32mAlacritty 配置完成，主题: ${THEME_NAME}\033[0m"
