-- Treesitter configuration for syntax highlighting

return {
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
}