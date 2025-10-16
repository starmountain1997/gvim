# gvim 配置

## 安装

```bash
git clone https://github.com/starmountain1997/gvim.git && (cd gvim && sh install_gvim.sh) && rm -rf gvim
```

## 启用的插件及使用方法

| 插件 | 功能 | 使用方法 |
| --- | --- | --- |
| [preservim/nerdtree](https://github.com/preservim/nerdtree) | 文件浏览器 | 按 `F1` 切换显示 |
| [NLKNguyen/papercolor-theme](https://github.com/NLKNguyen/papercolor-theme) | PaperColor 主题 | 当前使用的主题 `colorscheme PaperColor` |
| [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline) | 精美的状态栏 | 自动启用 |
| [vim-airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes) | Airline 主题集合 | 自动加载 |
| [tpope/vim-commentary](https://github.com/tpope/vim-commentary) | 快速注释代码 | 在普通模式或可视模式下，使用 `gcc` 注释/取消注释当前行 |
| [luochen1990/rainbow](https://github.com/luochen1990/rainbow) | 彩虹括号 | 自动为不同层级的括号显示不同颜色 |
| [dominikduda/vim_current_word](https://github.com/dominikduda/vim_current_word) | 高亮当前单词 | 自动高亮光标下的单词及所有相同单词 |
| [dense-analysis/ale](https://github.com/dense-analysis/ale) | 异步语法检查和代码修复 | 集成 ruff，支持 uv 环境 |

## NERDTree 功能增强说明

NERDTree 文件浏览器在本配置中进行了以下增强：

### 自动打开功能
- 启动 Vim 时如果没有指定文件，会自动打开 NERDTree
- 如果指定了目录作为参数，会自动打开该目录的 NERDTree 视图
- 当 NERDTree 是最后一个窗口时，会自动退出 Vim

### 键位映射
- `F1` - 切换 NERDTree 显示/隐藏

### 文件过滤设置
自动忽略以下文件和目录：
- `__pycache__/` - Python 缓存目录
- `.*\.egg-info$` - Python 包信息文件
- `.claude` - Claude 相关文件
- 其他常见的临时文件和构建产物

### 显示设置
- 显示隐藏文件（以点开头的文件）
- 适配当前使用的颜色主题

## ALE 功能使用说明

本配置集成了 ALE (Asynchronous Lint Engine) 插件，并配置了 Python 最佳实践组合：**pyright + ruff**，完美支持 uv 环境。

### 前置要求
需要安装以下工具：

**使用 uv 安装（推荐）：**
```bash
# 项目级别安装
uv add ruff pyright --dev

# 或者全局安装
uv tool install ruff
```

**使用 pip 安装：**
```bash
pip install ruff pyright
```

### 检查器组合说明
本配置采用业界最佳实践的 Python 代码检查组合：
- **pyright**：强大的类型检查和 LSP 功能，提供智能补全和类型推导
- **ruff**：极快的语法检查、代码风格检查和格式化，比传统工具快 10-100 倍

### uv 环境支持
本配置针对 uv 进行了专门优化：

1. **自动环境检测**：当检测到 `pyproject.toml` 或 `.venv` 目录时，自动使用虚拟环境中的 Python
2. **uv run 集成**：如果系统中安装了 uv，ruff 会通过 `uv run ruff` 执行，确保使用项目正确的依赖版本
3. **跨平台支持**：自动检测 Linux/macOS (`.venv/bin/python`) 和 Windows (`.venv/Scripts/python.exe`) 的 Python 路径

### 功能特性
- **智能类型检查**：pyright 提供准确的类型错误检查和智能补全
- **实时语法检查**：ruff 快速检查 Python 代码语法和风格问题
- **自动格式化**：保存时自动使用 ruff format 格式化代码
- **代码修复**：使用 ruff 的自动修复功能，修复常见问题
- **异步处理**：检查过程不会阻塞编辑操作
- **智能环境切换**：根据项目自动使用正确的 Python 环境

### 使用方法
- **语法检查**：编辑 Python 文件时自动进行，错误会在文件中标记
- **自动修复**：使用 `:ALEFix` 命令修复可自动修复的问题
- **格式化**：**保存时自动格式化**，无需手动操作
- **手动格式化**：使用 `:ALEFix ruff_format` 格式化当前文件
- **手动检查**：使用 `:ALELint` 手动触发检查

### 状态显示
- **状态栏集成**：vim-airline 会显示当前文件的错误和警告数量
- **符号标记**：在行号左侧显示 ✗（错误）和 ⚠（警告）符号
- **命令行提示**：光标停留在错误行时，命令行会显示详细信息

### 代码导航功能（查看变量/函数使用位置）
本配置已启用 ALE 的代码导航功能，可以快速查看变量或函数的定义和使用位置：

#### 快捷键说明
- **`Ctrl + ]`** - 跳转到变量/函数的定义位置
- **`Ctrl + \`** - 查找变量/函数的所有引用位置
- **`Ctrl + t`** - 返回上一个位置（跳转回溯）
- **`Ctrl + k`** - 查看变量/函数的类型信息
- **`Ctrl + i`** - 跳转到实现（适用于 C++ 等语言）

#### 使用场景示例
1. **查看函数定义**：将光标放在函数调用上，按 `Ctrl + ]` 跳转到函数定义
2. **查看所有引用**：将光标放在变量上，按 `Ctrl + \` 查看该变量在哪些地方被使用
3. **快速返回**：跳转后按 `Ctrl + t` 可以返回到原来的位置
4. **查看类型信息**：按 `Ctrl + k` 可以查看变量或函数的类型信息

#### 注意事项
- 这些功能依赖 LSP 服务（如 pyright），确保相关的检查器已正确安装
- 对于 Python 项目，建议使用 uv 安装 pyright：`uv add pyright --dev`
- 跳转功能在大型项目中可能需要几秒钟来初始化索引

### 查看扫描状态的方法
1. **实时查看**：编辑代码时，错误会实时标记在文件中
2. **状态栏**：查看 vim-airline 状态栏显示的错误/警告统计
3. **详细信息**：使用 `:ALEInfo` 命令查看 ALE 的完整配置和运行状态
4. **手动检查**：使用 `:ALELint` 手动触发代码检查
5. **自动修复**：使用 `:ALEFix` 自动修复可修复的问题
6. **导航浏览**：使用 `:ALENext` 和 `:ALEPrevious` 在错误之间跳转

### 配置说明
ALE 在 vimrc 中的核心配置：
- **语法检查器**：pyright + ruff，兼顾类型检查和代码风格
- **修复工具**：ruff（问题修复）+ ruff_format（格式化）
- **自动保存修复**：`let g:ale_fix_on_save = 1` 实现保存时自动格式化
- **性能优化**：配置检查延迟和触发条件，避免频繁检查
- **环境适配**：自动检测 uv 项目和虚拟环境

