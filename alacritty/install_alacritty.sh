#!/bin/bash

set -e

# 固定使用 dracula 主题
THEME_NAME="dracula"

# --- Functions ---
# 简化处理 - 只接受 --theme 参数
if [[ "$1" == "--theme" && -n "$2" ]]; then
    THEME_NAME="$2"
fi

# 检查字体是否安装
echo -e "\033[0;33m检查字体: FiraCode Nerd Font Mono...\033[0m"

if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    if ! system_profiler SPFontsDataType | grep -q "FiraCode Nerd Font Mono"; then
        echo -e "\033[0;31m错误: 字体 'FiraCode Nerd Font Mono' 未安装。\033[0m"
        echo -e "\033[0;33m请从 https://www.nerdfonts.com/font-downloads 下载安装\033[0m"
        exit 1
    fi
elif [[ "$(uname)" == "Linux" ]]; then
    # Linux
    if command -v fc-list &> /dev/null; then
        if ! fc-list | grep -q "FiraCode Nerd Font Mono"; then
            echo -e "\033[0;31m错误: 字体 'FiraCode Nerd Font Mono' 未安装。\033[0m"
            echo -e "\033[0;33m请从 https://www.nerdfonts.com/font-downloads 下载安装\033[0m"
            exit 1
        fi
    else
        echo -e "\033[0;33m警告: 无法检查字体安装状态，请确保 'FiraCode Nerd Font Mono' 已安装。\033[0m"
    fi
else
    echo -e "\033[0;33m警告: 不支持的操作系统，请确保 'FiraCode Nerd Font Mono' 已安装。\033[0m"
fi

echo -e "\033[0;32m字体检查通过。\033[0m"
echo -e "\033[0;33m使用主题: $THEME_NAME\033[0m"

# 配置路径
CONFIG_DIR="$HOME/.config/alacritty"
THEMES_DIR="$CONFIG_DIR/themes"
THEME_FILE="$THEMES_DIR/${THEME_NAME}.toml"
CONFIG_FILE="$CONFIG_DIR/alacritty.toml"
THEME_REPO="https://github.com/alacritty/alacritty-theme.git"

echo -e "\033[0;33m创建配置目录: $CONFIG_DIR\033[0m"
mkdir -p "$CONFIG_DIR"

echo -e "\033[0;33m设置主题...\033[0m"

# 克隆或更新主题仓库
if [[ -d "$THEMES_DIR/.git" ]]; then
    echo -e "\033[0;33m更新主题仓库...\033[0m"
    cd "$THEMES_DIR"
    if ! git pull origin master; then
        echo -e "\033[0;31m错误: 更新主题仓库失败。\033[0m"
        exit 1
    fi
else
    echo -e "\033[0;33m克隆主题仓库...\033[0m"
    if ! git clone "$THEME_REPO" "$THEMES_DIR"; then
        echo -e "\033[0;31m错误: 克隆主题仓库失败。\033[0m"
        exit 1
    fi
fi

# 检查主题是否存在
if [[ ! -f "$THEMES_DIR/themes/${THEME_NAME}.toml" ]]; then
    echo -e "\033[0;31m错误: 主题 '$THEME_NAME' 未找到。\033[0m"
    echo -e "\033[0;33m可用主题:"
    ls "$THEMES_DIR/themes" | sed 's/\.toml$//' | head -10
    echo -e "完整列表: https://github.com/alacritty/alacritty-theme\033[0m"
    exit 1
fi

echo -e "\033[0;32m主题 '$THEME_NAME' 可用。\033[0m"
echo -e "\033[0;33m创建 alacritty.toml 配置...\033[0m"

# 创建配置文件
cat > "$CONFIG_FILE" << EOF
general.import = [
  "~/.config/alacritty/themes/${THEME_NAME}.toml"
]

[font]
normal = { family = "FiraCode Nerd Font Mono", style = "Retina" }
EOF

echo -e "\033[0;32mAlacritty 配置完成，主题: ${THEME_NAME}\033[0m"
