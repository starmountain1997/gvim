-- =============================================================================
-- === Neovim 配置 (init.lua) ===
-- =============================================================================

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

-- =============================================================================
-- === 透明度设置 (Transparency) ===
-- =============================================================================
-- 既然你想要透明度，我们就直接把背景色抹掉。
-- 这是一个简单粗暴但有效的方法，不需要安装任何臃肿的插件。
-- "Simplicity is the ultimate sophistication." - Leonardo da Vinci (and Me)

local function set_transparency()
  local groups = {
    "Normal",         -- 普通文本
    "NormalFloat",    -- 浮动窗口
    "NormalNC",       -- 非当前窗口
    "SignColumn",     -- 符号列（如git状态）
    "EndOfBuffer",    -- 缓冲区结束符（波浪号）
    "MsgArea",        -- 消息区
    "NvimTreeNormal", -- 文件树主背景
    "NvimTreeNormalNC", -- 文件树非当前窗口背景
    "NvimTreeEndOfBuffer" -- 文件树结束符
  }

  for _, group in ipairs(groups) do
    -- 强制清除背景色 (guibg=NONE, ctermbg=NONE)
    -- 这里的 pcall 是为了防止某个组不存在时报错，虽然大部分都存在
    pcall(vim.api.nvim_set_hl, 0, group, { bg = "NONE", ctermbg = "NONE" })
  end
end

-- 在配色方案加载（ColorScheme）时自动触发，确保设置不被覆盖
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_transparency,
})

-- 立即执行一次
set_transparency()
