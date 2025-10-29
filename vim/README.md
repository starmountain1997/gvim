# gvim 配置

## 安装

```bash
git clone https://github.com/starmountain1997/gvim.git && (cd gvim/vim && sh install_gvim.sh) && rm -rf gvim
```
一些环境下可能无法验证curl，请编辑 `~/.curlrc`，增加 `insecure` 禁用 curl 的 ssl 验证。

对于 Python 用户，请安装 `pyright` 或者 `python-lsp-server` 作为 lsp 服务器。

注意，`pyright` 依赖 `node` 环境。

## 启用的插件

| 插件 | 功能 |
| --- | --- |
| [preservim/nerdtree](https://github.com/preservim/nerdtree) | 文件浏览器 |
| [dracula/vim](https://github.com/dracula/vim) | Dracula 主题 |
| [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline) | 精美的状态栏 |
| [vim-airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes) | Airline 主题集合 |
| [tpope/vim-commentary](https://github.com/tpope/vim-commentary) | 快速注释代码 |
| [luochen1990/rainbow](https://github.com/luochen1990/rainbow) | 彩虹括号 |
| [dominikduda/vim_current_word](https://github.com/dominikduda/vim_current_word) | 高亮当前单词 |
| [wellle/context.vim](https://github.com/wellle/context.vim) | 上下文显示（滚动时冻结函数声明） |
| [tpope/vim-obsession](https://github.com/tpope/vim-obsession) | 会话管理 |
| [prabirshrestha/vim-lsp](https://github.com/prabirshrestha/vim-lsp) | LSP 客户端 |
| [mattn/vim-lsp-settings](https://github.com/mattn/vim-lsp-settings) | LSP 自动配置 |
| [prabirshrestha/asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim) | 异步补全框架 |
| [prabirshrestha/asyncomplete-lsp.vim](https://github.com/prabirshrestha/asyncomplete-lsp.vim) | LSP 补全集成 |
| [puremourning/vimspector](https://github.com/puremourning/vimspector) | 现代化调试器支持 |
| [ojroques/vim-oscyank](https://github.com/ojroques/vim-oscyank) | 终端系统剪贴板支持 |

## Vim 原生功能说明

### Vim 终端操作说明

Vim 8.0+ 内置了终端功能，可以在编辑器中直接使用 shell 命令，无需切换窗口：

#### 基本终端操作

**打开终端**：
- `:terminal` 或 `:term` - 在新窗口中打开终端
- `:terminal <command>` - 直接执行指定命令
- `:vertical terminal` - 垂直分割窗口打开终端
- `:terminal ++curwin` - 在当前窗口中打开终端

**终端模式切换**：
- 在终端窗口中：
  - `Ctrl+w N` - 从终端模式切换到普通模式（Normal Mode）
  - `i` 或 `a` - 从普通模式回到终端模式（Terminal Mode）
  - `Ctrl+w w` - 在窗口间切换

**关闭终端**：
- 在终端模式下：`exit` 或 `Ctrl+d` - 正常退出终端
- 在普通模式下：`:q` 或 `:q!` - 关闭终端窗口
- `Ctrl+w c` - 关闭当前窗口（包括终端）

#### 实用技巧

**窗口管理**：
- `Ctrl+w h/j/k/l` - 在分割窗口间移动光标
- `Ctrl+w =` - 让所有窗口等大
- `Ctrl+w +/_` - 增大/减小当前窗口高度

**命令执行**：
- `:!command` - 执行单个 shell 命令（不打开终端窗口）
- `:read !command` - 将命令输出插入到当前文件

**终端配置**：
- 默认使用系统的默认 shell
- 可以通过 `:set shell=/bin/bash` 修改使用的 shell

#### 使用场景

1. **快速测试** - 运行测试脚本而无需离开 vim
2. **Git 操作** - 执行 git 命令进行版本控制
3. **编译构建** - 运行编译或构建命令
4. **文件管理** - 使用 shell 命令进行文件操作

## 插件功能说明

### NERDTree 使用教程

NERDTree 是一个强大的文件系统浏览器，本配置中进行了多项优化和增强。

#### 基本操作

##### 打开和切换
- **F1** - 切换 NERDTree 显示/隐藏
- `:NERDTreeToggle` - 同 F1 功能
- `:NERDTree` - 打开 NERDTree 并聚焦
- `:NERDTreeFocus` - 将焦点移动到 NERDTree 窗口
- `q` - 在 NERDTree 窗口中退出（如果是最后一个窗口则退出 Vim）

##### 导航操作
- `j/k` - 上下移动光标
- `Enter` - 打开文件/展开目录
- `o` - 在新窗口中打开文件
- `t` - 在新标签页中打开文件
- `i` - 水平分割窗口打开文件
- `s` - 垂直分割窗口打开文件
- `p` - 跳转到父节点
- `P` - 跳转到根节点
- `Ctrl+w+w` - 在窗口间切换

#### 文件操作教程

##### 新增文件/文件夹
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

##### 删除文件/文件夹
1. **删除操作**：
   - 移动到要删除的文件/文件夹
   - 按 `m` 打开菜单
   - 按 `d` (delete) 删除
   - 按 `y` 确认删除，或 `n` 取消

2. **批量删除**：
   - 可以先标记多个文件，然后批量删除

##### 移动文件/文件夹
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

#### 高级功能

##### 搜索和过滤
- `/` - 搜索文件/目录名
- `n` - 跳转到下一个搜索结果
- `N` - 跳转到上一个搜索结果
- `I` - 切换显示隐藏文件
- `f` - 切换文件过滤
- `F` - 切换文件排序

##### 书签功能
NERDTree 的书签功能可以让你快速标记和访问常用的文件或目录：

**创建书签**：
- `:Bookmark <name>` - 为当前位置创建书签（光标所在的文件/目录）
- `:BookmarkToRoot <name>` - 创建书签并将 NERDTree 根目录设置为该书签位置
- `m` → `b` - 通过菜单创建书签

**管理书签**：
- `B` - 打开书签列表菜单
- 在书签列表中：
  - `Enter` - 跳转到书签位置
  - `d` - 删除书签
  - `m` - 移动/重命名书签
- `:Bookmark! <name>` - 删除指定名称的书签

**书签文件**：
- 书签信息保存在 `~/.NERDTreeBookmarks` 文件中
- 书签是全局的，在所有项目中都可以使用
- 可以手动编辑书签文件来批量管理

**实用技巧**：
- 为常用项目目录创建书签，如 `:Bookmark project-main`
- 为配置文件创建书签，如 `:Bookmark vimrc`
- 书签名称可以包含空格，但不建议使用特殊字符

##### 其他实用功能
- `r` - 刷新当前目录
- `R` - 刷新根目录
- `cd` - 将 Vim 当前工作目录设置为 NERDTree 选中目录
- `CD` - 将 NERDTree 根目录设置为 Vim 当前工作目录
- `u` - 切换显示上级目录

#### 配置增强说明

##### 自动打开功能
- 启动 Vim 时如果没有指定文件，会自动打开 NERDTree
- 如果指定了目录作为参数，会自动打开该目录的 NERDTree 视图
- 当 NERDTree 是最后一个窗口时，会自动退出 Vim

##### 文件过滤设置
自动忽略以下文件和目录：
- `__pycache__/` - Python 缓存目录
- `.*\.egg-info$` - Python 包信息文件
- `.claude` - Claude 相关文件
- 其他常见的临时文件和构建产物

##### 显示设置
- 显示隐藏文件（以点开头的文件）
- 适配当前使用的颜色主题

### vim-commentary 注释功能说明

[vim-commentary](https://github.com/tpope/vim-commentary) 是一个非常高效的注释插件，可以让你快速地注释或取消注释代码行。

#### 核心功能
- **快速注释/取消注释**: 使用简单的快捷键即可操作。
- **支持多种语言**: 自动识别文件类型并使用正确的注释符号（如 `#`, `//`, `/* */` 等）。
- **支持操作符模式**: 可以与 motion 结合使用，实现更灵活的注释。

#### 基本使用方法
- `gcc`: 在普通模式下，注释或取消注释当前行。
- `gc`: 在可视模式下，注释或取消注释所选行。
- `gc` + `motion`: 例如 `gcG` 注释从当前行到文件末尾，`gc5j` 注释当前行及下面5行。
- `gC`: 在普通模式下，注释当前行及以下指定的行数（例如 `5gC`）。

### vim-lsp Python 开发环境说明

本配置采用 **vim-lsp + vim-lsp-settings** 的组合来提供完整的 Python 开发体验，使用现代的 LSP (Language Server Protocol) 架构：

#### vim-lsp-settings - 自动化配置
- **自动检测**: 自动检测系统中安装的语言服务器
- **零配置**: 无需手动配置 pylsp 等语言服务器
- **多语言支持**: 支持 Python、JavaScript、TypeScript、Go、Rust 等多种语言

#### asyncomplete.vim - 智能补全系统
- **异步补全**: 提供流畅的代码补全体验，不阻塞编辑
- **LSP 集成**: 与 vim-lsp 完美集成，提供基于语言服务器的智能补全
- **快捷键支持**: 支持 Tab、Enter、Esc 等常用快捷键操作补全菜单

#### 功能特性
- **智能补全**: 基于 LSP 的上下文感知代码补全
- **代码导航**: 跳转到定义、查看引用、类型定义等
- **实时诊断**: 编辑时实时显示语法错误和警告
- **悬停文档**: 按 `K` 键查看函数/类的文档
- **代码重构**: 支持变量重命名等重构操作
- **代码格式化**: 支持自动格式化，Python 推荐使用 Ruff
- **异步处理**: 所有操作都是异步的，保持编辑流畅性

#### 使用方法

##### 代码导航与诊断
- **跳转定义**: 使用 `gd` 跳转到光标下对象的定义
- **查看引用**: 使用 `gr` 查找所有引用当前对象的位置
- **类型定义**: 使用 `gt` 跳转到类型定义
- **悬停文档**: 使用 `K` 显示当前对象的文档
- **重命名**: 使用 `<leader>rn` 重命名当前变量/函数
- **诊断导航**: 使用 `[g` 和 `]g` 在错误/警告之间跳转

##### 代码格式化操作
- **格式化当前文件**: 使用 `<leader>f` 或执行 `:LspDocumentFormat`
- **格式化选中范围**: 先在可视模式下选中代码，然后执行 `:LspDocumentRangeFormat`
- **格式化当前行**: 使用 `:LspFormat`（不选中任何内容时）
- **保存时自动格式化**: 可在配置中启用保存时自动格式化功能

##### 代码补全
- **自动补全**: 输入时自动弹出补全建议
- **手动触发**: 使用 `Ctrl+Space` 手动触发补全
- **选择确认**: 使用 `Enter` 确认选择，`Esc` 取消补全
- **导航选择**: 使用 `Tab`/`Shift+Tab` 在补全项之间导航

##### LSP 窗口和列表操作

**引用列表操作 (gr 命令)**：
- `gr` - 查找所有引用当前对象的位置，会弹出引用列表
- 在引用列表窗口中：
  - `Enter` - 跳转到选中的引用位置
  - `q` 或 `Esc` - 关闭引用列表窗口
  - `Ctrl+w w` - 切换回主编辑窗口
  - `Ctrl+w c` - 关闭引用列表窗口
  - `:q` 或 `:close` - 关闭引用列表窗口

**其他 LSP 窗口关闭**：
- **诊断窗口**: 按 `Esc` 或 `q` 关闭
- **悬停文档**: 按 `Esc` 或 `q` 关闭文档窗口
- **定义窗口**: 按 `Esc` 或 `q` 关闭预览窗口
- **通用关闭**: `Ctrl+w w` 切换窗口，然后在目标窗口按 `q` 关闭

**快速操作技巧**：
- 引用列表打开后，按 `Ctrl+w h/j/k/l` 快速在窗口间移动
- 使用 `:only` 关闭所有其他窗口，只保留当前主编辑窗口
- 如果窗口卡住，可以尝试 `Ctrl+w q` 强制关闭当前窗口

##### 代码格式化功能

vim-lsp 提供了强大的代码格式化功能，支持多种语言的自动格式化：

**基本格式化命令**：
- `:LspDocumentFormat` - 格式化整个当前文件
- `:LspDocumentRangeFormat` - 格式化选中的代码范围（需要先在可视模式下选择）
- `:LspFormat` - 格式化当前行或选中范围

**快捷键设置**：
- 本配置中可以自定义快捷键，如 `<leader>f` 格式化当前文件
- 支持格式化同步和异步两种模式

**格式化配置**：
- 支持配置格式化选项（缩进、换行等）
- 可以为不同项目设置不同的格式化规则
- 支持保存时自动格式化

**Python Ruff 格式化**：

对于 Python 开发，推荐使用 **Ruff** 作为格式化工具，它比 Black 更快且功能更全面：

**安装 Ruff**：
```bash
pip install ruff
# 或者使用 uv（推荐的 Python 包管理器）
uv add ruff --dev
```

**Ruff 配置文件**：
在项目根目录创建 `pyproject.toml` 或 `ruff.toml`：

```toml
[tool.ruff]
# 指定目标 Python 版本
target-version = "py38"

# 行长度限制
line-length = 88

[tool.ruff.lint]
# 启用的规则集
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # pyflakes
    "I",   # isort
    "B",   # flake8-bugbear
    "C4",  # flake8-comprehensions
    "UP",  # pyupgrade
]

# 忽略的规则
ignore = [
    "E501",  # line too long, handled by black
    "B008",  # do not perform function calls in argument defaults
]

[tool.ruff.format]
# 使用双引号
quote-style = "double"
# 缩进风格
indent-style = "space"
# 行尾风格
line-ending = "auto"
```

**使用 Ruff 格式化**：
- **手动格式化**：在 vim 中按 `<leader>f` 或执行 `:LspDocumentFormat`
- **命令行格式化**：`ruff format file.py`
- **批量格式化**：`ruff format .`
- **检查和格式化**：`ruff check --fix .`

**Ruff vs Black 对比**：
- **性能**：Ruff 比 Black 快 10-100 倍
- **功能**：Ruff 同时提供 Linting 和格式化
- **兼容性**：Ruff 与 Black 高度兼容，可以作为 Black 的替代品
- **配置**：Ruff 配置更灵活，支持细粒度规则控制

**格式化最佳实践**：
1. **项目统一**：团队内使用相同的格式化配置
2. **Git Hook**：在提交前自动运行格式化检查
3. **IDE 集成**：在 vim/VSCode 等编辑器中启用保存时格式化
4. **CI/CD**：在持续集成中检查代码格式

**其他语言格式化工具**：
- **JavaScript/TypeScript**: Prettier
- **Go**: gofmt
- **Rust**: rustfmt
- **JSON/YAML**: Prettier

### vim-obsession 会话管理功能说明

vim-obsession 是一个强大的会话管理插件，能够自动保存和恢复你的 vim 工作环境：

#### 核心功能
- **自动会话保存**: 启动会话后自动保存窗口布局、打开的文件、光标位置等状态
- **会话恢复**: 重启 vim 时自动恢复上次的工作状态
- **无缝工作流**: 关闭 vim 再重新打开，完全恢复到离开时的状态

#### 基本使用方法

##### 启动会话管理
- **`:Obsess`** - 开始在当前目录跟踪会话（创建 Session.vim 文件）
- **`:Obsess!`** - 强制开始会话（覆盖现有会话文件）

##### 停止会话管理
- **`:Obsess!`**（当会话已激活时）- 停止跟踪会话并删除 Session.vim 文件

#### 自动恢复机制
本配置已设置自动恢复功能：
- 当 vim 启动时，如果当前目录存在 `Session.vim` 文件，会自动加载会话
- 无需手动执行任何命令，直接恢复到上次的工作状态

#### 实际使用场景

##### 项目开发工作流
1. **开始工作**: 在项目根目录执行 `:Obsess`
2. **正常开发**: 打开多个文件、分割窗口、调整布局
3. **结束工作**: 直接关闭 vim，会话状态已自动保存
4. **继续工作**: 重新打开 vim，自动恢复到之前的状态

##### 多项目切换
- 每个项目目录可以有独立的会话文件
- 在不同项目间切换时，各自的工作状态完全独立
- 无需担心项目间的状态干扰

#### 会话保存的内容
- **文件列表**: 所有打开的文件和标签页
- **窗口布局**: 分割窗口的大小和位置
- **光标位置**: 每个文件中的光标位置
- **跳转历史**: 在文件间的跳转记录
- **寄存器内容**: 复制粘贴的内容
- **各种标记**: 手动设置的标记点

#### 最佳实践
1. **项目根目录使用**: 在项目根目录启动会话，便于管理整个项目
2. **版本控制**: 将 `Session.vim` 添加到 `.gitignore`，避免提交个人工作状态
3. **定期清理**: 项目完成后使用 `:Obsess!` 停止会话，删除会话文件

### vim-oscyank 终端剪贴板功能说明

vim-oscyank 是一个强大的终端剪贴板插件，通过 OSC 52 转义序列实现 vim 与系统剪贴板的无缝集成，特别适用于 SSH 远程连接和容器环境。

#### 核心功能
- **自动复制**: 执行复制操作时自动将内容复制到系统剪贴板
- **无长度限制**: 支持复制大量文本，不受默认长度限制
- **终端兼容**: 支持大多数现代终端（iTerm2、Alacritty、Kitty、WezTerm 等）
- **SSH 友好**: 通过 SSH 连接时也能正常使用系统剪贴板

#### 工作原理
vim-oscyank 使用 OSC 52 转义序列，这是终端的标准协议：
1. vim 将要复制的内容编码为 base64
2. 通过 OSC 52 序列发送给终端
3. 终端将内容设置到系统剪贴板
4. 可以在任何支持 OSC 52 的终端中使用

#### 配置说明
本配置已按照官方最佳实践进行优化：
- `g:oscyank_max_length = 0` - 无长度限制，支持复制大量文本
- `g:oscyank_silent = 1` - 禁用成功复制的消息提示
- 智能自动触发：仅在剪贴板不可用时自动启用 OSC52 复制
- 多寄存器支持：支持无名寄存器("")、选择寄存器("+")、剪贴板寄存器("*")
- 操作类型支持：复制(y)和删除(d)操作都会触发自动复制

#### 使用方法

##### 自动复制（推荐）
- **普通模式复制**: 使用 `yy` 复制当前行，内容自动进入系统剪贴板
- **可视模式复制**: 使用 `v` 选择文本后按 `y`，内容自动进入系统剪贴板
- **motion 复制**: 使用 `y$`、`yG` 等命令，内容自动进入系统剪贴板

##### 手动复制
如果需要手动控制复制到系统剪贴板：
- `:OSCYankReg "` - 将默认寄存器内容复制到系统剪贴板
- `:OSCYankReg "a` - 将寄存器 a 的内容复制到系统剪贴板
- `:OSCYank` - 复制选中的文本到系统剪贴板

#### 终端兼容性

##### 完全支持的终端
- **iTerm2** (macOS) - 需要在 Preferences > General > Selection 中启用 "Applications in terminal may access clipboard"
- **Alacritty** - 开箱即用
- **Kitty** - 开箱即用
- **WezTerm** - 开箱即用
- **Terminal.app** (macOS) - 部分支持，可能有长度限制

##### 需要配置的终端
- **GNOME Terminal**: 需要启用 OSC 52 支持
- **Konsole**: 需要在配置中启用相关选项
- **xterm**: 支持，但可能有长度限制

##### SSH 使用场景
vim-oscyank 特别适用于 SSH 远程开发：
1. 在本地终端中 SSH 连接到远程服务器
2. 在远程服务器上使用 vim 编辑文件
3. 复制的内容会通过 OSC 52 序列传输到本地终端
4. 内容自动进入本地系统的剪贴板

#### 故障排除

##### 复制不生效
1. **检查终端支持**: 确认使用的终端支持 OSC 52
2. **检查长度限制**: 某些终端对 OSC 52 序列长度有限制
3. **SSH 配置**: 确保 SSH 连接允许转义序列通过

##### 手动测试
在 vim 中执行以下命令测试：
```vim
:echo OSCYankPost('test copy')
```
如果 'test copy' 出现在系统剪贴板中，说明配置正常。

##### 常见问题
- **Tmux**: 需要在 `~/.tmux.conf` 中添加 `set -g allow-passthrough on`
- **Screen**: 可能需要额外配置才能支持 OSC 52
- **Windows Terminal**: 支持度有限，建议使用 WSL2 + 现代终端组合

#### 性能优化
- **大文本复制**: 对于超大文本，复制可能需要一些时间
- **网络延迟**: SSH 使用时，复制速度受网络延迟影响
- **终端性能**: 某些终端处理 OSC 52 序列的性能较差

#### 替代方案
如果 vim-oscyank 无法正常工作，可以考虑：
1. **本地开发**: 使用系统原生的剪贴板支持 (`+` 寄存器)
2. **X11**: 在 Linux 桌面环境中使用 `xclip` 或 `xsel`
3. **Mac**: 在 macOS 中使用 `pbcopy` 和 `pbpaste`
4. **Windows**: 在 Windows 中使用 `clip.exe`

### vimspector 调试器功能说明

vimspector 是一个现代化的 Vim 调试器插件，支持多种语言的调试，提供类似 IDE 的调试体验。

#### 核心功能
- **多语言支持**: 支持 Python、JavaScript、Node.js、Go、Rust、C/C++ 等多种语言
- **可视化调试**: 提供断点、变量查看、调用栈等完整的调试界面
- **灵活配置**: 支持自定义调试器配置和启动参数
- **实时交互**: 支持执行期间修改变量值和表达式求值

#### 基本操作

##### 调试会话控制 (HUMAN 映射)
- **F5** - 开始/继续调试
- **F3** - 停止调试
- **F4** - 重启调试
- **F6** - 暂停调试
- **F9** - 在当前行设置/取消断点
- **<leader>F9** - 在当前行设置条件断点
- **F8** - 添加函数断点
- **<leader>F8** - 运行到光标
- **F10** - 单步跳过 (Step Over)
- **F11** - 单步进入 (Step Into)
- **F12** - 单步跳出 (Step Out)

##### 窗口和界面
- **变量窗口**: 显示当前作用域的所有变量和对象
- **监视窗口**: 可以添加表达式来监视其值的变化
- **调用栈窗口**: 显示函数调用链
- **输出窗口**: 显示调试输出和程序输出

#### Python 调试配置

vimspector 会自动检测 Python 环境并配置调试器。基本调试配置：

```json
{
  "configurations": {
    "Python: Run File": {
      "adapter": "debugpy",
      "configuration": {
        "type": "python",
        "request": "launch",
        "program": "${file}",
        "console": "integratedTerminal",
        "cwd": "${workspaceFolder}"
      }
    },
    "Python: Django": {
      "adapter": "debugpy",
      "configuration": {
        "type": "python",
        "request": "launch",
        "program": "${workspaceFolder}/manage.py",
        "args": ["runserver"],
        "console": "integratedTerminal",
        "cwd": "${workspaceFolder}"
      }
    }
  }
}
```

#### 实际使用流程

##### 基本调试流程
1. **打开文件**: 在 vim 中打开要调试的 Python 文件
2. **设置断点**: 在想要暂停的行按 F9 设置断点
3. **开始调试**: 按 F5 开始调试会话
4. **单步执行**: 使用 F10/F11 逐步执行代码
5. **查看变量**: 在变量窗口中查看当前变量值
6. **继续执行**: 按 F5 继续到下一个断点或程序结束

##### 高级调试技巧
- **条件断点**: 使用 <leader>F9 设置只在特定条件满足时触发的断点
- **函数断点**: 使用 F8 为特定函数设置断点
- **运行到光标**: 使用 <leader>F8 让程序运行到当前光标位置暂停
- **变量监视**: 在监视窗口添加表达式来跟踪复杂对象的变化
- **临时求值**: 在调试过程中执行 Python 表达式查看结果
- **堆栈导航**: 在调用栈窗口中查看函数调用链

#### 支持的语言和调试器

vimspector 支持的主要语言：
- **Python**: debugpy (基于 pydevd)
- **JavaScript/Node.js**: node-debug2
- **Go**: delve
- **Rust**: lldb 或 codelldb
- **C/C++**: gdb 或 lldb
- **Java**: java-debug
- **PHP**: xdebug

#### 配置文件位置

调试配置文件通常保存在：
- 项目根目录: `.vimspector.json`
- 用户配置: `~/.vim/vimspector/`
- 当前目录: `./.vimspector.json`

#### 故障排除

##### 调试器启动失败
1. **检查语言服务器**: 确保相应的调试器已安装
2. **验证配置文件**: 检查 `.vimspector.json` 语法是否正确
3. **环境变量**: 确保 PATH 包含调试器可执行文件

##### 断点不生效
1. **检查文件路径**: 确保文件路径与配置中的路径匹配
2. **代码可执行**: 确保代码是可执行的（语法正确）
3. **调试模式**: 某些调试器需要特定的调试标志

##### 变量显示异常
1. **刷新变量**: 尝试刷新变量窗口
2. **作用域问题**: 检查变量是否在当前作用域内
3. **调试器版本**: 更新到最新版本的调试器适配器

#### 性能优化

- **禁用不必要的功能**: 在配置中关闭不需要的调试功能
- **使用条件断点**: 减少不必要的断点触发
- **合理设置监视**: 避免监视过多的复杂表达式
- **及时清理**: 调试结束后及时停止调试会话

### context.vim 上下文显示功能说明

context.vim 是一个智能上下文显示插件，能够在滚动代码时保持函数声明、类定义、循环语句等代码结构始终可见，完美解决了长函数或类阅读时迷失上下文的问题。

#### 核心功能
- **冻结上下文**: 滚动时自动在顶部显示当前所在的函数、类、循环等结构
- **嵌套显示**: 支持多层嵌套结构的显示（如类→方法→循环→条件）
- **动态更新**: 根据光标位置实时更新显示的上下文内容
- **多语言支持**: 支持 Python、JavaScript、C/C++、Java 等多种编程语言

#### 工作原理
context.vim 通过以下方式实现上下文冻结：
1. **语法分析**: 使用 Vim 的语法解析器识别代码结构
2. **上下文提取**: 自动提取当前光标所在位置的父级代码块
3. **窗口管理**: 在编辑区域顶部创建独立的上下文显示区域
4. **实时同步**: 滚动时动态更新上下文内容

#### 配置说明
本配置已优化 context.vim 的设置：
- `g:context_enabled = 1` - 启用 context.vim 插件
- `g:context_max_lines = 10` - 最多显示 10 行上下文内容
- `g:context_min_lines = 1` - 至少显示 1 行上下文内容
- `g:context_filetype_blacklist = []` - 所有文件类型都启用上下文显示

#### 显示内容类型

根据编程语言不同，context.vim 会显示不同的上下文信息：

##### Python 语言显示内容
- **类定义**: `class Calculator:`
- **函数定义**: `def add(self, num):`
- **方法定义**: 类中的各种方法
- **循环语句**: `for item in items:`
- **条件语句**: `if condition:`
- **异常处理**: `try:`, `except:`
- **上下文管理器**: `with open(file) as f:`

##### 其他语言支持
- **JavaScript**: function, class, if/else, for/while, try/catch
- **C/C++**: 函数定义, 类定义, if/else, for/while, switch
- **Java**: 类定义, 方法定义, if/else, for/while, try/catch

#### 实际使用效果

##### 长函数阅读
当阅读一个包含 100+ 行的长函数时：
- 函数声明会始终显示在顶部
- 可以清楚知道当前正在查看哪个函数
- 即使滚动到函数末尾也不会失去上下文

##### 嵌套结构导航
在包含多层嵌套的复杂代码中：
```python
class DataProcessor:
    def process_data(self, data):
        for item in data:
            if item.is_valid():
                try:
                    # 光标在此处时，上方会显示：
                    # class DataProcessor:
                    #   def process_data(self, data):
                    #     for item in data:
                    #       if item.is_valid():
                    #         try:
                    result = self.transform(item)
                except Exception as e:
                    self.handle_error(e)
```

#### 使用场景

##### 代码审查
- **大文件审查**: 审查长文件时不会迷失在代码结构中
- **复杂逻辑理解**: 快速理解复杂嵌套逻辑的层次结构
- **Bug 定位**: 在复杂代码中定位问题时更容易理解上下文

##### 学习新代码
- **框架源码阅读**: 阅读框架源码时保持清晰的类层次结构
- **算法理解**: 理解复杂算法时始终保持函数签名可见
- **设计模式识别**: 更容易识别和理解设计模式的实现

##### 日常开发
- **长函数维护**: 维护遗留的长函数时提高可读性
- **重构操作**: 重构复杂代码结构时保持方向感
- **调试辅助**: 调试复杂逻辑时快速定位问题所在层次

#### 性能优化

context.vim 针对性能进行了优化：
- **增量解析**: 只解析可见区域附近的代码结构
- **缓存机制**: 缓存已解析的语法结构，减少重复计算
- **延迟更新**: 滚动停止后再更新上下文，避免频繁刷新

#### 配置调优

如果需要根据个人喜好调整配置：

```vim
" 增加最大显示行数（适用于超大屏幕）
let g:context_max_lines = 15

" 减少最小显示行数（节省屏幕空间）
let g:context_min_lines = 1

" 在特定文件类型中禁用（如配置文件）
let g:context_filetype_blacklist = ['json', 'yaml', 'markdown']
```

#### 故障排除

##### 上下文不显示
1. **检查文件类型**: 确保当前文件类型受支持
2. **语法检查**: 确保代码语法正确，无语法错误
3. **插件加载**: 确认插件已正确安装和加载

##### 显示异常
1. **重新加载**: 使用 `:ContextReset` 重置上下文显示
2. **检查配置**: 确认配置参数设置合理
3. **更新插件**: 确保使用最新版本的 context.vim

#### 最佳实践
1. **合理设置行数**: 根据屏幕大小调整 `g:context_max_lines`
2. **配合折叠功能**: 与 Vim 的折叠功能结合使用，效果更佳
3. **快捷键绑定**: 可以绑定快捷键快速切换上下文显示

context.vim 通过智能的上下文显示，大大提升了阅读和理解复杂代码的效率，是处理大型项目和遗留代码的必备工具。