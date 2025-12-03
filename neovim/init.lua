-- =============================================================================
-- === Neovim 配置 (init.lua) ===
-- =============================================================================
-- 这是一个渐进式配置的起点文件
-- 用户会运行 install_neovim.sh 来安装此配置

-- 禁用内置的 netrw 文件浏览器，避免与 nvim-tree 冲突
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 启用 24-bit 真彩色支持，提供更好的颜色显示
vim.opt.termguicolors = true

-- 启用鼠标支持，允许在终端中使用鼠标
vim.opt.mouse = "a"

-- 显示相对行号，便于跳转
vim.opt.relativenumber = true

-- 高亮显示当前行
vim.opt.cursorline = true

-- 高亮显示当前列
vim.opt.cursorcolumn = true

-- 设置 leader 键为空格键，这是 Neovim 社区的标准配置
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 添加 Lua 模块路径，让 Neovim 能找到我们的配置模块
vim.opt.runtimepath:prepend(vim.fn.stdpath("config") .. "/lua")

-- 加载 lazy.nvim 插件管理器配置
require("config.lazy")