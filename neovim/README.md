# Neovim 配置

这是一个最小化的 Neovim 配置，使用 lazy.nvim 作为插件管理器。

## 已配置的插件

### 1. nvim-treesitter
- 功能: 语法高亮和代码解析
- 支持的语言: markdown, markdown_inline, lua, javascript, typescript, json, yaml
- 配置文件: `nvim/lua/plugins/treesitter.lua`

### 2. conform.nvim
- 功能: 代码格式化工具
- 格式化器: 使用 Prettier
- 支持的文件类型: markdown, markdown.mdx, javascript, typescript, json, yaml
- 自动格式化: 在保存 Markdown 文件时自动格式化
- 快捷键: `<leader>ff` - 手动格式化当前缓冲区
- 配置文件: `nvim/lua/plugins/conform.lua`

### 3. render-markdown.nvim
- 功能: 增强 Markdown 文件的显示效果
- 依赖: nvim-treesitter
- 配置文件: `nvim/lua/plugins/render-markdown.lua`

### 4. nvim-tree.lua
- 功能: 文件侧边栏浏览器
- 依赖: nvim-web-devicons (文件图标)
- 配置文件: `nvim/lua/plugins/nvim-tree.lua`

## 基础配置

- 行号显示: 启用行号和相对行号
- 缩进设置: 2 个空格替代 tab，智能缩进
- 外观设置: 启用真彩色支持，高亮当前行
- Leader 键: 设置为空格键

## Markdown 特殊配置

- **自动换行**: 打开 Markdown 文件时自动启用行换行 (`wrap = true`)
- **智能断行**: 在单词边界处换行，保持单词完整 (`linebreak = true`)
- **换行缩进**: 换行后的文本保持适当的缩进 (`breakindent = true`)
- **优化缩进**: 使用 `breakindentopt = "shift:2,min:20,sbr"` 优化换行后的视觉效果
- **行宽限制**: 自动在 80 字符处换行，便于阅读 (`textwidth = 80`)
- **格式化选项**: `formatoptions = "tcqnj"` 提供智能的文本格式化
- **拼写检查**: 自动启用英文拼写检查 (`spell = true`)
- **改进导航**: j/k 键移动按显示行而非文件行，更适合换行模式
- **换行标记**: 使用 "   ↪ " 标记换行位置，保持对齐

## 安装和使用

1. 运行安装脚本将配置安装到系统：
   ```bash
   ./install_neovim.sh
   ```

2. 安装完成后，运行 `nvim` 启动 Neovim

3. 插件会在首次启动时自动安装

## 目录结构

```
nvim/
├── init.lua                    # 主配置文件
└── lua/
    └── plugins/
        ├── treesitter.lua      # Treesitter 配置
        ├── conform.lua         # 格式化配置
        ├── render-markdown.lua # Markdown 渲染配置
        └── nvim-tree.lua       # 文件浏览器配置
```