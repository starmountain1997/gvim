#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.config/nvim"

if [ -L "$TARGET" ]; then
  echo "Already symlinked: $TARGET"
elif [ -d "$TARGET" ]; then
  echo "Error: $TARGET exists and is not a symlink"
  exit 1
else
  mkdir -p "$(dirname "$TARGET")"
  ln -s "$SCRIPT_DIR" "$TARGET"
  echo "Symlinked: $TARGET -> $SCRIPT_DIR"
fi
