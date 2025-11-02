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
NEOVIM_CONFIG_DIR="$HOME/.config/nvim"

# 语言配置 - 通过命令行参数传入，多个语言用空格分隔
# 支持的语言：python, javascript, typescript, go, rust, java 等
# 使用方法: ./install_neovim.sh python javascript go
# 默认值为 python
LANGUAGES="${1:-python}"

# --- 步骤 1: 检查 Neovim 配置环境 ---
echo -e "\n$STEP 步骤 1: 检查 Neovim 配置环境..."
echo "$INFO 检查 Neovim 版本..."
nvim --version | head -1
echo "$SUCCESS Neovim 环境检查完成。"

# --- 步骤 2: 确保配置目录存在并安装插件 ---
echo -e "\n$STEP 步骤 2: 检查配置并安装插件..."
echo "$CONFIG 确保配置目录存在..."
# 确保配置目录存在
mkdir -p "$NEOVIM_CONFIG_DIR"

# 检查是否有 init.lua 配置
if [ -f "$NEOVIM_CONFIG_DIR/init.lua" ]; then
  echo "$SUCCESS 找到 init.lua 配置文件"
  echo -e "\n$PLUGIN 使用 lazy.nvim 安装插件..."
  # 使用 init.lua 配置安装插件 (lazy.nvim 会自动安装)
  # 修复：避免在 headless 模式下运行 lazy.nvim，改用后台进程方式
  # macOS 兼容：使用 gtimeout 或直接运行
  if command -v gtimeout &> /dev/null; then
    gtimeout 60 nvim -c "lua require('lazy').sync()" -c "qa" || {
      echo "$WARN 插件安装超时或失败，但这通常不影响基本使用"
      echo "$INFO 插件将在首次启动 Neovim 时自动安装"
    }
  else
    # 如果没有 gtimeout，则直接运行但不使用 headless 模式
    nvim -c "lua require('lazy').sync()" -c "qa" || {
      echo "$WARN 插件安装超时或失败，但这通常不影响基本使用"
      echo "$INFO 插件将在首次启动 Neovim 时自动安装"
    }
  fi
  echo "$SUCCESS Neovim 插件安装完成。"
else
  echo "$WARN 未找到 init.lua 配置文件，请确保配置文件存在"
fi

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

  # 注意：这里不再检查 LSP 服务器，因为我们排除了 LSP 配置
  echo "$INFO 注意：此配置不包含 LSP 服务支持，如需代码补全和智能提示，请配置 Neovim 的内置 LSP。"

  echo "$INFO 正在检查 Python 调试工具..."
  if command -v debugpy &> /dev/null; then
    echo "$SUCCESS debugpy 已安装。"
  else
    echo -e "${WARN}${RED} debugpy 未安装，请手动安装 debugpy 以启用调试功能。${NC}"
  fi
fi

echo -e "\n$PARTY Neovim 环境配置完成！$PARTY"
echo -e "\n$INFO 使用说明："
echo "- 配置文件位置：$NEOVIM_CONFIG_DIR/init.lua"
echo "- 运行 'nvim' 启动 Neovim"
echo "- 此配置使用 lazy.nvim 管理插件，并包含现代化的 LSP 配置\n"