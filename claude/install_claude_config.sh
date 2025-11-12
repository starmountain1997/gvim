#!/bin/bash
# 安装kingkongshot的Claude配置到Claude CLI

SCRIPT_DIR="$(dirname "$0")"

# 安装commit-as-prompt命令
CMD_SRC="$SCRIPT_DIR/kingkongshot_prompts/prompts/claude/commands/commit-as-prompt.md"
CMD_DST="$HOME/.claude/commands/commit-as-prompt.md"

# 安装agents
AGENT_SRC_DIR="$SCRIPT_DIR/kingkongshot_prompts/prompts/claude/agents"
AGENT_DST_DIR="$HOME/.claude/agents"

echo "开始安装Claude配置..."

# 创建目录
mkdir -p "$(dirname "$CMD_DST")" || { echo "创建命令目录失败"; exit 1; }
mkdir -p "$AGENT_DST_DIR" || { echo "创建agents目录失败"; exit 1; }

# 拷贝命令文件
if cp "$CMD_SRC" "$CMD_DST"; then
    echo "✓ commit-as-prompt命令安装成功"
else
    echo "✗ commit-as-prompt命令安装失败"
    exit 1
fi

# 拷贝agent文件
agents=("memory-network-builder.md" "library-usage-researcher.md")
for agent in "${agents[@]}"; do
    if cp "$AGENT_SRC_DIR/$agent" "$AGENT_DST_DIR/"; then
        echo "✓ $agent 安装成功"
    else
        echo "✗ $agent 安装失败"
        exit 1
    fi
done

echo ""
echo "开始安装MCP服务器..."

# 安装Context7 MCP
echo "安装Context7 MCP..."
if claude mcp add --transport http context7 https://mcp.context7.com/mcp; then
    echo "✓ Context7 MCP安装成功"
else
    echo "✗ Context7 MCP安装失败"
fi

# 安装Grep MCP
echo "安装Grep MCP..."
if claude mcp add --transport http grep https://mcp.grep.app; then
    echo "✓ Grep MCP安装成功"
else
    echo "✗ Grep MCP安装失败"
fi

echo ""
echo "🎉 Claude配置安装完成！"