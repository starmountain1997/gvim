-- Minimal Neovim configuration with lazy.nvim and render-markdown.nvim

-- Set leader key
vim.g.mapleader = ' '

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.termguicolors = true

-- Lazy.nvim configuration
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require('lazy').setup('plugins', {
  change_detection = {
    notify = false,
  },
})

-- Configure line wrap for markdown files with best practices
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    -- Basic wrap settings
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true

    -- Optimized break indent
    vim.opt_local.breakindentopt = 'shift:2,min:20,sbr'
    vim.opt_local.showbreak = '   ↪ '

    -- Text width and formatting
    vim.opt_local.textwidth = 80
    vim.opt_local.formatoptions = 'tcqnj'

    -- Spell checking for markdown
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'

    -- Improved navigation for wrapped lines
    vim.keymap.set('n', 'j', 'gj', { buffer = true, silent = true })
    vim.keymap.set('n', 'k', 'gk', { buffer = true, silent = true })
    vim.keymap.set('n', '0', 'g0', { buffer = true, silent = true })
    vim.keymap.set('n', '$', 'g$', { buffer = true, silent = true })
  end,
})