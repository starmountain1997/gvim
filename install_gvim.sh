#!/bin/bash

# 脚本出错时立即退出
set -e

# --- 配置 ---
# 定义你期望安装的 CoC 插件列表
# 在这里添加或删除你需要的 CoC 插件
DESIRED_COC_PLUGINS=(
  "coc-pyright"
  "coc-json"
  "coc-pairs"
)

# Vim 配置文件的源路径和目标路径
VIMRC_SOURCE="./vimrc"
VIMRC_TARGET="$HOME/.vimrc"
COC_SETTINGS_SOURCE="./coc-settings.json"
COC_SETTINGS_TARGET="$HOME/.vim/coc-settings.json" # 推荐的 CoC 配置文件路径

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

# --- 步骤 2: 安装 Vim 插件 (vim-plug) ---
# 优化点：不再临时替换整个 vimrc 文件。
# 我们使用 `-u` 参数来告诉 Vim 在本次操作中只使用你的插件配置文件。
# 这更加安全和高效。假设你的插件列表在 vimrc 的 plug#begin/end之间。
# 我们先提取这部分到一个临时文件。
echo "=> 准备安装 Vim 插件..."
PLUG_CONFIG_TEMP=$(mktemp)
sed -n '/call plug#begin/,/call plug#end/p' "$VIMRC_SOURCE" > "$PLUG_CONFIG_TEMP"

# 使用临时插件配置文件来安装插件，避免加载完整的 vimrc
echo "=> 运行 PlugInstall..."
vim -es -u "$PLUG_CONFIG_TEMP" -i NONE -c "PlugInstall" -c "qa!"
rm "$PLUG_CONFIG_TEMP" # 删除临时文件
echo "Vim 插件安装/更新完成。"

# 在管理 CoC 插件之前，先部署好 vimrc
echo "=> 部署 vimrc..."
cp "$VIMRC_SOURCE" "$VIMRC_TARGET"
echo "$VIMRC_SOURCE -> $VIMRC_TARGET"


# --- 步骤 3: 增量管理 CoC 插件 ---
echo "=> 开始增量管理 CoC 插件..."

# 3.1 获取当前已安装的 CoC 插件列表
# -es: 以 Ex 模式和静默模式运行，适合脚本
# -c "CocList extensions": 执行 CoC 命令
# awk: 解析输出，只提取插件名 (如 'coc-json')
echo "   -> 获取已安装的 CoC 插件列表..."
INSTALLED_COC_PLUGINS=$(vim -es -u "$VIMRC_TARGET" -i NONE -c "CocList extensions" -c "qa!" | awk '/^\*/ {print $2}')

# 3.2 卸载不再需要的插件
echo "   -> 检查并卸载多余的插件..."
for installed_plugin in $INSTALLED_COC_PLUGINS; do
  # 检查当前安装的插件是否存在于我们的期望列表中
  if ! [[ " ${DESIRED_COC_PLUGINS[*]} " =~ " ${installed_plugin} " ]]; then
    echo "      - 卸载插件: $installed_plugin"
    vim -es -u "$VIMRC_TARGET" -i NONE -c "CocUninstall $installed_plugin" -c "qa!"
  fi
done

# 3.3 安装和更新期望的插件
# 我们不再逐个使用 CocInstall，而是定义一个全局列表让 CoC 自己管理。
# 为了让脚本更通用，我们直接通过命令行来安装/更新，而不是依赖 vimrc里的配置。
# CocUpdateSync 是一个完美的命令，它会安装所有缺失的，并更新所有已有的。

echo "   -> 检查并安装/更新期望的插件..."
# 为了让 CocUpdateSync 能够安装新插件，我们将期望列表传递给它
# 注意：这种方式不常用，更推荐的方式是在 vimrc 中设置 g:coc_global_extensions
# 但为了脚本的独立性，我们这里采用一种更直接的方式。
# 我们逐个确保插件存在，CocInstall 本身是幂等的，如果已安装则会跳过。
for plugin in "${DESIRED_COC_PLUGINS[@]}"; do
    echo "      - 确保插件已安装: $plugin"
    vim -es -u "$VIMRC_TARGET" -i NONE -c "CocInstall -sync $plugin" -c "qa!"
done

# 最后，运行一次全局更新检查
echo "   -> 运行 CoC 全局同步更新..."
vim -es -u "$VIMRC_TARGET" -i NONE -c "CocUpdateSync" -c "qa!"

echo "CoC 插件管理完成。"

# --- 步骤 4: 部署最终的配置文件 ---
echo "=> 部署最新的配置文件..."

# 部署 CoC 配置文件
mkdir -p "$(dirname "$COC_SETTINGS_TARGET")"
cp "$COC_SETTINGS_SOURCE" "$COC_SETTINGS_TARGET"
echo "$COC_SETTINGS_SOURCE -> $COC_SETTINGS_TARGET"

echo -e "\n🎉 Vim 环境配置完成！"
