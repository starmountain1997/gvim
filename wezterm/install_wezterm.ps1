param(
    [string]$ConfigDir = "$env:USERPROFILE\.config\wezterm"
)

if (-not (Test-Path "wezterm.lua")) {
    Write-Error "wezterm.lua not found."
    exit 1
}

if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
}

Copy-Item "wezterm.lua" "$ConfigDir\wezterm.lua" -Force

Write-Host "WezTerm configuration installed!"
Write-Host ""
Write-Host "Note: The configuration includes TERM='xterm-256color' for optimal SSH compatibility."