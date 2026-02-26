#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_REPO="$SCRIPT_DIR/third_party/skills"
OPENCODE_SKILLS_DIR="$HOME/.config/opencode/skills"
SKILL_NAME="skill-creator"

if [ ! -d "$SKILLS_REPO" ]; then
    echo "Error: Skills repository not found at $SKILLS_REPO"
    echo "Please run: git submodule add https://github.com/anthropics/skills.git third_party/skills"
    exit 1
fi

SOURCE_DIR="$SKILLS_REPO/skills/$SKILL_NAME"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Skill '$SKILL_NAME' not found in repository"
    exit 1
fi

mkdir -p "$OPENCODE_SKILLS_DIR"

TARGET_DIR="$OPENCODE_SKILLS_DIR/$SKILL_NAME"

if [ -L "$TARGET_DIR" ] || [ -d "$TARGET_DIR" ]; then
    echo "Removing existing skill at $TARGET_DIR"
    rm -rf "$TARGET_DIR"
fi

cp -r "$SOURCE_DIR" "$TARGET_DIR"

echo "Successfully installed skill '$SKILL_NAME' to $TARGET_DIR"
echo "Skill is now available at: $TARGET_DIR/SKILL.md"
