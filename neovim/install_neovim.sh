#!/bin/bash

echo "请确保已安装 rust nightly toolchain"
echo "可以通过以下命令安装："
echo "rustup install nightly"
echo "rustup default nightly"
echo ""

rm -rf ~/.config/nvim
cp -r nvim ~/.config/
