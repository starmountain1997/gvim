#!/bin/bash

CONFIG_DIR="${1:-$HOME/.config/wezterm}"

if [[ ! -f "wezterm.lua" ]]; then
    echo "Error: wezterm.lua not found." >&2
    exit 1
fi

mkdir -p "$CONFIG_DIR"
cp wezterm.lua "$CONFIG_DIR/"

echo "WezTerm configuration installed!"