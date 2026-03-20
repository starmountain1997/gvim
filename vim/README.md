# gvim — Vim 配置

一套开箱即用的 Vim 配置，集成主题、文件管理、LSP 补全、Git 状态、调试器等常用功能。

______________________________________________________________________

## 安装

```bash
# 默认安装（Python 开发环境）
./install_gvim.sh

# 指定语言（支持 python、javascript、go 等）
./install_gvim.sh python javascript
```

脚本会自动完成以下操作：

1. 安装 vim-plug 插件管理器
1. 将 `vimrc` 部署到 `~/.vimrc`
1. 运行 `:PlugInstall` 安装所有插件
1. 检查所选语言的开发工具是否已安装

______________________________________________________________________

## 插件说明与使用

### 主题与外观

#### [dracula/vim](https://github.com/dracula/vim)

Dracula 暗色主题，自动加载，失败时回退到默认主题。无需额外配置。

#### [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline)

增强状态栏，显示模式、文件名、编码、行号、Git 分支等信息。

- 依赖 Powerline 字体（需提前安装 Nerd Font）
- 状态栏自动显示，无需手动操作

______________________________________________________________________

### 文件浏览与管理

#### [preservim/nerdtree](https://github.com/preservim/nerdtree)

左侧文件树浏览器。

| 快捷键 | 功能 |
|--------|------|
| `F1` | 打开 / 关闭文件树 |
| `<leader>bb` | 为当前节点添加书签（后接书签名） |
| `<leader>bc` | 清除所有书签 |
| `<leader>be` | 编辑书签文件 |

在文件树内：

| 按键 | 功能 |
|------|------|
| `o` | 打开文件 / 展开目录 |
| `s` | 垂直分屏打开 |
| `i` | 水平分屏打开 |
| `t` | 新 tab 打开 |
| `m` | 打开文件操作菜单（新建/删除/重命名） |
| `I` | 切换显示隐藏文件 |
| `?` | 打开帮助 |

> 当 NERDTree 是最后一个窗口时自动退出 Vim。文件保存或切换回 Vim 时自动刷新文件树。

#### [ryanoasis/vim-devicons](https://github.com/ryanoasis/vim-devicons)

在 NERDTree 中为文件和目录显示图标。需安装 Nerd Font 字体并在终端中使用。

#### [tiagofumo/vim-nerdtree-syntax-highlight](https://github.com/tiagofumo/vim-nerdtree-syntax-highlight)

根据文件类型对 NERDTree 中的文件名着色，配合 vim-devicons 使用。

______________________________________________________________________

### 语法与高亮

#### [luochen1990/rainbow](https://github.com/luochen1990/rainbow)

彩虹括号，用不同颜色区分嵌套括号层级，默认启用。

#### [dominikduda/vim_current_word](https://github.com/dominikduda/vim_current_word)

高亮当前光标下的单词及文件中所有相同的单词，帮助快速定位变量引用。自动生效，无需手动操作。

______________________________________________________________________

### 上下文显示

#### [wellle/context.vim](https://github.com/wellle/context.vim)

滚动代码时，在顶部冻结显示当前作用域的函数/类声明，防止迷失上下文。

- 自动启用，最多显示 10 行上下文
- 可用 `:ContextToggle` 临时开关

______________________________________________________________________

### 编辑辅助

#### [tpope/vim-commentary](https://github.com/tpope/vim-commentary)

快速注释 / 反注释代码，自动识别文件类型的注释符号。

| 按键 | 功能 |
|------|------|
| `gcc` | 注释 / 反注释当前行 |
| `gc` + 动作 | 注释指定范围（如 `gc3j` 注释向下 3 行） |
| 可视模式 `gc` | 注释选中区域 |

#### [jiangmiao/auto-pairs](https://github.com/jiangmiao/auto-pairs)

自动补全括号、引号等成对符号，输入左括号时自动插入右括号。

| 按键 | 功能 |
|------|------|
| `(` / `[` / `{` | 自动插入对应右括号 |
| `<BS>` | 同时删除一对空括号 |
| `<M-p>` | 开关 auto-pairs |
| `<M-n>` | 跳到下一个括号 |

#### [mhinz/vim-signify](https://github.com/mhinz/vim-signify)

在行号列旁显示 Git diff 标记（新增 `+`、修改 `~`、删除 `-`）。

| 快捷键 | 功能 |
|--------|------|
| `]c` | 跳到下一个变更 |
| `[c` | 跳到上一个变更 |
| `<leader>hp` | 预览当前变更 hunk |

______________________________________________________________________

### 系统剪贴板

#### [ojroques/vim-oscyank](https://github.com/ojroques/vim-oscyank)

通过 OSC 52 转义序列将内容同步到系统剪贴板，适用于 SSH 远程环境。

- 在剪贴板不可用时自动触发（`y`、`d` 操作均会同步）
- 无需额外操作，复制即自动同步

