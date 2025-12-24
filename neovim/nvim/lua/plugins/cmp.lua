-- Minimal nvim-cmp configuration for code completion
return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',  -- LSP source for nvim-cmp
    'hrsh7th/cmp-buffer',    -- Buffer completions
    'hrsh7th/cmp-path',      -- Path completions
  },
  config = function()
    local cmp = require('cmp')

    cmp.setup({
      snippet = {
        expand = function(args)
          -- Use Neovim's native snippet engine (requires nvim 0.10+)
          vim.snippet.expand(args.body)
        end,
      },
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      preselect = cmp.PreselectMode.Item,
      mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
      }),
    })
  end,
}
