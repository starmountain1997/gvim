#!/bin/bash

set -e

# 固定使用 dracula 主题
THEME_NAME="dracula"
INSTALL_FONT=1
INSTALL_KONSOLE=0

usage() {
    echo "用法: $0 [--theme <主题名>] [--no-font] [--konsole]"
    echo "  --theme <名称>  指定主题（默认 dracula），见 alacritty-theme/themes/"
    echo "  --no-font       跳过字体安装"
    echo "  --konsole       配置 Konsole 使用 Alacritty 风格键位"
    echo "                  (Ctrl+C 复制 / Ctrl+V 粘贴 / Ctrl+Shift+C 中断)"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --theme)
            if [[ -z "$2" ]]; then
                echo -e "\033[0;31m错误: --theme 需要一个参数\033[0m"
                usage
                exit 1
            fi
            THEME_NAME="$2"
            shift 2
            ;;
        --no-font)
            INSTALL_FONT=0
            shift
            ;;
        --konsole)
            INSTALL_KONSOLE=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo -e "\033[0;31m错误: 未知参数 '$1'\033[0m"
            usage
            exit 1
            ;;
    esac
done

echo -e "\033[0;33m使用主题: $THEME_NAME\033[0m"

# 字体安装（FiraCode Nerd Font Mono）
FONT_FAMILY="FiraCode Nerd Font Mono"
FONT_PKG="ttf-firacode-nerd"

font_is_installed() {
    command -v fc-list >/dev/null 2>&1 && fc-list : family 2>/dev/null | grep -Fiq "$FONT_FAMILY"
}

install_font() {
    echo -e "\033[0;33m检查字体: $FONT_FAMILY\033[0m"

    if font_is_installed; then
        echo -e "\033[0;32m字体已安装，跳过\033[0m"
        return 0
    fi

    local ok=0

    if command -v pacman >/dev/null 2>&1; then
        local sudo_cmd=""
        command -v sudo >/dev/null 2>&1 && sudo_cmd="sudo"

        echo -e "\033[0;33m使用 pacman 安装 $FONT_PKG ...\033[0m"
        if $sudo_cmd pacman -S --needed --noconfirm "$FONT_PKG"; then
            ok=1
        elif command -v yay >/dev/null 2>&1; then
            echo -e "\033[0;33mpacman 安装失败，改用 yay 安装 ...\033[0m"
            yay -S --needed --noconfirm "$FONT_PKG" && ok=1
        fi
    elif command -v yay >/dev/null 2>&1; then
        echo -e "\033[0;33m使用 yay 安装 $FONT_PKG ...\033[0m"
        yay -S --needed --noconfirm "$FONT_PKG" && ok=1
    elif command -v brew >/dev/null 2>&1; then
        echo -e "\033[0;33m使用 Homebrew 安装 font-fira-code-nerd-font ...\033[0m"
        brew install --cask font-fira-code-nerd-font && ok=1
    fi

    command -v fc-cache >/dev/null 2>&1 && fc-cache -f >/dev/null 2>&1 || true

    if [[ $ok -eq 1 ]] && font_is_installed; then
        echo -e "\033[0;32m字体安装完成: $FONT_FAMILY\033[0m"
    else
        echo -e "\033[0;31m警告: 未能自动安装字体 '$FONT_FAMILY'，终端会回退到其他字体\033[0m"
        echo -e "\033[0;33m手动安装:"
        echo -e "  Arch:  sudo pacman -S $FONT_PKG   或   yay -S $FONT_PKG"
        echo -e "  macOS: brew install --cask font-fira-code-nerd-font"
        echo -e "  其他:  https://www.nerdfonts.com/font-downloads\033[0m"
    fi
}

if [[ $INSTALL_FONT -eq 1 ]]; then
    install_font
else
    echo -e "\033[0;33m提示: 请确保已安装 '$FONT_FAMILY' 字体（已按要求跳过安装）\033[0m"
fi

# 始终先拉取 submodule
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 检查并更新 alacritty-theme submodule（.git 在 submodule 中是文件而非目录）
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$REPO_ROOT" || ! -f "$REPO_ROOT/.gitmodules" ]]; then
    echo -e "\033[0;33m跳过 submodule 拉取: 未在 git 仓库中运行\033[0m"
