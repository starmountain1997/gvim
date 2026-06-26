#!/bin/bash
set -e

# 安装 rust（清华镜像源加速）
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rustup.sh
chmod +x /tmp/rustup.sh
RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup \
RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup \
/tmp/rustup.sh -y
rm /tmp/rustup.sh

. "$HOME/.cargo/env"

mkdir -p $HOME/.cargo
cat > $HOME/.cargo/config.toml << 'EOF'
[source.crates-io]
replace-with = "mirror"

[source.mirror]
registry = "sparse+https://mirrors.tuna.tsinghua.edu.cn/crates.io-index/"
EOF
