# Windows Alacritty 配置指南

## 安装步骤

### 1. 安装 PowerShell (如果未安装)
- Windows 10/11 默认已包含 PowerShell
- 或者从 [Microsoft PowerShell](https://learn.microsoft.com/zh-cn/powershell/) 下载

### 2. 安装 Alacritty
- 从 [Alacritty 官网](https://alacritty.org/) 下载 Windows 版本
- 或者通过 winget 安装：`winget install Alacritty.Alacritty`

### 3. 运行配置脚本
```powershell
# 使用默认主题 (dracula)
.\install_alacritty.ps1

# 指定主题
.\install_alacritty.ps1 -Theme tokyonight
```

### 4. 安装字体
下载并安装 [FiraCode Nerd Font Mono](https://www.nerdfonts.com/font-downloads)

## 支持的主题
脚本会从 alacritty-theme submodule 中获取可用主题，常见主题包括：
- dracula (默认)
- tokyonight
- gruvbox-dark
- nord
- solarized-dark

## 配置文件位置
- 配置目录：`%USERPROFILE%\.config\alacritty\`
- 主配置文件：`%USERPROFILE%\.config\alacritty\alacritty.toml`
- 主题文件：`%USERPROFILE%\.config\alacritty\themes\[主题名].toml`

## 执行策略设置
如果遇到执行策略限制，请运行：
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```