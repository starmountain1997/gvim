# Simple Alacritty Installer
param([string]$Theme = "dracula")

$ErrorActionPreference = "Stop"

Write-Host "Installing Alacritty with theme: $Theme" -ForegroundColor Cyan

# Path definitions
$ConfigDir = "$env:APPDATA\alacritty"
$ThemesDir = "$ConfigDir\themes"
$ScriptDir = Split-Path -Parent $PSCommandPath
if (-not $ScriptDir) { $ScriptDir = Get-Location }

$SourceTheme = "$ScriptDir\alacritty-theme\themes\${Theme}.toml"
$TargetTheme = "$ThemesDir\${Theme}.toml"
$ConfigFile = "$ConfigDir\alacritty.toml"

# Check theme file
if (-not (Test-Path $SourceTheme)) {
    Write-Host "ERROR: Theme file not found: $SourceTheme" -ForegroundColor Red
    exit 1
}

# Create directories and copy files
Write-Host "Creating directories and copying files..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
New-Item -ItemType Directory -Path $ThemesDir -Force | Out-Null

Copy-Item $SourceTheme $TargetTheme -Force
Copy-Item "$ScriptDir\alacritty-windows.toml" $ConfigFile -Force

# Update theme name in config file
$ConfigContent = Get-Content -Path $ConfigFile -Raw
$ConfigContent = $ConfigContent -replace 'dracula\.toml', "$Theme.toml"
Set-Content -Path $ConfigFile -Value $ConfigContent -Encoding UTF8

Write-Host "Alacritty configured successfully!" -ForegroundColor Green
Write-Host "Config file: $ConfigFile" -ForegroundColor Cyan