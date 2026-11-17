# Alacritty Configuration

Alacritty 终端配置文件，包含 Linux/macOS 和 Windows 的配置。

## 安装

### Linux/macOS

```bash
./install_alacritty.sh
```

如果同时使用 Konsole，可以加上 `--konsole`，安装 Alacritty 风格的键位：

```bash
./install_alacritty.sh --konsole
```

- `Ctrl+C` 复制、`Ctrl+V` 粘贴（覆盖 Konsole 的 QAction 快捷键）
- `Ctrl+Shift+C` 发送 `SIGINT`（通过自定义 `Alacritty.keytab`）

如果已有默认 Konsole 配置方案，脚本会先备份，再只修改其 `KeyBindings`；
否则会创建并启用 `Alacritty` 配置方案。重新打开 Konsole 后生效。

### WSL (Windows Subsystem for Linux)

在 WSL 中安装 Alacritty：

```bash
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ./install_alacritty.ps1
```

## 配置文件

- `alacritty-linux.toml` - Linux/macOS 系统的 Alacritty 配置
- `alacritty-windows.toml` - Windows 系统的 Alacritty 配置
- `alacritty-theme/` - Alacritty 主题目录
- `konsole/` - Konsole 键位文件（`--konsole` 时使用）

## 使用

安装脚本会自动将配置文件复制到系统配置目录：

- Linux/macOS: `~/.config/alacritty/alacritty.toml`
- Windows: `%APPDATA%\alacritty\alacritty.toml`
