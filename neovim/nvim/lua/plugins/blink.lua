return {
  'saghen/blink.cmp',
  opts = {
    -- Ensure LSP completion is enabled
    sources = {
      default = { 'lsp', 'path', 'buffer' },
    },
  },
}
