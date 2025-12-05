return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },

  -- use a release tag to download pre-built binaries
  version = '1.*',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- Ensure LSP completion is enabled
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
}
