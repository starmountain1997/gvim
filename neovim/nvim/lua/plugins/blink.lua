return {
  'saghen/blink.cmp',
  build = 'cargo build --release',
  opts = {
    -- Ensure LSP completion is enabled
    sources = {
      default = { 'lsp', 'path', 'buffer' },
    },
    -- Preselect the first completion item
    completion = {
      list = {
        selection = {
          preselect = true,
        },
      },
    },
    -- Configure key mappings
    keymap = {
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-y>'] = { 'select_and_accept' },
    },
  },
}
