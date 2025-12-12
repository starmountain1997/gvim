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
require('lazy').setup({
  -- Treesitter for syntax highlighting (required by render-markdown)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'markdown',
          'markdown_inline',
          'lua',
          'javascript',
          'typescript',
          'json',
          'yaml',
        },
        highlight = { enable = true },
      })
    end,
  },

  -- Conform.nvim for formatting
  {
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          markdown = { 'prettier' },
          ['markdown.mdx'] = { 'prettier' },
          -- You can add other filetypes here as needed
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          json = { 'prettier' },
          yaml = { 'prettier' },
        },
        format_on_save = function(bufnr)
          -- Only format markdown files on save
          if vim.bo[bufnr].filetype == 'markdown' or vim.bo[bufnr].filetype == 'markdown.mdx' then
            return {
              timeout_ms = 500,
              lsp_format = 'fallback',
            }
          end
        end,
        log_level = vim.log.levels.ERROR,
        notify_on_error = true,
        notify_no_formatters = true,
      })

      -- Key mappings for formatting
      vim.keymap.set({ 'n', 'v' }, '<leader>ff', function()
        require('conform').format({
          async = false,
          lsp_format = 'fallback',
        })
      end, { desc = 'Format buffer' })
    end,
  },

  -- Render Markdown plugin
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      -- Minimal configuration - only enable the plugin
      require('render-markdown').setup({})
    end,
  },
})