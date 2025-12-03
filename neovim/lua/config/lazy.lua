-- =============================================================================
-- === lazy.nvim 插件管理器配置 ===
-- =============================================================================

-- 定义 lazy.nvim 的安装路径
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 自动安装 lazy.nvim (引导逻辑)
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
vim.opt.rtp:prepend(lazypath)

-- 配置 lazy.nvim
require("lazy").setup({
  -- 导入插件列表
  spec = {
    { import = "plugins" },
  },

  -- 安装时的配色
  install = { colorscheme = { "habamax" } },

  -- 自动检查更新
  checker = { enabled = true },

  -- 性能优化：禁用不需要的内置插件
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "zipPlugin", "tarPlugin", -- 压缩文件支持 (如不需要可禁用)
        "tohtml", "tutor",                -- 转换HTML和教程
        "netrw", "netrwPlugin",           -- 禁用 netrw (已有 nvim-tree)
        "getscript", "getscriptPlugin",   -- 老旧脚本支持
        "vimball", "vimballPlugin",       -- 老旧包管理
        -- "matchit",                     -- 警告：不要禁用 matchit，% 跳转全靠它
      },
    },
  },
})
