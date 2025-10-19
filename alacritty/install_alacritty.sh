#!/bin/bash

# This script installs the Dracula theme for Alacritty.
# It is intended for macOS and other Unix-like systems.
# For Windows, you would need to adapt this script for PowerShell.

set -e

# --- Configuration ---

# Alacritty configuration directory
# On macOS and Linux, it's typically ~/.config/alacritty
ALACRITTY_CONFIG_DIR="$HOME/.config/alacritty"

# URL of the Dracula theme for Alacritty
DRACULA_THEME_URL="https://raw.githubusercontent.com/alacritty/alacritty-theme/master/themes/dracula.toml"

# --- Script ---

echo "Starting Alacritty Dracula theme installation..."

# Create the Alacritty configuration directory if it doesn't exist
echo "Ensuring Alacritty config directory exists at $ALACRITTY_CONFIG_DIR..."
mkdir -p "$ALACRITTY_CONFIG_DIR"

# Path to the theme file
DRACULA_THEME_FILE="$ALACRITTY_CONFIG_DIR/dracula.toml"

# Download the Dracula theme
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

# Path to the Alacritty configuration file
ALACRITTY_CONFIG_FILE="$ALACRITTY_CONFIG_DIR/alacritty.toml"

# Create the Alacritty configuration file if it doesn't exist
if [ ! -f "$ALACRITTY_CONFIG_FILE" ]; then
    echo "Creating Alacritty config file at $ALACRITTY_CONFIG_FILE..."
    touch "$ALACRITTY_CONFIG_FILE"
fi

# Check if the theme is already imported
if ! grep -q "dracula.toml" "$ALACRITTY_CONFIG_FILE"; then
  echo "Importing Dracula theme in $ALACRITTY_CONFIG_FILE..."
  
  # The import statement. Note: TOML requires quotes.
  # We use a path that works from the home directory.
  IMPORT_STATEMENT='''import = ["~/.config/alacritty/dracula.toml"]'''

  # Create a temporary file for the new content
  TMP_FILE=$(mktemp)

  # Write the import statement to the new file
  echo "$IMPORT_STATEMENT" > "$TMP_FILE"
  echo "" >> "$TMP_FILE" # Add a blank line for separation

  # Append the existing content of alacritty.toml to the new file
  cat "$ALACRITTY_CONFIG_FILE" >> "$TMP_FILE"

  # Replace the old config file with the new one
  mv "$TMP_FILE" "$ALACRITTY_CONFIG_FILE"
  
  echo "Theme imported successfully."
else
  echo "Dracula theme is already imported in $ALACRITTY_CONFIG_FILE."
fi

echo "Alacritty Dracula theme installation complete!"
echo "Please restart Alacritty to see the changes."
