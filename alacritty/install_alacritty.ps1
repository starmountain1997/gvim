# Simple Alacritty Installer
param([string]$Theme = "dracula")

$ErrorActionPreference = "Stop"

Write-Host "Installing Alacritty with theme: $Theme"

$ConfigDir = "$env:APPDATA\alacritty"
$ThemesDir = "$ConfigDir\themes"
$ScriptDir = Split-Path -Parent $PSCommandPath
if (-not $ScriptDir) { $ScriptDir = Get-Location }

$SourceTheme = "$ScriptDir\alacritty-theme\themes\${Theme}.toml"
$TargetTheme = "$ThemesDir\${Theme}.toml"
$ConfigFile = "$ConfigDir\alacritty.toml"

Write-Host "Source: $SourceTheme"
Write-Host "Target: $TargetTheme"

if (-not (Test-Path $SourceTheme)) {
    Write-Host "ERROR: Theme file not found: $SourceTheme" -ForegroundColor Red
    exit 1
}

# Create directories
New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
New-Item -ItemType Directory -Path $ThemesDir -Force | Out-Null

# Copy theme file
Copy-Item $SourceTheme $TargetTheme -Force

# Create config file
$ConfigContent = @"
general.import = [
  "$($TargetTheme.Replace('\', '/'))"
]

[window]
# padding.x = 10
# padding.y = 10

decorations = "Full"
opacity = 0.7
blur = true

[font]
normal = { family = `"FiraCode Nerd Font Mono`", style = `"Retina`" }

[terminal.shell]
program = `"wsl`"
args = ["--cd", `"~`"]

[selection]
save_to_clipboard = true

[mouse]
bindings = [
    { mouse = `"Right`", action = `"Paste`" }
]

[keyboard]
bindings = [
]
"@

Set-Content -Path $ConfigFile -Value $ConfigContent -Encoding UTF8

Write-Host "Alacritty configured successfully!" -ForegroundColor Green
Write-Host "Config file: $ConfigFile" -ForegroundColor Cyan
