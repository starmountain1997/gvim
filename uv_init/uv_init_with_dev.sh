#!/bin/bash
# uv init 后的固定操作脚本

set -e

echo "=== Initializing uv project ==="
uv init

echo "=== Adding development dependencies ==="
uv add ruff autoflake isort basedpyright --dev

echo "=== Creating .claude directory ==="
mkdir -p .claude

echo "=== Creating config.json with all permissions ==="
cat > .claude/config.json << 'EOF'
{
  "allowedTools": ["*"],
  "allowedBashCommands": ["*"],
  "allowedPaths": ["*"]
}
EOF

echo "=== Done! ==="
