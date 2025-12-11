# Neovim 配置项目

这是一个便利的 Neovim 配置项目，提供了现代化的开发环境设置。

## 安装

运行安装脚本来配置 Neovim：

```bash
./install_neovim.sh
```

**前置要求**：
在运行安装脚本之前，请确保已安装必要的编译工具：
```bash
sudo apt install build-essential
```

该脚本会：
- 创建 `~/.config` 目录
- 清理旧的 nvim 配置
- 复制当前配置到 `~/.config/nvim`

## 插件特性

### blink.cmp 自动补全

项目集成了 blink.cmp 作为代码自动补全插件。

#### 编译要求

**重要**：blink.cmp 需要使用 Rust 编译，在安装前需要先安装必要的编译工具：

```bash
sudo apt install build-essential
```

#### 安装 Rust nightly

由于 blink.cmp 需要使用 Rust nightly 版本编译，请按照以下步骤安装 Rust 工具链：

1. **安装 Rust**（如果尚未安装）：
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

2. **按照提示完成安装**：
   - 输入 `1` 选择默认安装
   - 安装完成后，重新加载环境变量：
```bash
source ~/.cargo/env
```

3. **安装并切换到 nightly 工具链**：
```bash
rustup toolchain install nightly
rustup default nightly
```

4. **验证安装**：
```bash
rustc --version
cargo --version
```

确保显示的版本包含 `nightly` 字样。

5. **（可选）同时保留 stable 工具链**：
如果你想要同时使用 stable 和 nightly，可以：
```bash
rustup toolchain install stable
rustup default stable
# 在需要时切换到 nightly
rustup override set nightly  # 在项目目录中设置
```

确保你的开发环境已正确配置好 Rust nightly 工具链。

### nvim-tree 文件浏览器

项目集成了 nvim-tree 插件，提供强大的文件管理功能。

#### 主要快捷键

**打开/关闭文件树**：
- **`<C-n>`** (Ctrl + n) - 切换文件树显示/隐藏

**其他有用命令**：
- **`:NvimTreeToggle`** - 打开或关闭文件树
- **`:NvimTreeFocus`** - 打开并聚焦到文件树
- **`:NvimTreeFindFile`** - 在文件树中找到并聚焦当前文件

#### 文件操作快捷键

**导航**：
- **`j`/`k`** - 上下移动光标
- **`h`** - 折叠目录
- **`l`** - 展开目录/打开文件
- **`Enter`** - 打开文件或目录

**文件操作**：
- **`t`** - 在新标签页打开文件
- **`v`** - 垂直分屏打开文件
- **`x`** - 水平分屏打开文件
- **`a`** - 创建新文件
- **`d`** - 删除文件
- **`r`** - 重命名文件

**其他功能**：
- **`g?`** - 显示帮助菜单
- **`H`** - 显示/隐藏隐藏文件
- **`/`** - 搜索文件
- **`<C-r>`** - 刷新目录

#### 配置说明

nvim-tree 当前配置包括：
- 区分大小写排序
- 文件浏览器宽度设置为 30
- 空目录分组显示
- 显示隐藏文件（以 `.` 开头的文件）

## 编辑器配置

### 基本编辑设置

项目配置了现代化的编辑器设置，提升开发体验：

**行号显示**：
- 绝对行号 + 相对行号模式，便于快速跳转和定位

**高亮功能**：
- 当前行高亮（`cursorline`）- 清晰显示当前编辑位置
- 当前列高亮（`cursorcolumn`）- 垂直对齐辅助线

**缩进设置**：
- Tab 键转换为 4 个空格，确保代码风格一致
- 智能缩进，自动适应不同编程语言
- 软制表符设置，编辑体验更流畅

**鼠标支持**：
- 启用全模式鼠标支持，可用鼠标进行：
  - 光标定位
  - 文本选择
  - 滚轮滚动
  - 窗口调整

## 主题

项目使用 catppuccin 颜色主题，提供了美观的界面配色。

## 文件结构

```
nvim/
├── init.lua              # 主配置文件
└── lua/
    ├── config/
    │   └── lazy.lua      # lazy.nvim 插件管理器配置
    └── plugins/
        ├── catppuccin.lua # catppuccin 主题配置
        └── nvim-tree.lua  # nvim-tree 插件配置
```

## 使用说明

1. 首次运行 Neovim 时，lazy.nvim 会自动安装所有配置的插件
2. 使用 `<C-n>` 打开文件浏览器
3. 按 `g?` 查看完整的快捷键帮助
4. 使用 `/` 搜索文件，按 `<C-c>` 取消搜索

## 更新配置

修改配置文件后，重启 Neovim 即可生效。如果修改了插件配置，可能需要重新运行安装脚本。