else
    SUBMODULE_PATH="$(git -C "$REPO_ROOT" config -f "$REPO_ROOT/.gitmodules" --get-regexp '\.path$' 2>/dev/null | awk '$2 ~ /(^|\/)alacritty-theme$/ {print $2; exit}')"
    if [[ -z "$SUBMODULE_PATH" ]]; then
        echo -e "\033[0;33m跳过 submodule 拉取: 未找到 alacritty-theme submodule 配置\033[0m"
    elif git -C "$REPO_ROOT" submodule status "$SUBMODULE_PATH" 2>/dev/null | grep -q '^-'; then
        echo -e "\033[0;33m正在初始化 submodule: $SUBMODULE_PATH ...\033[0m"
        git -C "$REPO_ROOT" submodule update --init --recursive "$SUBMODULE_PATH" || SUBMODULE_FAILED=1
    else
        echo -e "\033[0;33m正在更新 submodule: $SUBMODULE_PATH ...\033[0m"
        git -C "$REPO_ROOT" submodule update --init --recursive "$SUBMODULE_PATH" || SUBMODULE_FAILED=1
    fi
    if [[ -n "$SUBMODULE_FAILED" && ! -f "$SCRIPT_DIR/alacritty-theme/themes/${THEME_NAME}.toml" ]]; then
        echo -e "\033[0;31m错误: submodule 拉取失败，且本地无主题文件 '$THEME_NAME'。\033[0m"
        exit 1
    elif [[ -n "$SUBMODULE_FAILED" ]]; then
        echo -e "\033[0;33m警告: submodule 拉取失败，继续使用本地已有主题文件\033[0m"
    fi
fi

# 路径定义
CONFIG_DIR="$HOME/.config/alacritty"
THEMES_DIR="$CONFIG_DIR/themes"

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
cp "$SCRIPT_DIR/alacritty.toml" "$CONFIG_DIR/alacritty.toml"

# 更新配置文件中的主题名称
sed -i.bak "s/dracula.toml/${THEME_NAME}.toml/" "$CONFIG_DIR/alacritty.toml"
rm -f "$CONFIG_DIR/alacritty.toml.bak"


# 部署 zellij 配置（macOS 复制粘贴修复）
ZELLIJ_DIR="$HOME/.config/zellij"
mkdir -p "$ZELLIJ_DIR"
cp "$SCRIPT_DIR/zellij/config.kdl" "$ZELLIJ_DIR/config.kdl"
echo -e "\033[0;32mZellij 配置完成: $ZELLIJ_DIR/config.kdl\033[0m"

# 在 KConfig/INI 文件中设置键值（kwriteconfig6 不可用时的回退实现）
ini_set() {
    local file="$1" group="$2" key="$3" value="$4"
    local tmp
    [[ -f "$file" ]] || touch "$file"
    tmp="$(mktemp)"
    awk -v group="$group" -v key="$key" -v value="$value" '
        BEGIN { in_group = 0; wrote = 0 }
        /^\[.*\]$/ {
            if (in_group && !wrote) {
                print key "=" value
                wrote = 1
            }
            in_group = ($0 == "[" group "]")
        }
        in_group && index($0, key "=") == 1 { next }
        { print }
        END {
            if (!wrote) {
                if (!in_group) print "[" group "]"
                print key "=" value
            }
        }
    ' "$file" > "$tmp" && mv "$tmp" "$file"
}

