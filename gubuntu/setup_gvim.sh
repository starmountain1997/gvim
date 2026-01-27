#!/bin/bash
set -e

# ============================================================
# Gumby VLLM Ascend 环境配置脚本
# 用于在已安装 ascend 环境的机器上手动配置开发环境
# ============================================================

# 设置代理
export http_proxy=http://127.0.0.1:6152
export https_proxy=http://127.0.0.1:6152
export HTTP_PROXY=http://127.0.0.1:6152
export HTTPS_PROXY=http://127.0.0.1:6152

echo "==> 安装基础依赖..."
apt-get update
apt-get install -y --no-install-recommends zsh curl git
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "==> 安装 Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "==> 安装 Zsh 插件..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "==> 配置 Zsh 主题和插件..."
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="random"/' ~/.zshrc

echo "==> 添加 Ascend 环境变量配置..."
echo "source /usr/local/Ascend/ascend-toolkit/set_env.sh" >> ~/.zshrc
echo "source /usr/local/Ascend/nnal/atb/set_env.sh" >> ~/.zshrc

echo "==> 添加代理别名..."
echo 'alias set_proxy="export http_proxy=http://127.0.0.1:6152 && export https_proxy=http://127.0.0.1:6152"' >> ~/.zshrc
echo 'alias unset_proxy="unset http_proxy && unset https_proxy"' >> ~/.zshrc

echo "==> 添加本地 bin 目录到 PATH..."
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

echo "==> 升级 pip..."
pip install --upgrade pip

echo "==> 配置 pip 镜像源..."
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple
pip config set global.extra-index-url "https://download.pytorch.org/whl/cpu/ https://mirrors.huaweicloud.com/ascend/repos/pypi"

echo "==> 安装 Claude AI CLI..."
curl -fsSL https://claude.ai/install.sh | bash

echo "==> 配置 Git 用户信息..."
git config --global user.name "guozr"
git config --global user.email "guozr1997@hotmail.com"

echo "==> 安装 Python 工具..."
pip install ruff pyright

echo ""
echo "==> 配置完成！请运行: zsh"
