# gvim 配置

## 安装

```bash
git clone https://github.com/starmountain1997/gvim.git && (cd gvim/vim && sh install_gvim.sh) && rm -rf gvim
```
一些环境下可能无法验证curl，请编辑 `~/.curlrc`，增加 `insecure` 禁用 curl 的 ssl 验证。

对于 Python 用户，请安装 `pyright` 或者 `python-lsp-server` 作为 lsp 服务器。

注意，`pyright` 依赖 `node` 环境。

## 启用的插件及使用方法

| 插件 | 功能 | 使用方法 |
| --- | --- | --- |
| [preservim/nerdtree](https://github.com/preservim/nerdtree) | 文件浏览器 | 按 `F1` 切换显示 |
| [dracula/vim](https://github.com/dracula/vim) | Dracula 主题 | 当前使用的主题 `colorscheme dracula` |
| [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline) | 精美的状态栏 | 自动启用 |
| [vim-airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes) | Airline 主题集合 | 自动加载 |
| [tpope/vim-commentary](https://github.com/tpope/vim-commentary) | 快速注释代码 | 在普通模式或可视模式下，使用 `gcc` 注释/取消注释当前行 |
| [jiangmiao/auto-pairs](https://github.com/jiangmiao/auto-pairs) | 自动括号配对 | 自动为括号、引号等符号配对，支持 Fly Mode 快速跳过 |
| [mhinz/vim-signify](https://github.com/mhinz/vim-signify) | Git 版本控制显示 | 在行号旁显示 Git 变化（新增、修改、删除）的标记 |
| [luochen1990/rainbow](https://github.com/luochen1990/rainbow) | 彩虹括号 | 自动为不同层级的括号显示不同颜色 |
| [dominikduda/vim_current_word](https://github.com/dominikduda/vim_current_word) | 高亮当前单词 | 自动高亮光标下的单词及所有相同单词 |
| [tpope/vim-obsession](https://github.com/tpope/vim-obsession) | 会话管理 | 自动保存和恢复 vim 会话状态，重启后恢复工作环境 |
| [prabirshrestha/vim-lsp](https://github.com/prabirshrestha/vim-lsp) | LSP 客户端 | 为 Vim 提供语言服务器协议支持 |
| [mattn/vim-lsp-settings](https://github.com/mattn/vim-lsp-settings) | LSP 自动配置 | 自动检测和配置各种语言服务器 |
| [prabirshrestha/asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim) | 异步补全框架 | 提供强大的异步代码补全功能 |
| [prabirshrestha/asyncomplete-lsp.vim](https://github.com/prabirshrestha/asyncomplete-lsp.vim) | LSP 补全集成 | 将 LSP 与 asyncomplete 集成 |

## NERDTree 使用教程

NERDTree 是一个强大的文件系统浏览器，本配置中进行了多项优化和增强。

### 基本操作

#### 打开和切换
- **F1** - 切换 NERDTree 显示/隐藏
- `:NERDTreeToggle` - 同 F1 功能
- `:NERDTree` - 打开 NERDTree 并聚焦
- `:NERDTreeFocus` - 将焦点移动到 NERDTree 窗口
- `q` - 在 NERDTree 窗口中退出（如果是最后一个窗口则退出 Vim）

#### 导航操作
- `j/k` - 上下移动光标
- `Enter` - 打开文件/展开目录
- `o` - 在新窗口中打开文件
- `t` - 在新标签页中打开文件
- `i` - 水平分割窗口打开文件
- `s` - 垂直分割窗口打开文件
- `p` - 跳转到父节点
- `P` - 跳转到根节点
- `Ctrl+w+w` - 在窗口间切换

### 文件操作教程

#### 新增文件/文件夹
1. **新增文件**：
   - 移动到目标目录位置
   - 按 `m` 打开菜单
   - 按 `a` (add) 添加子节点
   - 输入文件名（如 `new_file.py`）
   - 按 Enter 确认

2. **新增文件夹**：
   - 移动到目标目录位置
   - 按 `m` 打开菜单
   - 按 `a` (add) 添加子节点
   - 输入文件夹名（以 `/` 结尾，如 `new_folder/`）
   - 按 Enter 确认

#### 删除文件/文件夹
1. **删除操作**：
   - 移动到要删除的文件/文件夹
   - 按 `m` 打开菜单
   - 按 `d` (delete) 删除
   - 按 `y` 确认删除，或 `n` 取消

2. **批量删除**：
   - 可以先标记多个文件，然后批量删除

#### 移动文件/文件夹
1. **移动操作**：
   - 移动到要移动的文件/文件夹
   - 按 `m` 打开菜单
   - 按 `m` (move/rename) 移动或重命名
   - 输入新的位置或名称
   - 按 Enter 确认

2. **复制操作**：
   - 移动到要复制的文件/文件夹
   - 按 `m` 打开菜单
   - 按 `c` (copy) 复制
   - 输入新的位置或名称
   - 按 Enter 确认

### 高级功能

#### 搜索和过滤
- `/` - 搜索文件/目录名
- `n` - 跳转到下一个搜索结果
- `N` - 跳转到上一个搜索结果
- `I` - 切换显示隐藏文件
- `f` - 切换文件过滤
- `F` - 切换文件排序

#### 书签功能
- `B` - 打开书签菜单
- `:Bookmark <name>` - 为当前位置创建书签
- `:BookmarkToRoot <name>` - 创建书签并设为根节点

#### 其他实用功能
- `r` - 刷新当前目录
- `R` - 刷新根目录
- `cd` - 将 Vim 当前工作目录设置为 NERDTree 选中目录
- `CD` - 将 NERDTree 根目录设置为 Vim 当前工作目录
- `u` - 切换显示上级目录

### 配置增强说明

#### 自动打开功能
- 启动 Vim 时如果没有指定文件，会自动打开 NERDTree
- 如果指定了目录作为参数，会自动打开该目录的 NERDTree 视图
- 当 NERDTree 是最后一个窗口时，会自动退出 Vim

#### 文件过滤设置
自动忽略以下文件和目录：
- `__pycache__/` - Python 缓存目录
- `.*\.egg-info$` - Python 包信息文件
- `.claude` - Claude 相关文件
- 其他常见的临时文件和构建产物

#### 显示设置
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

## vim-signify Git 版本控制功能说明

vim-signify 是一个强大的 Git 版本控制可视化插件，能够在编辑器中直观地显示文件的修改状态：

### 核心功能
- **变更标记**: 在行号旁显示不同符号表示文件的变更状态
- **多种 VCS 支持**: 支持 Git、SVV、Mercurial 等多种版本控制系统
- **实时更新**: 文件保存时自动更新变更标记
- **差异预览**: 快速查看修改前后的差异

### 标记符号说明
vim-signify 使用不同符号来表示各种变更状态：
- **`~`** - 修改的行（Modified）
- **`+`** - 新增的行（Added）
- **`-`** - 删除的行（Deleted）
- **`>`** - 从其他文件修改而来的行（Modified）
- **`<`** - 修改后将移动到其他文件的行（Modified）

### 基本快捷键
- **`[c`** - 跳转到上一个变更处
- **`]c`** - 跳转到下一个变更处
- **`:SignifyDiff`** - 显示当前文件与版本库的差异
- **`:SignifyDiffCurrent`** - 显示当前光标所在行的变更
- **`:SignifyHunkDiff`** - 显示当前代码块的详细差异
- **`:SignifyFold`** - 折叠未修改的代码，只显示变更部分

### 代码块操作
- **`:SignifyHunkUndo`** - 撤销当前代码块的修改
- **`:SignifyHunkAdd`** - 将当前代码块添加到暂存区
- **`:SignifyHunkPrev`** - 跳转到上一个代码块
- **`:SignifyHunkNext`** - 跳转到下一个代码块

### 实用功能
- **自动检测**: 打开文件时自动检测并显示变更状态
- **状态栏集成**: 在 airline 状态栏中显示变更统计
- **颜色区分**: 使用不同颜色高亮显示各种变更类型
- **性能优化**: 对大文件有良好的性能表现

### 使用场景
1. **代码审查**: 快速定位和理解代码变更
2. **提交前检查**: 确认要提交的修改内容
3. **协作开发**: 直观查看团队成员的修改
4. **调试回滚**: 快速定位问题代码并回滚修改

## vim-obsession 会话管理功能说明

vim-obsession 是一个强大的会话管理插件，能够自动保存和恢复你的 vim 工作环境：

### 核心功能
- **自动会话保存**: 启动会话后自动保存窗口布局、打开的文件、光标位置等状态
- **会话恢复**: 重启 vim 时自动恢复上次的工作状态
- **无缝工作流**: 关闭 vim 再重新打开，完全恢复到离开时的状态

### 基本使用方法

#### 启动会话管理
- **`:Obsess`** - 开始在当前目录跟踪会话（创建 Session.vim 文件）
- **`:Obsess!`** - 强制开始会话（覆盖现有会话文件）

#### 停止会话管理
- **`:Obsess!`**（当会话已激活时）- 停止跟踪会话并删除 Session.vim 文件

### 自动恢复机制
本配置已设置自动恢复功能：
- 当 vim 启动时，如果当前目录存在 `Session.vim` 文件，会自动加载会话
- 无需手动执行任何命令，直接恢复到上次的工作状态

### 实际使用场景

#### 项目开发工作流
1. **开始工作**: 在项目根目录执行 `:Obsess`
2. **正常开发**: 打开多个文件、分割窗口、调整布局
3. **结束工作**: 直接关闭 vim，会话状态已自动保存
4. **继续工作**: 重新打开 vim，自动恢复到之前的状态

#### 多项目切换
- 每个项目目录可以有独立的会话文件
- 在不同项目间切换时，各自的工作状态完全独立
- 无需担心项目间的状态干扰

### 会话保存的内容
- **文件列表**: 所有打开的文件和标签页
- **窗口布局**: 分割窗口的大小和位置
- **光标位置**: 每个文件中的光标位置
- **跳转历史**: 在文件间的跳转记录
- **寄存器内容**: 复制粘贴的内容
- **各种标记**: 手动设置的标记点

### 最佳实践
1. **项目根目录使用**: 在项目根目录启动会话，便于管理整个项目
2. **版本控制**: 将 `Session.vim` 添加到 `.gitignore`，避免提交个人工作状态
3. **定期清理**: 项目完成后使用 `:Obsess!` 停止会话，删除会话文件


