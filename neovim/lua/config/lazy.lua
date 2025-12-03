-- =============================================================================
-- === lazy.nvim 插件管理器配置 ===
-- =============================================================================
-- 这是 lazy.nvim 的配置模块，负责初始化插件管理器并加载插件列表

-- 定义 lazy.nvim 的安装路径
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 如果 lazy.nvim 不存在，则自动克隆安装
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "错误: 无法克隆 lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\n按任意键退出..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- 将 lazy.nvim 添加到运行时路径
vim.opt.rtp:prepend(lazypath)

-- 配置 lazy.nvim
require("lazy").setup({
  -- 导入插件列表
  spec = {
    { import = "plugins" },
  },

  -- 安装配置
  install = {
    -- 启动时自动安装缺失的插件
    missing = true,
    -- 安装插件时使用的颜色主题
    colorscheme = { "habamax" },
  },

  -- 插件更新检查
  checker = {
    enabled = true,      -- 启用自动更新检查
    frequency = 3600,    -- 每3600秒（1小时）检查一次
  },

  -- 性能配置
  performance = {
    rtp = {
      -- 禁用一些不常用的内置插件以提升性能
      disabled_plugins = {
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  },

  -- UI 配置
  ui = {
    -- 使用自定义边框
    border = "rounded",
    -- 图标配置
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})

print("✅ lazy.nvim 插件管理器已加载")