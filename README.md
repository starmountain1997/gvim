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
| [jiangmiao/auto-pairs](https://github.com/jiangmiao/auto-pairs) | 自动括号配对 | 自动为括号、引号等符号配对，支持 Fly Mode 快速跳过 |
| [luochen1990/rainbow](https://github.com/luochen1990/rainbow) | 彩虹括号 | 自动为不同层级的括号显示不同颜色 |
| [dominikduda/vim_current_word](https://github.com/dominikduda/vim_current_word) | 高亮当前单词 | 自动高亮光标下的单词及所有相同单词 |
| [prabirshrestha/vim-lsp](https://github.com/prabirshrestha/vim-lsp) | LSP 客户端 | 为 Vim 提供语言服务器协议支持 |
| [mattn/vim-lsp-settings](https://github.com/mattn/vim-lsp-settings) | LSP 自动配置 | 自动检测和配置各种语言服务器 |
| [prabirshrestha/asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim) | 异步补全框架 | 提供强大的异步代码补全功能 |
| [prabirshrestha/asyncomplete-lsp.vim](https://github.com/prabirshrestha/asyncomplete-lsp.vim) | LSP 补全集成 | 将 LSP 与 asyncomplete 集成 |

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

## auto-pairs 自动配对功能说明

auto-pairs 插件提供了智能的括号和引号自动配对功能，大大提升编码效率：

### 核心功能
- **自动配对**: 输入左括号、左引号时自动插入对应的右符号
- **智能跳过**: 在配对符号后输入相同符号时自动跳过，避免重复
- **快速删除**: 删除左符号时自动删除对应的右符号
- **Fly Mode**: 快速跳过配对的右括号，提升编辑流畅度

### 支持的配对符号
- **括号类**: `()`, `[]`, `{}`
- **引号类**: `''`, `""`, `**`
- **多字符**: `<?php?>`, `<!-- -->`, `""" """`
- **多字节**: 支持中文引号等 Unicode 字符配对

### 使用技巧
- **快速跳出**: 在配对的右符号后继续输入即可跳过
- **换行配对**: 在括号内按回车会自动格式化为多行结构
- **嵌套支持**: 完美支持多层嵌套的括号和引号

## vim-lsp Python 开发环境说明

本配置采用 **vim-lsp + vim-lsp-settings** 的组合来提供完整的 Python 开发体验，使用现代的 LSP (Language Server Protocol) 架构：

### vim-lsp-settings - 自动化配置
- **自动检测**: 自动检测系统中安装的语言服务器
- **零配置**: 无需手动配置 pylsp 等语言服务器
- **多语言支持**: 支持 Python、JavaScript、TypeScript、Go、Rust 等多种语言

### asyncomplete.vim - 智能补全系统
- **异步补全**: 提供流畅的代码补全体验，不阻塞编辑
- **LSP 集成**: 与 vim-lsp 完美集成，提供基于语言服务器的智能补全
- **快捷键支持**: 支持 Tab、Enter、Esc 等常用快捷键操作补全菜单

### 功能特性
- **智能补全**: 基于 LSP 的上下文感知代码补全
- **代码导航**: 跳转到定义、查看引用、类型定义等
- **实时诊断**: 编辑时实时显示语法错误和警告
- **悬停文档**: 按 `K` 键查看函数/类的文档
- **代码重构**: 支持变量重命名等重构操作
- **异步处理**: 所有操作都是异步的，保持编辑流畅性

### 使用方法

#### 代码导航与诊断
- **跳转定义**: 使用 `gd` 跳转到光标下对象的定义
- **查看引用**: 使用 `gr` 查找所有引用当前对象的位置
- **类型定义**: 使用 `gt` 跳转到类型定义
- **悬停文档**: 使用 `K` 显示当前对象的文档
- **重命名**: 使用 `<leader>rn` 重命名当前变量/函数
- **诊断导航**: 使用 `[g` 和 `]g` 在错误/警告之间跳转

#### 代码补全
- **自动补全**: 输入时自动弹出补全建议
- **手动触发**: 使用 `Ctrl+Space` 手动触发补全
- **选择确认**: 使用 `Enter` 确认选择，`Esc` 取消补全
- **导航选择**: 使用 `Tab`/`Shift+Tab` 在补全项之间导航


