#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Alacritty 配置安装脚本 (Windows PowerShell 版本)

.DESCRIPTION
    简化 Windows 上 Alacritty 终端的配置，支持主题选择和字体配置
    支持从 alacritty-theme submodule 复制主题文件

.PARAMETER Theme
    指定要使用的主题名称，默认为 dracula

.EXAMPLE
    .\install_alacritty.ps1
    使用默认主题 dracula

.EXAMPLE
    .\install_alacritty.ps1 -Theme tokyonight
    使用 tokyonight 主题
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$Theme = "dracula"
)

# 错误处理设置
$ErrorActionPreference = "Stop"

# --- Functions ---
function Write-ColorOutput {
    param(
        [string]$Message,
        [ConsoleColor]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# 显示字体提示
Write-ColorOutput "提示: 请确保已安装 'FiraCode Nerd Font Mono' 字体" "Yellow"
Write-ColorOutput "下载地址: https://www.nerdfonts.com/font-downloads" "Yellow"
Write-ColorOutput "使用主题: $Theme" "Yellow"

# Windows 配置路径
$ConfigDir = Join-Path $env:USERPROFILE ".config" | Join-Path -ChildPath "alacritty"
$ThemesDir = Join-Path $ConfigDir "themes"
$ThemeFile = Join-Path $ThemesDir "${Theme}.toml"
$ConfigFile = Join-Path $ConfigDir "alacritty.toml"

# 获取脚本所在目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceTheme = Join-Path $ScriptDir "alacritty-theme" | Join-Path -ChildPath "themes" | Join-Path -ChildPath "${Theme}.toml"

Write-ColorOutput "创建配置目录: $ConfigDir" "Yellow"

# 创建目录结构
New-Item -ItemType Directory -Path $ThemesDir -Force | Out-Null

# 检查主题在 submodule 中是否存在
if (-not (Test-Path $SourceTheme)) {
    Write-ColorOutput "错误: 主题 '$Theme' 在 submodule 中未找到。" "Red"
    Write-ColorOutput "可用主题:" "Yellow"

    $AvailableThemesPath = Join-Path $ScriptDir "alacritty-theme" | Join-Path -ChildPath "themes"
    if (Test-Path $AvailableThemesPath) {
        Get-ChildItem $AvailableThemesPath -Filter "*.toml" |
            Select-Object -First 10 |
            ForEach-Object { $_.BaseName } |
            ForEach-Object { Write-ColorOutput "  - $_" "Cyan" }
    }
    Write-ColorOutput "完整列表: https://github.com/alacritty/alacritty-theme" "Yellow"
    exit 1
}

Write-ColorOutput "从 submodule 复制主题文件..." "Yellow"
Copy-Item $SourceTheme $ThemeFile -Force

Write-ColorOutput "主题 '$Theme' 可用。" "Green"
Write-ColorOutput "创建 alacritty.toml 配置..." "Yellow"

# 创建配置文件
$ConfigContent = @"
general.import = [
  "$($ThemeFile.Replace('\', '/'))"
]

[font]
normal = { family = "FiraCode Nerd Font Mono", style = "Retina" }
"@

Set-Content -Path $ConfigFile -Value $ConfigContent -Encoding UTF8

Write-ColorOutput "Alacritty 配置完成，主题: $Theme" "Green"
Write-ColorOutput "配置文件位置: $ConfigFile" "Cyan"