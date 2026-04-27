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

## 插件配置

### [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)

**安装方式**

```lua
-- init.lua
return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false,
      update_debounce = 100,
      max_file_length = 40000,
    })
  end,
}
```

**基本用法**

- `:Gitsigns toggle_signs` — 显示/隐藏 Git 状态标记
- `:Gitsigns toggle_numhl` — 显示/隐藏行号高亮
- `:Gitsigns toggle_current_line_blame` — 显示/隐藏当前行 blame
- `]c` / `[c` — 跳转到上一个/下一个改动块
