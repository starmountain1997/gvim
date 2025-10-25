# WezTerm Configuration

WezTerm 终端配置文件和安装脚本。

## 文件说明

- `wezterm.lua` - WezTerm 配置文件
- `install_wezterm.sh` - Linux/macOS 安装脚本
- `install_wezterm.ps1` - Windows PowerShell 安装脚本

## Windows 安装 (WSL 环境)

如果你在 WSL (Windows Subsystem for Linux) 环境中，可以通过以下方式运行 Windows PowerShell 脚本：

```bash
# 设置当前目录
cd /home/guozr/CODE/gvim/wezterm

# 运行安装脚本（使用默认配置目录）
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ". '\\wsl.localhost\\Ubuntu\\home\\guozr\\CODE\\gvim\\wezterm\\install_wezterm.ps1'"

# 指定自定义配置目录
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ". '\\wsl.localhost\\Ubuntu\\home\\guozr\\CODE\\gvim\\wezterm\\install_wezterm.ps1' -ConfigDir 'C:\\myconfig\\wezterm'"
```

## 路径说明

- WSL 路径：`/home/guozr/CODE/gvim/wezterm/`
- Windows 路径：`\\wsl.localhost\Ubuntu\home\guozr\CODE\gvim\wezterm\`
- 配置目录默认位置：`%USERPROFILE%\.config\wezterm`

## 配置特性

- 终端尺寸：120列 x 28行
- 字体：FiraCode Nerd Font Mono (Retina)
- 颜色主题：Dracula
- 启用滚动条
- 右键粘贴功能
- 默认工作目录：用户主目录

## 应用配置

安装完成后，重启 WezTerm 或使用快捷键 `Ctrl+Shift+R` 重新加载配置。

## Linux/macOS 安装

```bash
# 使用默认配置目录
./install_wezterm.sh

# 指定自定义目录
./install_wezterm.sh ~/myconfig/wezterm
```