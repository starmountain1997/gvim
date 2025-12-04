-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- 基本编辑器配置
-- 行号设置
vim.opt.number = true         -- 显示绝对行号
vim.opt.relativenumber = true  -- 显示相对行号

-- 高亮设置
vim.opt.cursorline = true     -- 高亮当前行
vim.opt.cursorcolumn = true   -- 高亮当前列

-- 鼠标支持
vim.opt.mouse = "a"           -- 启用所有模式的鼠标支持

-- Tab 和空格设置
vim.opt.tabstop = 4           -- Tab 显示为 4 个空格
vim.opt.shiftwidth = 4        -- 自动缩进为 4 个空格
vim.opt.expandtab = true      -- 将 Tab 转换为空格
vim.opt.softtabstop = 4       -- 编辑时 Tab 行为 like 4 个空格
vim.opt.smartindent = true    -- 智能缩进

-- 按键映射
vim.keymap.set("i", "jk", "<Esc>", { desc = "使用 jk 退出插入模式" })

require("config.lazy")