______________________________________________________________________

### 会话管理

#### [tpope/vim-obsession](https://github.com/tpope/vim-obsession)

持续保存 Vim 会话（打开的文件、窗口布局等），下次启动自动恢复。

| 命令 | 功能 |
|------|------|
| `:Obsession` | 开始记录当前目录的会话（保存到 `Session.vim`） |
| `:Obsession!` | 停止并删除会话文件 |

> 如果当前目录存在 `Session.vim`，启动 Vim 时会自动加载。

______________________________________________________________________

### 代码检查与补全（LSP）

本配置使用 `prabirshrestha/vim-lsp` + `mattn/vim-lsp-settings` + `asyncomplete.vim` 三件套实现 LSP 支持。

#### [prabirshrestha/vim-lsp](https://github.com/prabirshrestha/vim-lsp)

Vim LSP 客户端核心。提供跳转、悬浮文档、诊断等功能。

**全局快捷键：**

| 快捷键 | 功能 |
|--------|------|
| `gd` | 跳转到定义 |
| `gr` | 查看所有引用 |
| `gi` | 跳转到实现 |
| `gt` | 跳转到类型定义 |
| `gs` | 搜索当前文件符号 |
| `gS` | 搜索工作区符号 |
| `K` | 显示悬浮文档 |
| `<leader>rn` | 重命名符号 |
| `[g` | 跳到上一个诊断 |
| `]g` | 跳到下一个诊断 |

诊断信息会在光标移动时自动显示在命令行，不显示行内虚拟文本（避免干扰）。

#### [mattn/vim-lsp-settings](https://github.com/mattn/vim-lsp-settings)

自动安装和配置语言服务器，无需手动配置。

| 命令 | 功能 |
|------|------|
| `:LspInstallServer` | 为当前文件类型安装语言服务器 |
| `:LspUninstallServer` | 卸载语言服务器 |
| `:LspManageServers` | 管理已安装的服务器 |

**Python 配置：** 默认使用 `basedpyright`（需提前安装：`pip install basedpyright`），类型检查模式为 `basic`，支持自动导入补全。

#### [prabirshrestha/asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim) + [asyncomplete-lsp.vim](https://github.com/prabirshrestha/asyncomplete-lsp.vim)

异步补全引擎，与 vim-lsp 集成提供代码补全。

| 按键 | 功能 |
|------|------|
| `↑` / `↓` | 在补全菜单中上下选择 |
| `Enter` | 确认当前选中项 |
| `Ctrl-Y` | 确认选中项（原生方式） |
| `Ctrl-E` | 关闭补全菜单 |

______________________________________________________________________

### 代码调试

#### [puremourning/vimspector](https://github.com/puremourning/vimspector)

可视化调试器，支持 Python、C/C++、Go、JavaScript 等。使用 `HUMAN` 映射模式。

**调试快捷键（HUMAN 模式）：**

| 快捷键 | 功能 |
|--------|------|
| `F5` | 启动调试 / 继续运行 |
| `F3` | 停止调试 |
| `F4` | 重启调试 |
| `F6` | 暂停 |
| `F9` | 切换断点 |
| `F8` | 添加函数断点 |
| `F10` | 单步跳过（Step Over） |
| `F11` | 单步进入（Step Into） |
| `F12` | 单步跳出（Step Out） |

**使用前需在项目根目录创建 `.vimspector.json` 配置文件：**

```json
{
  "configurations": {
    "Python: 当前文件": {
      "adapter": "debugpy",
      "configuration": {
        "request": "launch",
        "type": "python",
        "program": "${file}",
        "stopOnEntry": true
      }
    }
  }
}
```

> Python 调试需安装 `debugpy`：`pip install debugpy`

______________________________________________________________________

## 快捷键速查

| 快捷键 | 插件 | 功能 |
|--------|------|------|
| `F1` | NERDTree | 打开/关闭文件树 |
| `F5` | Vimspector | 启动/继续调试 |
| `F9` | Vimspector | 切换断点 |
| `F10` | Vimspector | 单步跳过 |
| `F11` | Vimspector | 单步进入 |
| `F12` | Vimspector | 单步跳出 |
| `gd` | vim-lsp | 跳转到定义 |
| `gr` | vim-lsp | 查看引用 |
| `K` | vim-lsp | 悬浮文档 |
| `<leader>rn` | vim-lsp | 重命名符号 |
| `[g` / `]g` | vim-lsp | 上/下一个诊断 |
| `gcc` | vim-commentary | 注释当前行 |
| `]c` / `[c` | vim-signify | 下/上一个 Git 变更 |
| `<leader>bb` | NERDTree | 添加书签 |

______________________________________________________________________

## 目录结构

```
vim/
├── vimrc              # Vim 主配置文件
├── install_gvim.sh    # 一键安装脚本
└── README.md          # 本文档
```
