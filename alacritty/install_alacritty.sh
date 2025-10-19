#!/bin/bash

set -e

# --- Colors ---
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if FiraCode Nerd Font is installed
FONT_NAME="FiraCode Nerd Font Mono"
echo -e "${YELLOW}Checking for font: $FONT_NAME...${NC}"

if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    if ! system_profiler SPFontsDataType | grep -q "$FONT_NAME"; then
        echo -e "${RED}Error: The font '$FONT_NAME' is not installed on macOS.${NC}"
        echo -e "${YELLOW}Please download and install it from https://www.nerdfonts.com/font-downloads${NC}"
        exit 1
    fi
elif [[ "$(uname)" == "Linux" ]]; then
    # Linux
    if command -v fc-list &> /dev/null; then
        if ! fc-list | grep -q "$FONT_NAME"; then
            echo -e "${RED}Error: The font '$FONT_NAME' is not installed on Linux.${NC}"
            echo -e "${YELLOW}Please download and install it from https://www.nerdfonts.com/font-downloads${NC}"
            exit 1
        fi
    else
        echo -e "${YELLOW}Warning: 'fc-list' command not found. Cannot check for font installation.${NC}"
        echo -e "${YELLOW}Please ensure '$FONT_NAME' is installed.${NC}"
    fi
else
    echo -e "${YELLOW}Warning: Unsupported OS for font check. Please ensure '$FONT_NAME' is installed.${NC}"
fi

echo -e "${GREEN}Font check passed.${NC}"

ALACRITTY_CONFIG_DIR="$HOME/.config/alacritty"
THEMES_DIR="$ALACRITTY_CONFIG_DIR/themes"
DRACULA_THEME_FILE="$THEMES_DIR/dracula.toml"
DRACULA_THEME_URL="https://raw.githubusercontent.com/dracula/alacritty/master/dracula.toml"
SOURCE_CONFIG_FILE="$(dirname "$0")/alacritty.toml"
ALACRITTY_CONFIG_FILE="$ALACRITTY_CONFIG_DIR/alacritty.toml"

echo -e "${YELLOW}Ensuring Alacritty config directory exists at $ALACRITTY_CONFIG_DIR...${NC}"
mkdir -p "$ALACRITTY_CONFIG_DIR"

echo -e "${YELLOW}Ensuring themes directory exists at $THEMES_DIR...${NC}"
mkdir -p "$THEMES_DIR"

echo -e "${YELLOW}Downloading Dracula theme to $DRACULA_THEME_FILE...${NC}"
if command -v curl &> /dev/null; then
    curl -sSL -o "$DRACULA_THEME_FILE" "$DRACULA_THEME_URL"
elif command -v wget &> /dev/null; then
    wget -qO "$DRACULA_THEME_FILE" "$DRACULA_THEME_URL"
else
    echo -e "${RED}Error: curl or wget is required to download the theme.${NC}"
    exit 1
fi
echo -e "${GREEN}Download complete.${NC}"

echo -e "${YELLOW}Copying alacritty.toml to $ALACRITTY_CONFIG_FILE...${NC}"
cp "$SOURCE_CONFIG_FILE" "$ALACRITTY_CONFIG_FILE"

echo -e "${GREEN}Alacritty configuration updated successfully!${NC}"
echo -e "${YELLOW}Please restart Alacritty to see the changes.${NC}"
