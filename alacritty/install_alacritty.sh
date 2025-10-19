#!/bin/bash

set -e

ALACRITTY_CONFIG_DIR="$HOME/.config/alacritty"
THEMES_DIR="$ALACRITTY_CONFIG_DIR/themes"
DRACULA_THEME_FILE="$THEMES_DIR/dracula.toml"
DRACULA_THEME_URL="https://raw.githubusercontent.com/dracula/alacritty/master/dracula.toml"
SOURCE_CONFIG_FILE="$(dirname "$0")/alacritty.toml"
ALACRITTY_CONFIG_FILE="$ALACRITTY_CONFIG_DIR/alacritty.toml"

echo "Ensuring Alacritty config directory exists at $ALACRITTY_CONFIG_DIR..."
mkdir -p "$ALACRITTY_CONFIG_DIR"

echo "Ensuring themes directory exists at $THEMES_DIR..."
mkdir -p "$THEMES_DIR"

echo "Downloading Dracula theme to $DRACULA_THEME_FILE..."
if command -v curl &> /dev/null; then
    curl -sSL -o "$DRACULA_THEME_FILE" "$DRACULA_THEME_URL"
elif command -v wget &> /dev/null; then
    wget -qO "$DRACULA_THEME_FILE" "$DRACULA_THEME_URL"
else
    echo "Error: curl or wget is required to download the theme."
    exit 1
fi
echo "Download complete."

echo "Copying alacritty.toml to $ALACRITTY_CONFIG_FILE..."
cp "$SOURCE_CONFIG_FILE" "$ALACRITTY_CONFIG_FILE"

echo "Alacritty configuration updated successfully!"
echo "Please restart Alacritty to see the changes."