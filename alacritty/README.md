# Alacritty Configuration

Alacritty 终端配置文件，包含 Linux/macOS 和 Windows 的配置。

## 安装

### Linux/macOS

```bash
./install_alacritty.sh
```

### WSL (Windows Subsystem for Linux)

在 WSL 中安装 Alacritty：

```bash
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ./install_alacritty.ps1
```

## 配置文件

- `alacritty-linux.toml` - Linux/macOS 系统的 Alacritty 配置
- `alacritty-windows.toml` - Windows 系统的 Alacritty 配置
- `alacritty-theme/` - Alacritty 主题目录

## 使用

安装脚本会自动将配置文件复制到系统配置目录：
- Linux/macOS: `~/.config/alacritty/alacritty.toml`
- Windows: `%APPDATA%\alacritty\alacritty.toml`
