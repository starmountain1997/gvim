# Neovim Config

## 基础选项

| 选项 | 说明 |
|------|------|
| `number` | 显示绝对行号 |
| `relativenumber` | 显示相对行号 |
| `cursorline` | 高亮当前行 |

## 重载配置

在 Neovim 命令行中执行：

```
:source $MYVIMRC
```

## 插件列表

| 插件 | 说明 |
|------|------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | 插件管理器 |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git 状态标记（增/删/改） |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | 文件树侧边栏 |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | 文件图标（nvim-tree / render-markdown 依赖） |
| [blink.cmp](https://github.com/saghen/blink.cmp) | 代码补全引擎（LSP / 路径 / 缓冲区） |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Markdown 预览渲染 |
| [neoscroll.nvim](https://github.com/karb94/neoscroll.nvim) | 平滑滚动 |
| [smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim) | 光标平滑动画 |
| [auto-pairs](https://github.com/jiangmiao/auto-pairs) | 自动配对括号/引号 |
| [vim-obsession](https://github.com/tpope/vim-obsession) | 会话管理（自动保存/恢复） |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | 状态栏 |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | 主题配色 |
| [better-whitespace.nvim](https://github.com/ntpeters/vim-better-whitespace) | 尾随空白高亮 |

## LSP 服务器

| 服务器 | 说明 | 适用文件 |
|--------|------|----------|
| [ruff](https://github.com/astral-sh/ruff) | Python 格式化 / 静态检查 | `python` |
| [ty](https://github.com/DetachHead/ty) | Python 类型检查（basedpyright 替代） | `python` |

## 插件配置

### [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)

**配置要点**

- 自定义 sign 符号（`┃` 表示增/改，`_` 表示删）
- 未追踪文件不显示标记 (`attach_to_untracked = false`)
- 默认关闭行内 blame (`current_line_blame = false`)

**基本用法**

- `:Gitsigns toggle_signs` — 显示/隐藏 Git 状态标记
- `:Gitsigns toggle_numhl` — 显示/隐藏行号高亮
- `:Gitsigns toggle_current_line_blame` — 显示/隐藏当前行 blame
- `]c` / `[c` — 跳转到上一个/下一个改动块

### [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)

**快捷键**

| 快捷键 | 说明 |
|--------|------|
| `<leader>e` | 打开/关闭文件树 |

**基本用法**

- `a` — 新建文件（以 `/` 结尾则创建目录）
- `d` — 删除文件/目录
- `r` — 重命名
- `R` — 刷新树
- `x` / `<C-]>` — 水平分割 / 垂直分割打开
- `H` — 切换显示隐藏文件（dotfiles）

### [blink.cmp](https://github.com/saghen/blink.cmp)

**配置要点**

- 使用 Rust 实现的模糊匹配引擎 (`fuzzy.implementation = "rust"`)
- 补全来源：LSP → 路径 → 缓冲区 (`lsp`, `path`, `buffer`)
- `<CR>` 接受补全或回退到默认行为

### [neoscroll.nvim](https://github.com/karb94/neoscroll.nvim)

**快捷键**（平滑滚动）

| 快捷键 | 说明 |
|--------|------|
| `<C-u>` | 向上半屏滚动 |
| `<C-d>` | 向下半屏滚动 |
| `<C-b>` | 向上一屏滚动 |
| `<C-f>` | 向下一屏滚动 |

### [smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim)

**配置要点**

- `stiffness = 0.6` — 光标主体刚度
- `trailing_stiffness = 0.45` — 拖尾刚度
- `damping = 0.85` — 阻尼系数
- 懒加载 (`event = "VeryLazy"`)

### [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)

**配置要点**

- 仅在 Markdown 文件中启用 (`ft = "markdown"`)
- 依赖 treesitter 和 web-devicons

### [auto-pairs](https://github.com/jiangmiao/auto-pairs)

自动补全配对符号：`(` → `()`, `{` → `{}`, `"` → `""` 等，无需额外配置即用。

### [vim-obsession](https://github.com/tpope/vim-obsession)

**配置要点**

- 启动 Neovim 时自动开始记录 (`VimEnter` 执行 `:Obsess`)
- Session 文件保存在当前目录 `Session.vim`

**基本用法**

- `:Obsess` — 开始记录 session
- `:Obsess!` — 停止记录并删除 `Session.vim`
- `nvim . && :source Session.vim` — 恢复上次会话窗口布局