install_konsole_bindings() {
    if ! command -v konsole >/dev/null 2>&1; then
        echo -e "\033[0;33m未检测到 konsole，跳过 Konsole 键位配置\033[0m"
        return 0
    fi

    local data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
    local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
    local konsole_data="$data_home/konsole"
    local kxmlgui_dir="$data_home/kxmlgui5/konsole"
    local session_rc="$kxmlgui_dir/sessionui.rc"
    local konsolerc="$config_home/konsolerc"

    mkdir -p "$konsole_data" "$kxmlgui_dir"

    # 1) 键盘映射表：Ctrl+Shift+C 发送 SIGINT (0x03)
    cp "$SCRIPT_DIR/konsole/Alacritty.keytab" "$konsole_data/Alacritty.keytab"
    echo -e "\033[0;32mKonsole keytab 已安装: $konsole_data/Alacritty.keytab\033[0m"

    # 2) Copy/Paste 是 QAction 快捷键，需要用 KXMLGUI 的 ActionProperties 覆盖
    if [[ -f "$session_rc" ]]; then
        [[ -f "${session_rc}.bak" ]] || cp "$session_rc" "${session_rc}.bak"
        if grep -q '</gui>' "$session_rc"; then
            local tmp
            tmp="$(mktemp)"
            awk '
                BEGIN { skip = 0; inserted = 0 }
                {
                    if (skip) {
                        if ($0 ~ /<\/ActionProperties>/) skip = 0
                        next
                    }
                    if ($0 ~ /<ActionProperties/) {
                        if ($0 ~ /\/>/ || $0 ~ /<\/ActionProperties>/) next
                        skip = 1
                        next
                    }
                    if ($0 ~ /<\/gui>/ && !inserted) {
                        print "    <ActionProperties scheme=\"Default\">"
                        print "        <Action name=\"edit_copy\" shortcut=\"Ctrl+C\"/>"
                        print "        <Action name=\"edit_paste\" shortcut=\"Ctrl+V\"/>"
                        print "    </ActionProperties>"
                        inserted = 1
                    }
                    print
                }
            ' "$session_rc" > "$tmp" && mv "$tmp" "$session_rc"
            echo -e "\033[0;32mKonsole 快捷键已更新（备份: ${session_rc}.bak）\033[0m"
        else
            echo -e "\033[0;33m警告: 无法解析已有 $session_rc，未修改\033[0m"
        fi
    else
        cp "$SCRIPT_DIR/konsole/sessionui.rc" "$session_rc"
        echo -e "\033[0;32mKonsole 快捷键已安装: $session_rc\033[0m"
    fi

    # 3) 让默认配置方案使用 alacritty keytab
    local default_profile=""
    if command -v kreadconfig6 >/dev/null 2>&1; then
        default_profile="$(kreadconfig6 --file "$konsolerc" --group "Desktop Entry" --key DefaultProfile 2>/dev/null || true)"
    fi

    if [[ -n "$default_profile" && -f "$konsole_data/$default_profile" ]]; then
        local profile_file="$konsole_data/$default_profile"
        [[ -f "${profile_file}.bak" ]] || cp "$profile_file" "${profile_file}.bak"
        if command -v kwriteconfig6 >/dev/null 2>&1; then
            kwriteconfig6 --file "$profile_file" --group General --key KeyBindings Alacritty
        else
            ini_set "$profile_file" General KeyBindings Alacritty
        fi
        echo -e "\033[0;32m已为默认配置方案 '$default_profile' 启用 Alacritty 键位（备份: ${profile_file}.bak）\033[0m"
    else
        local profile_file="$konsole_data/Alacritty.profile"
        cat > "$profile_file" <<'PROFILE'
[General]
Name=Alacritty
Parent=_builtin_
KeyBindings=Alacritty
PROFILE
        if command -v kwriteconfig6 >/dev/null 2>&1; then
            kwriteconfig6 --file "$konsolerc" --group "Desktop Entry" --key DefaultProfile Alacritty.profile
        else
            ini_set "$konsolerc" "Desktop Entry" DefaultProfile Alacritty.profile
        fi
        echo -e "\033[0;32m已创建 Konsole 配置方案 'Alacritty' 并设为默认\033[0m"
    fi

    # 4) 非 Default 的快捷键方案会忽略 ActionProperties
    local scheme=""
    if command -v kreadconfig6 >/dev/null 2>&1; then
        scheme="$(kreadconfig6 --file "$konsolerc" --group "Shortcut Schemes" --key "Current Scheme" 2>/dev/null || true)"
    fi
    if [[ -n "$scheme" && "$scheme" != "Default" ]]; then
        echo -e "\033[0;33m提示: 当前快捷键方案为 '$scheme'，Ctrl+C/Ctrl+V 覆盖仅对 Default 方案生效\033[0m"
    fi

    echo -e "\033[0;33m提示: 请完全退出并重新打开 Konsole 使键位生效\033[0m"
}

if [[ $INSTALL_KONSOLE -eq 1 ]]; then
    install_konsole_bindings
fi

echo -e "\033[0;32mAlacritty 配置完成，主题: ${THEME_NAME}\033[0m"
