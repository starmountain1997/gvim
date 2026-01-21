"""CLI entry point for uv-init-dev."""

import json
import subprocess
from pathlib import Path

import typer

app = typer.Typer()


def run_cmd(cmd: list[str], check: bool = True) -> subprocess.CompletedProcess:
    """Run command and print output."""
    typer.echo(f"Running: {' '.join(cmd)}")
    return subprocess.run(cmd, check=check)


@app.command()
def main(
    name: str = typer.Option(None, help="项目名称（可选，传给 uv init）"),
) -> None:
    """初始化 uv 项目并配置开发环境。

    执行以下操作：
    1. uv init
    2. uv add --dev ruff autoflake isort basedpyright
    3. 创建 .claude 目录和 config.json
    4. 复制 CLAUDE.md.bat -> CLAUDE.md
    5. 创建软链接 GEMINI.md -> CLAUDE.md
    6. 复制 format_all.sh 到项目根目录
    """
    cwd = Path.cwd()

    # 1. uv init
    typer.echo("=== Initializing uv project ===")
    cmd = ["uv", "init"]
    if name:
        cmd.append(name)
    run_cmd(cmd)

    # 2. 添加开发依赖
    typer.echo("=== Adding development dependencies ===")
    run_cmd(["uv", "add", "ruff", "autoflake", "isort", "basedpyright", "--dev"])

    # 3. 创建 .claude 目录和配置
    typer.echo("=== Creating .claude directory ===")
    claude_dir = cwd / ".claude"
    claude_dir.mkdir(exist_ok=True)

    typer.echo("=== Creating config.json with all permissions ===")
    config = {
        "allowedTools": ["*"],
        "allowedBashCommands": ["*"],
        "allowedPaths": ["*"],
    }
    config_file = claude_dir / "config.json"
    config_file.write_text(json.dumps(config, indent=2) + "\n")

    # 4. 复制 CLAUDE.md.bat -> CLAUDE.md
    claude_md_bat = Path(__file__).parent.parent.parent / "CLAUDE.md.bat"
    if claude_md_bat.exists():
        typer.echo("=== Copying CLAUDE.md.bat to CLAUDE.md ===")
        claude_md = cwd / "CLAUDE.md"
        claude_md.write_text(claude_md_bat.read_text())

    # 5. 创建软链接 GEMINI.md -> CLAUDE.md
    typer.echo("=== Creating GEMINI.md symlink ===")
    gemini_md = cwd / "GEMINI.md"
    if gemini_md.exists():
        gemini_md.unlink()
    gemini_md.symlink_to("CLAUDE.md")

    # 6. 复制 format_all.sh
    format_all_sh = Path(__file__).parent.parent / "format_all.sh"
    if format_all_sh.exists():
        typer.echo("=== Copying format_all.sh ===")
        target = cwd / "format_all.sh"
        target.write_text(format_all_sh.read_text())
        target.chmod(0o755)

    typer.echo("=== Done! ===")
